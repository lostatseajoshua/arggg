//
//  ArgumentError.swift
//  Arguments
//
//  Created by Joshua Alvarado on 9/29/18.
//

public enum ArgumentError: Error, Equatable {
    case emptyArguments
    case missingRequiredArguments(args: Set<String>)
    case unknownArgument(arg: String)
}
