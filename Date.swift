//
//  Date.swift
//  runclub_tut
//
//  Created by Ned hulseman on 7/11/25.
//

import Foundation

extension Date {
    func DateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}
