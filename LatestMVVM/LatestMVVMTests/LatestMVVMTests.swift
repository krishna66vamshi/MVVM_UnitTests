//
//  LatestMVVMTests.swift
//  LatestMVVMTests
//
//  Created by Hyper Thread Solutions Pvt Ltd on 06/01/24.
//

import XCTest
@testable import LatestMVVM

final class LatestMVVMTests: XCTestCase {
    
    var sut: UserListViewModel!
    var mockAPIService: MockApiService!
    
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockApiService()
        sut = UserListViewModel(webservice:mockAPIService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func test_fetch_users_count(){
        
        let expectation = XCTestExpectation(description: "userscount")
        sut.fetchUserData()
        
//        wait(for:[expectation], timeout: 15)
        
        XCTAssertEqual(sut.userViewModel.count, 13 )
        XCTAssertEqual(sut.userViewModel.first?.title ?? "", "Big Buck Bunny" )
        
    }
    
}

class MockApiService: APIServiceProtocol {
    
    func callAPI<T>(url: String, modelType: T.Type, completionHandler: @escaping (Result<T, LatestMVVM.NetworkError>) -> ()) where T : Decodable, T : Encodable {
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let users = try! JSONDecoder().decode(T.self, from: data)
        completionHandler(.success(users))
    }
}
