import XCTest

#if os(macOS)
@testable import CocoaUIMacOS
#else
@testable import CocoaUIiOS
#endif

final class CocoaUITests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(CocoaUIMacOS.version, "Hello, World!")
    }
}
