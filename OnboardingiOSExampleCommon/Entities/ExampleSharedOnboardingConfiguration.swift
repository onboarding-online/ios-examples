//
//  ExampleOnboardingConfiguration.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 22.11.2023.
//

import UIKit

final class ExampleSharedOnboardingConfiguration: ObservableObject {
   
    static var shared = ExampleSharedOnboardingConfiguration()
    private init() { }
    
    @Published var location: OnboardingLocation = .local {
        didSet { UserDefaults.location = location }
    }
    @Published var launchWithAnimation: Bool = UserDefaults.launchWithAnimation {
        didSet { UserDefaults.launchWithAnimation = launchWithAnimation }
    }
    @Published var customFlowEnabled: Bool = UserDefaults.customFlowEnabled{
        didSet { UserDefaults.customFlowEnabled = customFlowEnabled }
    }
    @Published var env: OnboardingEnvironment = UserDefaults.env{
        didSet { UserDefaults.env = env }
    }
    @Published var appearance: OnboardingAppearanceStyle = UserDefaults.appearance{
        didSet { UserDefaults.appearance = appearance }
    }
    @Published var assetsPrefetchMode: OnboardingAssetsPrefetchMode = UserDefaults.assetsPrefetchMode{
        didSet { UserDefaults.assetsPrefetchMode = assetsPrefetchMode }
    }
    @Published var loadingScreenType: OnboardingLoadingScreenType = UserDefaults.loadingScreenType{
        didSet { UserDefaults.loadingScreenType = loadingScreenType }
    }
    
}

/// Where is the source for onboarding .json file
enum OnboardingLocation: String, CaseIterable {
    static let title = "Location"
    
    case remote = "Remote" // SDK will fetch onboarding from the server
    case local = "Local" // SDK will use local file
}

enum OnboardingEnvironment: String, CaseIterable {
    static let title = "Environment"
    
    case qa = "QA"
    case prod = "Production"
}

/// Source Window or ViewController to show onboarding
enum OnboardingAppearanceStyle: String, CaseIterable {
    static let title = "Appearance"
    
    case `default` = "Default" // By default SDK will take key window
    case window = "Window" // Provide custom window to run Onboarding
    case presentIn = "Present" // Onboarding will be presented on top of provided View Controller
}

/// Rules to run onboarding based on assets readiness status. Loading screen will be shown while assets is loading.
enum OnboardingAssetsPrefetchMode: String, CaseIterable {
    static let title = "Prefetch mode"
    
    case waitForAllDone = "All done" // SDK will load all assets before running onboarding.
    case waitForFirstDone = "First done" // SDK will run onboarding after first screen is ready. Rest will keep loading in the background
    case waitForScreenToLoad = "Timeout" // Same as waitForFirstDone but let specify timeout time. Onboard will start if assets couldn't be loaded before timeout. Set to 0 if doesn't want to wait.
}

/// Should use default or custom loading screen that shown while assets is loading
enum OnboardingLoadingScreenType: String, CaseIterable {
    static let title = "Loading screen type"
    
    case `default` = "Default"
    case custom = "Custom"
}
