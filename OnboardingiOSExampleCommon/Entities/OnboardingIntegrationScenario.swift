//
//  OnboardingIntegrationScenario.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 22.11.2023.
//

import Foundation

enum OnboardingLaunchScenario {
    case autoRunWithDefaultWindowSettings // Onboarding will start on app launch (in SceneDelegate) using default app window
    case autoRunWithCustomWindowSettings // Onboarding will start on app launch (in SceneDelegate) once key window is set manually
    case manualRun // Onboarding will start later on demand
}
