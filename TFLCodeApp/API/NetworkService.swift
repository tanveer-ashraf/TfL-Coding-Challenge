//
//  NetworkService.swift
//  TFLCodeApp
//
//  Created by Tanveer Ashraf on 12/11/2023.
//

import Foundation

class NetworkService {
    private let apiManager: APIManaging
    private let baseUrl = "https://api.tfl.gov.uk"

    init(apiManager: APIManaging = APIManager.shared) {
        self.apiManager = apiManager
    }

    func fetchTubeStatuses(completion: @escaping (Result<[TubeLineStatus], APIError>) -> Void) {
        let request = Request<[TubeLineStatus]>(path: "\(baseUrl)/Line/Mode/Tube/Status")
        apiManager.execute(request, completion: completion)
    }
}
