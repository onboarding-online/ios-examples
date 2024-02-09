//
//  ContentView.swift
//  OnboardingiOSExampleAppSwiftUI
//
//  Created by Oleg Kuplin on 08.12.2023.
//

import SwiftUI
import OnboardingiOSSDK

struct ContentView: View {
    
    let shouldRunOnboardingOnLaunch = true
    /// Use UserDefaults or any other flag to storage to track if onboarding passed. Example:
    /// @State private var didFinishOnboarding = UserDefaults.didFinishOnboarding
    @State private var didFinishOnboarding = false
    
    var body: some View {
        if shouldRunOnboardingOnLaunch,
           didFinishOnboarding {
            TuneOnboardingView()
        } else {
            CustomLoadingView() /// Show loading screen while onboarding is loading from remote source if needed. 
                .onAppear(perform: runOnboarding)
        }
    }
    
}

// MARK: - Private methods
private extension ContentView {
    func runOnboarding() {
        /// onAppear function might get called again after onboarding finished. It is important to double check it before starting.
        guard !didFinishOnboarding else { return }
        
        /// Run onboarding with default settings from local JSON.
        /// See TunedOnboardingRunner for more tuning details.
        OnboardingService.shared.startOnboardingFrom(localJSONFileName: "onboarding-v#1") { _ in
            didFinishOnboarding = true
        }
    }
}

//#Preview {
//    ContentView()
//}
