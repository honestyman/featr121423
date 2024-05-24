//
//  String.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/12/24.
//

import Foundation

extension String {
    static var appName: String {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String  {
            return appName
        } else {
            return "Featrrr"
        }
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

extension String {
    // Adapted from ChatGPT 3.5
    public static func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let date = Date()
        
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    public static func formatCurrency(_ currency: Double) -> String {
        return currency.formatted(.currency(code: "USD"))
    }
    
    public static func formatTime(_ time: Double) -> String {
        return  String(format: "%.2f", time)
    }
    
}
