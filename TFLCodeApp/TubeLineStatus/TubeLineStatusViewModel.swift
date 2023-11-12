//
//  TubeLineStatusViewModel.swift
//  TFLCodeApp
//
//  Created by Tanveer Ashraf on 12/11/2023.
//

import Foundation

class TubeLineStatusViewModel {
    private let networkService: NetworkService
    private let cacheService: CacheService
    var tubeLineStatuses: [TubeLineStatus] = []
    var onError: ((APIError) -> Void)?
    var onTubeStatusesLoaded: (() -> Void)?

    init(networkService: NetworkService, cacheService: CacheService = CacheService()) {
        self.networkService = networkService
        self.cacheService = cacheService
        self.tubeLineStatuses = cacheService.getCachedTubeStatuses() ?? []
    }

    func loadTubeStatuses() {
        networkService.fetchTubeStatuses { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let statuses):
                    self?.tubeLineStatuses = statuses
                    self?.cacheService.cacheTubeStatuses(statuses)
                    self?.onTubeStatusesLoaded?()
                case .failure(let error):
                    self?.tubeLineStatuses = self?.cacheService.getCachedTubeStatuses() ?? []
                    self?.onError?(error)
                }
            }
        }
    }
}
