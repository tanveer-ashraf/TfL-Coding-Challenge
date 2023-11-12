//
//  TubeLineStatusViewModelTests.swift
//  TFLCodeAppTests
//
//  Created by Tanveer Ashraf on 12/11/2023.
//

import XCTest
@testable import TFLCodeApp

class TubeLineStatusViewModelTests: XCTestCase {
    var viewModel: TubeLineStatusViewModel!
    var mockNetworkService: MockNetworkService!
    var mockCacheService: MockCacheService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockCacheService = MockCacheService()
        viewModel = TubeLineStatusViewModel(networkService: mockNetworkService, cacheService: mockCacheService)
    }

    func testLoadTubeStatusesSuccessUpdatesViewModel() {
        let expectedStatuses = [TubeLineStatus(id: "1", name: "Test Line", lineStatuses: [])]
        mockNetworkService.mockResult = .success(expectedStatuses)

        let expectation = XCTestExpectation(description: "Fetch statuses success")
        viewModel.loadTubeStatuses()

        viewModel.onTubeStatusesLoaded = {
            XCTAssertEqual(self.viewModel.tubeLineStatuses, expectedStatuses)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadTubeStatusesFailureUsesCache() {
        let expectedStatuses = [TubeLineStatus(id: "2", name: "Cached Line", lineStatuses: [])]
        mockNetworkService.mockResult = .failure(.networkError)
        mockCacheService.cacheTubeStatuses(expectedStatuses)

        let expectation = XCTestExpectation(description: "Network failure, use cache")
        viewModel.loadTubeStatuses()

        viewModel.onError = { error in
            XCTAssertEqual(self.viewModel.tubeLineStatuses, expectedStatuses)
            XCTAssertEqual(error, .networkError)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // Additional test cases for other scenarios...

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockCacheService = nil
        super.tearDown()
    }
}

class MockCacheService: CacheService {
    var cachedStatuses: [TubeLineStatus]?

    override func cacheTubeStatuses(_ statuses: [TubeLineStatus]) {
        cachedStatuses = statuses
    }

    override func getCachedTubeStatuses() -> [TubeLineStatus]? {
        return cachedStatuses
    }
}
