//
//  Logger.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 08.12.2023.
//

import Foundation
import os.log

final class AppLogger {
    
    static func log(_ message: String,
                    logType: OSLogType = .default) {
        let log = OSLog(subsystem: "com.example.onboarding", category: "debug")
        os_log(logType, log: log, "%{public}s", message)
    }
    
}
