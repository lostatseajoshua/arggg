//
//  CommandLineArgument.swift
//  Arguments
//
//  Created by Joshua Alvarado on 9/29/18.
//

public struct CommandLineArgument: Hashable {
    public let name: String
    public let options: Set<String>?
    public let parameters: Set<String>
    public let required: Bool

    public var hashValue: Int {
        return name.hashValue
    }

    public init(name: String, options: Set<String>? = nil, parameters: Set<String>, required: Bool = false) {
        self.name = name
        self.options = options
        self.parameters = parameters
        self.required = required
    }
}
