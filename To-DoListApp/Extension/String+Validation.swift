//
//  String+Validation.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 22.01.2025.
//

import Foundation

extension String {
    enum ValidationError: Error {
        case emptyInput
        case invalidFormat
    }
    
    func validate() throws -> String {
        guard !self.isEmpty else {
            throw ValidationError.emptyInput
        }
        let numberOnlyPredicate = NSPredicate(format: "SELF MATCHES %@", "^[0-9]+$")
        if numberOnlyPredicate.evaluate(with: self) {
            throw ValidationError.invalidFormat
        }
        return self
    }
}
