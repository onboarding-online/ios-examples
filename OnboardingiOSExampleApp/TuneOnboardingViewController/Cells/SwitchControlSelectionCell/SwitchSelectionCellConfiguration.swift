//
//  SwitchSelectionCellConfiguration.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 08.12.2023.
//

import Foundation

struct SwitchSelectionCellConfiguration: Hashable {
    
    let title: String
    let isOn: Bool
    var valueChangedCallback: SwitchValueChangedCallback?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(isOn)
    }
    
    static func == (lhs: SwitchSelectionCellConfiguration, rhs: SwitchSelectionCellConfiguration) -> Bool {
        return lhs.title == rhs.title &&
        lhs.isOn == rhs.isOn
    }
}

// MARK: - Open methods
extension SwitchSelectionCellConfiguration {
    static func launchAnimatedConfiguration() -> SwitchSelectionCellConfiguration {
        SwitchSelectionCellConfiguration(title: Strings.launchAnimated,
                                                isOn: ExampleSharedOnboardingConfiguration.shared.launchWithAnimation) { isAnimated in
            ExampleSharedOnboardingConfiguration.shared.launchWithAnimation = isAnimated
        }
    }
    
    static func customFlowEnabledConfiguration() -> SwitchSelectionCellConfiguration {
        SwitchSelectionCellConfiguration(title: Strings.customFlowEnabled,
                                         isOn: ExampleSharedOnboardingConfiguration.shared.customFlowEnabled) { isAnimated in
            ExampleSharedOnboardingConfiguration.shared.customFlowEnabled = isAnimated
        }
    }
}
