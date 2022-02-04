//
//  AudienceInfo.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 23.01.22.
//

import Foundation

struct AudienceInfo {
    let demographics: [Gender: [AgeGroup: Int]]
    let cities: [(String, Int)]
    let lastUpdate: Date
}

extension AudienceInfo {
    
    enum Gender: String, CaseIterable, Codable, Identifiable, CustomStringConvertible {
        
        case female = "F"
        case male = "M"
        case unknown = "U"
        
        var id: Self { self }
        
        var description: String {
            switch self {
            case .female: return "Weibliche Follower"
            case .male: return "Männliche Follower"
            case .unknown: return "Genderfluide Follower"
            }
        }
    }
    
    enum AgeGroup: String, CaseIterable, Codable, Identifiable, CustomStringConvertible {
        
        case from13To17 = "13-17"
        case from18To24 = "18-24"
        case from25To34 = "25-34"
        case from35To44 = "35-44"
        case from45To54 = "45-54"
        case from55To64 = "55-64"
        case from65 = "65+"
        
        var id: Self { self }
        
        var description: String {
            rawValue.replacingOccurrences(of: "-", with: " - ")
        }
    }
}

extension AudienceInfo: Codable {
    
    private struct APIContainer: Codable {
        
        enum CodingKeys: String, CodingKey { case data }
        
        let data: [Entry]
        
        struct Entry: Codable {
            let name: String
            let values: [Value]
            
            struct Value: Codable {
                let value: [String: Int]
                let end_time: Date
            }
        }
    }
    
    enum DecodingError: Error {
        case error
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: APIContainer.CodingKeys.self)
        let entries = try container.decode([APIContainer.Entry].self, forKey: .data)
        
        guard
            entries.count == 2,
            entries.allSatisfy({ $0.values.count == 1 }),
            let demographics = entries.first(where: { $0.name == InstagramAPI.Metric.audienceGenderAge.rawValue })?.values.first?.value,
            let cities = entries.first(where: { $0.name == InstagramAPI.Metric.audienceCity.rawValue })?.values.first?.value
        else { throw DecodingError.error }
        
        lastUpdate = entries[0].values[0].end_time
     
        self.cities = cities.sorted { $0.value > $1.value }
        
        var demographicsDict: [Gender: [AgeGroup: Int]] = [:]
        
        for (key, value) in demographics {
            let components = key.split(separator: ".")
            
            guard
                components.count == 2,
                let gender = Gender(rawValue: String(components[0])),
                let ageGroup = AgeGroup(rawValue: String(components[1]))
            else { throw DecodingError.error }
            
            var genderDict = demographicsDict[gender] ?? [:]
            genderDict[ageGroup] = value
            demographicsDict[gender] = genderDict
        }
        
        self.demographics = demographicsDict
    }
    
    func encode(to encoder: Encoder) throws {
        let apiDemographics = demographics
            .sorted { _, _ in true }
            .flatMap { (gender, value) in
                value.map { (ageGroup, value) in
                    ("\(gender.rawValue).\(ageGroup.rawValue)", value)
                }
            }
        
        let data = [
            APIContainer.Entry(
                name: InstagramAPI.Metric.audienceGenderAge.rawValue,
                values: [
                    APIContainer.Entry.Value(
                        value: Dictionary(uniqueKeysWithValues: apiDemographics),
                        end_time: lastUpdate
                    )
                ]
            ),
            APIContainer.Entry(
                name: InstagramAPI.Metric.audienceCity.rawValue,
                values: [
                    APIContainer.Entry.Value(
                        value: Dictionary(uniqueKeysWithValues: cities),
                        end_time: lastUpdate
                    )
                ]
            )
        ]
        
        var container = encoder.container(keyedBy: APIContainer.CodingKeys.self)
        try container.encode(data, forKey: .data)
    }
}
