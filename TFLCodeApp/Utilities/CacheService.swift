//
//  CacheService.swift
//  TFLCodeApp
//
//  Created by Tanveer Ashraf on 12/11/2023.
//

import Foundation

class CacheService {
    private let defaults = UserDefaults.standard
    private let tubeStatusCacheKey = "TubeStatusCache"

    func cacheTubeStatuses(_ statuses: [TubeLineStatus]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(statuses) {
            defaults.set(encoded, forKey: tubeStatusCacheKey)
        }
    }

    func getCachedTubeStatuses() -> [TubeLineStatus]? {
        if let savedData = defaults.object(forKey: tubeStatusCacheKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedStatuses = try? decoder.decode([TubeLineStatus].self, from: savedData) {
                return loadedStatuses
            }
        }
        return nil
    }
}
