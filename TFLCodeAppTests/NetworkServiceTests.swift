//
//  NetworkServiceTests.swift
//  TFLCodeAppTests
//
//  Created by Tanveer Ashraf on 12/11/2023.
//

import XCTest
@testable import TFLCodeApp

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var mockAPIManager: MockAPIManager!

    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        networkService = NetworkService(apiManager: mockAPIManager)
    }

    func testFetchTubeStatusesSuccess() {
        let expectation = XCTestExpectation(description: "Fetch tube statuses success")
        let expectedStatuses = [TubeLineStatus(id: "1", name: "Test Line", lineStatuses: [])]
        mockAPIManager.mockResult = .success(expectedStatuses)

        networkService.fetchTubeStatuses { result in
            if case .success(let statuses) = result {
                XCTAssertEqual(statuses, expectedStatuses)
            } else {
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchTubeStatusesFailure() {
        let expectation = XCTestExpectation(description: "Fetch tube statuses failure")
        mockAPIManager.mockResult = .failure(.networkError)

        networkService.fetchTubeStatuses { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, .networkError)
            } else {
                XCTFail("Expected failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    override func tearDown() {
        networkService = nil
        mockAPIManager = nil
        super.tearDown()
    }
}

class MockNetworkService: NetworkService {
    var mockResult: Result<[TubeLineStatus], APIError>?

    override func fetchTubeStatuses(completion: @escaping (Result<[TubeLineStatus], APIError>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}

class MockAPIManager: APIManaging {
    var mockResult: Result<Any, APIError>?

    func execute<Value>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void) where Value : Decodable {
        guard let result = mockResult else {
            fatalError("Mock result not set")
        }

        switch result {
        case .success(let value):
            if let value = value as? Value {
                completion(.success(value))
            } else {
                fatalError("Type mismatch in MockAPIManager")
            }
        case .failure(let error):
            completion(.failure(error as! APIError))
        }
    }
}
