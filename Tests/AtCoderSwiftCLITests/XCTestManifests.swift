import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(AtCoderSwiftCLITests.allTests),
        ]
    }
#endif
