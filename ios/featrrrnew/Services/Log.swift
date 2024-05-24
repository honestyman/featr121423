//
//  Log.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/22/24.
//

import Foundation
import os

struct Log {
    
    private static let logger = Logger()
    
    public static func c(_ message: String) {
        logger.critical("\(message, privacy: .public)")
    }
    public static func w(_ message: String) {
        logger.warning("\(message, privacy: .public)")
    }
    public static func e(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }
    public static func d(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }
    public static func i(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }
}
