//
//  NSNotification.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/12/24.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI

extension NSNotification {
    static let AudioPermissions = NSNotification.Name.init("AudioPermission")
    static let PhotoTap = NSNotification.Name.init("PhotoTap")
    static let ProfilePhotoTap = NSNotification.Name.init("ProfilePhotoTap")
}

