//
//  Arguments.swift
//  Arguments
//
//  Created by Joshua Alvarado on 9/29/18.
//

import Foundation

public struct Arguments {
    // MARK: - Static Properties (Public, Private)

    public static let helpArg = CommandLineArgument(name: "Help", options:nil, parameters: ["--help", "-help", "--h", "-h", "help", "h"], required: false)

    // MARK: - Public Properties

    public let arguments: Set<CommandLineArgument>
    public let requiredArguments: Set<CommandLineArgument>

    // MARK: - Private Properties

    private let argumentMap: [String: CommandLineArgument]

    // MARK: - Init

    public init(arguments: Set<CommandLineArgument>) {
        var argsMap = [String: CommandLineArgument]()
        var reqArgs = Set<CommandLineArgument>()

        for arg in arguments {
            arg.parameters.forEach { argsMap[$0] = arg }

            if arg.required {
                reqArgs.insert(arg)
            }
        }

        self.arguments = arguments
        argumentMap = argsMap
        requiredArguments = reqArgs
    }

    // MARK: - Public Methods

    public func readCommandLineArguments(args: [String]) throws -> Set<CommandLineArgument> {
        var parsedArguments = [String: CommandLineArgument]()

        var commandLineArguments = args

        if commandLineArguments.count < 2 && !requiredArguments.isEmpty {
            throw ArgumentError.emptyArguments
        }

        commandLineArguments.removeFirst() // ignore project name

        for argument in commandLineArguments {
            if let commandLineArgument = argumentMap[argument] {
                parsedArguments[argument] = commandLineArgument
            } else {
                throw ArgumentError.unknownArgument(arg: argument)
            }
        }

        let parsedArgumentsValues = Set<CommandLineArgument>(parsedArguments.values)
        let remainingRequiredArguments = requiredArguments.subtracting(parsedArgumentsValues)
        if (!remainingRequiredArguments.isEmpty) {
            throw ArgumentError.missingRequiredArguments(args: Set<String>(remainingRequiredArguments.map({ $0.name })))
        }

        return parsedArgumentsValues
    }
}
