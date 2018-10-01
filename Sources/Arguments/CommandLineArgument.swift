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
}
