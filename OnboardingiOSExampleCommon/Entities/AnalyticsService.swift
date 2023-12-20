//
//  AnalyticsService.swift
//  OnboardingiOSExampleAppSwiftUI
//
//  Created by Oleg Kuplin on 08.12.2023.
//

import Foundation

final class AnalyticsService {
    
    static let shared = AnalyticsService()
    private init() { }
    
    func log<T: RawRepresentable>(event: T,
                                  withCustomParameters eventParameters: [String : String]) {
        AppLogger.log("Will log analytic event: \(event.rawValue) with parameters: \(eventParameters)")
    }
}
