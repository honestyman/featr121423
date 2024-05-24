//
//  Styling+Base.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/25/24.
//

import Foundation

/**
 paddingHorizontal - app wide padding
 paddingHorizontalInset - higher
 rowPadding
 cornerRadius
 smallCornerRadius
 iconRadius (toolbar, edit image)
 smallIconRadius
 
 
 */

import SwiftUI
class Style {
    static var font = FontStyle()
}
class FontStyle {
    
    var title = Font.custom("WorkSans-Bold", size: 24)
    var title2 = Font.custom("WorkSans-Black",size: 20)
    var title3 = Font.custom("WorkSans-Black", size: 16)
    var title4 = Font.custom("WorkSans-Light", size: 15)
    var caption = Font.custom("WorkSans-SemiBold", size: 14)
    var caption2 = Font.custom("WorkSans-Italic", size: 9)
    var body = Font.custom("WorkSans-Regular", size: 14)
    var body2 = Font.custom("WorkSans-Italic", size: 12)
    var button = Font.custom("WorkSans-Bold", size: 16)
    var messageBody = Font.custom("WorkSans-Regular", size: 11)
    var messageCaption =  Font.custom("WorkSans-Regular", size: 10)
}

extension Color {
    static let warning = Color("WarningColor")
    static let success = Color("SuccessColor")
    static let secondary = Color("SecondaryColor")
    static let primary = Color("PrimaryColor")
    static let foreground = Color("ForegroundColor")
    static let background = Color("BackgroundColor")
    static let facebook = Color("FacebookColor")
    static let accent = Color("AccentColor")
    static let lightBackground = Color.gray
    static let field = Color(UIColor.systemGray6)
    static let secondaryBackground = Color("SecondaryBackground")
}

extension CGFloat {
    
    static let xxsm: CGFloat = 5
    static let sm: CGFloat = 10
    static let md: CGFloat = 15
    static let lg: CGFloat = 22
    static let xlg: CGFloat = 34
    static let xxlg: CGFloat = 42
    static let xxxlg: CGFloat = 75
    
    static let cornerXS: CGFloat = 3
    static let cornerS: CGFloat = 10
    static let cornerM: CGFloat = 16
    static let cornerL: CGFloat = 20
    static let cornerXL: CGFloat = 32
    
}
