import XCTest
@testable import Arguments

final class ArgumentsTests: XCTestCase {

    func testEmptyCommandLineArguments() {
        let test = CommandLineArgument(name: "Test", options: nil, parameters: ["test", "--test", "t"], required: true)
        let arg = Arguments(arguments: [test])
        XCTAssertThrowsError(try arg.readCommandLineArguments(args: ["programName"])) { (error) in
            guard let argError = error as? ArgumentError else {
                XCTFail("error failed to cast")
                return
            }
            XCTAssertEqual(argError, ArgumentError.emptyArguments)
        }

        XCTAssertThrowsError(try arg.readCommandLineArguments(args: [])) { (error) in
            guard let argError = error as? ArgumentError else {
                XCTFail("error failed to cast")
                return
            }
            XCTAssertEqual(argError, ArgumentError.emptyArguments)
        }
    }

    func testValidYoCommand() {
        let test = CommandLineArgument(name: "Test", options: nil, parameters: ["test", "--test", "t"], required: true)
        let arg = Arguments(arguments: [test])

        for param in test.parameters {
            XCTAssertNoThrow(try arg.readCommandLineArguments(args: ["progamName", param]))
        }
    }

    func testHelpCommand() {
        let helpArg = Arguments.helpArg
        let arg = Arguments(arguments: [helpArg])
        for param in helpArg.parameters {
            XCTAssertNoThrow(try arg.readCommandLineArguments(args: ["progamName", param]))
        }
    }

    func testInvalidHelpCommand() {
        let arg = Arguments(arguments: [Arguments.helpArg])
        let commandLineArguments = ["progamName", "--yelp"]
        XCTAssertThrowsError(try arg.readCommandLineArguments(args: commandLineArguments)) { (error) in
            guard let argError = error as? ArgumentError else {
                XCTFail("error failed to cast")
                return
            }
            XCTAssertEqual(argError, ArgumentError.unknownArgument(arg: commandLineArguments[1]))
        }
    }

    func testMissingRequiredCommandLineArguments() {
        let test = CommandLineArgument(name: "Test", options: nil, parameters: ["test", "--test", "t"], required: true)
        let tests = CommandLineArgument(name: "Tests", options: nil, parameters: ["tests"], required: false)
        let arg = Arguments(arguments: [test, tests])
        XCTAssertThrowsError(try arg.readCommandLineArguments(args: ["programName", "tests"])) { (error) in
            guard let argError = error as? ArgumentError else {
                XCTFail("error failed to cast")
                return
            }
            XCTAssertEqual(argError, ArgumentError.missingRequiredArguments(args: [test.name]))
        }
    }

    func testValidRequiredCommand() {
        let test0 = CommandLineArgument(name: "Test0", options: nil, parameters: ["--test"], required: true)
        let test1 = CommandLineArgument(name: "Test1", options: nil, parameters: ["t"], required: false)
        let test2 = CommandLineArgument(name: "Test2", options: nil, parameters: ["test"], required: true)
        let arguments = Set([test0, test1, test2])
        let arg = Arguments(arguments: arguments)
        let commandLineArguments = ["progamName", test0.parameters.first!, test2.parameters.first!]

        do {
            let args = try arg.readCommandLineArguments(args: commandLineArguments)
            XCTAssertNotNil(args)
            XCTAssertEqual(args, [test0, test2])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    static var allTests = [
        ("testEmptyCommandLineArguments", testEmptyCommandLineArguments),
        ("testValidYoCommand", testValidYoCommand),
        ("testHelpCommand", testHelpCommand),
        ("testInvalidHelpCommand", testInvalidHelpCommand),
        ("testMissingRequiredCommandLineArguments", testMissingRequiredCommandLineArguments),
        ("testValidRequiredCommand", testValidRequiredCommand),
    ]
}
