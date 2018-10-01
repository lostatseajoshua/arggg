//
//  CommandLineArgument.swift
//  Arguments
//
//  Created by Joshua Alvarado on 9/29/18.
//

struct CommandLineArgument: Hashable {
    let name: String
    let options: Set<String>?
    let parameters: Set<String>
    let required: Bool

    var hashValue: Int {
        return name.hashValue
    }
}
