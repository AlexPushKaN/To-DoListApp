//
//  String+DataConverter.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 27.01.2025.
//

import Foundation

extension String {
    func toType<T>() -> T? {
        switch T.self {
        case is Date.Type:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let dateValue = dateFormatter.date(from: self) as? T {
                return dateValue
            }
        case is Data.Type:
            if let dataValue = Data(base64Encoded: self) as? T {
                return dataValue
            }
        default:
            break
        }
        return nil
    }
}
