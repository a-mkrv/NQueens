//
//  PlaceholderTests.swift
//  NQueensTests
//

import XCTest
@testable import NQueens

@MainActor
final class PlaceholderTests: XCTestCase {
    func test_mocks_available() {
        _ = MockSettingsService()
        _ = MockGameHistoryService()
        _ = MockGameValidationService()
        _ = Sample.game()
    }
}
