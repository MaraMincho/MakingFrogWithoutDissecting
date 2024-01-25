//
//  NetworkTest.swift
//
//  Created by MaraMincho on 1/17/24.
//

import Combine
@testable import PracticeCleanArchitecture
import XCTest

// MARK: - TestEndPoint

private enum TestEndPoint: EndPoint {
  case idle

  var baseURL: String { "http://fake.com" }

  var path: String? { "api" }

  var method: HTTPMethod { .get }

  var query: Encodable? { nil }

  var body: Encodable? { ["fake": "data"] }

  var headers: [String: String] { [:] }
}

// MARK: - TestEndPoint2

private struct TestEndPoint2: EndPoint {
  var path: String?
  var method: HTTPMethod = .get
  var headers: [String: String] = [:]
  var baseURL: String = "base"
  var query: Encodable? = nil
  var body: Encodable? = nil
}

// MARK: - NetworkTest

final class NetworkTest: XCTestCase {
  var subscriptions = Set<AnyCancellable>()

  override func setUpWithError() throws {
    subscriptions.removeAll()
  }

  override func tearDownWithError() throws {
    subscriptions.removeAll()
  }

  // MARK: - EndPoint

  func test_BaseURL을포함하여_URLRequst를생성하고_URL이정상적으로반영되었는지확인한다() throws {
    // Assign
    let endPoint = TestEndPoint2(baseURL: "base")

    // Act
    let targetURL = try endPoint.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base"))
  }

  func test_baseURL과Path를포함하여_URLRequst를생성하고_URL이정상적으로생성되었는지확인한다() throws {
    // Assign
    let endPoint = TestEndPoint2(path: "api", baseURL: "base")

    // Act
    let targetURL = try endPoint.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base/api"))
  }

  func test_쿼리를넣어서_request를생성하고_URL반영을확인한다() throws {
    // Assign
    let endPoint = TestEndPoint2(path: "api", baseURL: "base", query: ["Some": "Time"])
    // Act
    let targetURL = try endPoint.request().url

    // Assert
    XCTAssertNotNil(targetURL)
    XCTAssertEqual(targetURL, URL(string: "base/api?Some=Time"))
  }

  func test_바디를넣어서_request를생성하고_request와같은지확인한다() throws {
    // Assign
    let bodyString = "바디"
    let endPoint = TestEndPoint2(body: bodyString)

    // Act
    let requestBody = try endPoint.request().httpBody

    // Assert
    XCTAssertEqual(bodyString, try JSONDecoder().decode(String.self, from: requestBody!))
  }

  func test_헤더를넣어서_request를생성하고_넣은헤더값과비교한다() throws {
    // Assign
    let header = ["header": "1", "Content-Type": "Json"]
    let endpoint = TestEndPoint2(headers: header)

    // Act
    let requestHeader = try endpoint.request().allHTTPHeaderFields

    // Assert
    XCTAssertEqual(header, requestHeader)
  }

  // MARK: - Provider

  func test_TestEndPoint를통해Provider를만들고_목세션을을통해서_정상적으로데이터가오는지확인한다() {
    // Assign
    let expectation = XCTestExpectation(description: "Expectation")
    let defaultData = "Test".data(using: .utf8)
    let httpResponse = HTTPURLResponse(url: URL(string: "www.naver.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])!
    let urlResponse = httpResponse as URLResponse
    let mockSession = MockSession(
      defaultMockData: defaultData,
      mockDataByURL: [:],
      response: urlResponse
    )
    let provider = Provider<TestEndPoint>(session: mockSession)

    // Act
    provider.requestData(.idle).sink { _ in
    } receiveValue: { data in
      let str = String(data: data, encoding: .utf8)
      print(str!)
      if str == "Test" {
        expectation.fulfill()
      }
    }
    .store(in: &subscriptions)

    // Assert
    wait(for: [expectation], timeout: 2)
  }

  func test_path가있는Endpoint의request_데이터요청을하고_정상적으로가져오는지확인한다() {
    // Assign
    let expectation = XCTestExpectation(description: "Expectation")
    let testData = "Test".data(using: .utf8)!
    let httpResponse = HTTPURLResponse(url: URL(string: "www.naver.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])!
    let urlResponse = httpResponse as URLResponse
    let mockSession = MockSession(
      defaultMockData: nil,
      mockDataByURL: ["http://fake.com/api": testData],
      response: urlResponse
    )
    let provider = Provider<TestEndPoint>(session: mockSession)

    // Action
    provider.requestData(.idle)
      .sink { _ in
      } receiveValue: { data in
        if data == testData {
          expectation.fulfill()
        }
      }
      .store(in: &subscriptions)

    // Assert
    wait(for: [expectation], timeout: 2)
  }

  func test_404리스폰스를생성하고_데이터요청을하고_정상적으로에러를확인한다() {
    // Assign
    let expectation = XCTestExpectation(description: "Expectation")
    let testData = "Test".data(using: .utf8)!
    let httpResponse = HTTPURLResponse(url: URL(string: "www.naver.com")!, statusCode: 404, httpVersion: nil, headerFields: [:])!
    let urlResponse = httpResponse as URLResponse
    let mockSession = MockSession(
      defaultMockData: nil,
      mockDataByURL: ["http://fake.com/api": testData],
      response: urlResponse
    )
    let provider = Provider<TestEndPoint>(session: mockSession)

    // Action
    provider.requestData(.idle)
      .sink { completion in
        switch completion {
        case .failure:
          expectation.fulfill()
        default:
          break
        }
      } receiveValue: { _ in
      }
      .store(in: &subscriptions)

    // Assert
    wait(for: [expectation], timeout: 2)
  }
}
