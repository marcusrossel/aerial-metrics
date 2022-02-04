//
//  DatabaseManager.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 29.01.22.
//

import Foundation

enum DatabaseManager {
    
    static var filePath: URL? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .last?
            .appendingPathComponent("Aerial Metrics", isDirectory: true)
            .appendingPathComponent("database")
    }
    
    static func createDatabase() -> CreationError? {
        guard let path = filePath else { return .invalidURL }
        
        do {
            try FileManager.default.createDirectory(at: path.deletingLastPathComponent(), withIntermediateDirectories: true)
            try Data().write(to: path)
            return nil
        } catch {
            return .unknown(message: error.localizedDescription)
        }
    }
    
    static func loadDatabase() -> Result<Database, LoadError> {
        guard let path = filePath else { return .failure(.invalidURL) }
        
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                return .success(try decoder.decode(Database.self, from: data))
            } catch {
                // An empty file should be interpreted as an empty (default) database.
                if let json = String(data: data, encoding: .utf8), json.isEmpty {
                    return .success(Database())
                }
                
                return .failure(.decoding(message: "\(error.localizedDescription)\n\n\(error)"))
            }
        } catch {
            return .failure(.unknown(message: error.localizedDescription))
        }
    }
    
    static func write(database: Database) -> WriteError? {
        guard let path = filePath else { return .invalidURL }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(database)
            
            do {
                try data.write(to: path)
                return nil
            } catch {
                return .unknown(message: error.localizedDescription)
            }
        } catch {
            return .encoding(message: "\(error.localizedDescription)\n\n\(error)")
        }
    }
    
    private static func fetchInstagramInfos(api: InstagramAPI) async  ->
        Result<(AccountInfo, AudienceInfo, Insights, [MediaItem]), InstagramAPI.Error> {
        async let accountInfo = api.fetchAccountInfo()
        async let audienceInfo = api.fetchAudienceInfo()
        async let insights = api.fetchInsights()
        async let mediaItems = api.fetchMediaItems()
        let results = await (accountInfo: accountInfo, audienceInfo: audienceInfo, insights: insights, mediaItems: mediaItems)
        
        switch results {
        case let (.failure(error), _, _, _): return .failure(error)
        case let (_, .failure(error), _, _): return .failure(error)
        case let (_, _, .failure(error), _): return .failure(error)
        case let (_, _, _, .failure(error)): return .failure(error)
        case let (.success(accountInfo), .success(audienceInfo), .success(insights), .success(mediaItems)):
            return .success((accountInfo, audienceInfo, insights, mediaItems))
        }
    }
    
    static func update(database: Database, api: InstagramAPI) async -> Result<Database, InstagramAPI.Error> {
        switch await fetchInstagramInfos(api: api) {
        case let .failure(error): return .failure(error)
        case let .success((accountInfo, audienceInfo, insights, mediaItems)):
            var database = database
            database.merge(accountInfo)
            database.merge(audienceInfo)
            database.merge(insights)
            database.merge(mediaItems)
            return .success(database)
        }
    }
}

extension DatabaseManager {
    
    enum CreationError: Swift.Error {
        case invalidURL
        case unknown(message: String)
    }
    
    enum LoadError: Swift.Error {
        case invalidURL
        case decoding(message: String)
        case unknown(message: String)
    }
    
    enum WriteError: Swift.Error {
        case invalidURL
        case encoding(message: String)
        case unknown(message: String)
    }
}
