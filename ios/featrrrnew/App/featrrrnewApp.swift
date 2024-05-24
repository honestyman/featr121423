//
//  featrrrnewApp.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/27/23.
//

import SwiftUI

import FirebaseCore
import Stripe
import StripePaymentsUI


//@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
      //Configure firebase
      FirebaseApp.configure()

      //Configure Stripe
      StripeAPI.defaultPublishableKey="sk_test_51NV3D4HPhoixtOLjK1Qij1OP4CXHVfSfOzVI1sg0690oEWt6prVeM68ZNpbU0l7MgGfKAOvhKYvTSW2wk3hEwgOF00zGx31mFr"
      
      return true
  }
}

@main
struct featrrrnewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
                RootView()
        }
    }
}
