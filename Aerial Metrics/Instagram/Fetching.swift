//
//  Fetching.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 24.01.22.
//

import Foundation

extension InstagramAPI {

    func fetchAccountInfo() async -> Result<AccountInfo, Error> {
        await fetch(AccountInfo.self, from: accountInfoURL)
    }
    
    func fetchAudienceInfo() async -> Result<AudienceInfo, Error> {
        await fetch(AudienceInfo.self, from: audienceInfoURL)
    }
    
    func fetchInsights() async -> Result<Insights, Error> {
        await fetch(Insights.self, from: insightsURL)
    }
    
    func fetchMediaItems() async -> Result<[MediaItem], Error> {
        switch await fetch(MediaItem.List.self, from: mediaItemListURL) {
        case .failure(let error): return .failure(error)
        case .success(let mediaItemList):
            var mediaItems = mediaItemList.data
            
            let insightTasks = mediaItems.map { item in
                Task { await fetch(MediaItem.Insights.self, from: mediaItemInsightsURL(mediaItem: item)) }
            }

            for (index, task) in insightTasks.enumerated() {
                switch await task.value {
                case .failure(let error): return .failure(error)
                case .success(let insights): mediaItems[index].insights = insights
                }
            }
            
            return .success(mediaItems)
        }
    }
    
    private func fetch<T: Decodable>(_ type: T.Type, from url: URL) async -> Result<T, Error> {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = { String(data: data, encoding: .utf8) }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return .success(try decoder.decode(T.self, from: data))
            } catch {
                if let json = json() {
                    if json.contains("Malformed access token") || json.contains("The access token could not be decrypted") {
                        return .failure(.malformedAccessToken)
                    }
                }

                return .failure(.decoding(message: "\(error.localizedDescription)\n\n\(error)"))
            }
        } catch {
            return .failure(.unknown(message: error.localizedDescription))
        }
    }
}

extension InstagramAPI {

    enum Error: Swift.Error {
        case malformedAccessToken
        case decoding(message: String)
        case unknown(message: String)
    }
}
