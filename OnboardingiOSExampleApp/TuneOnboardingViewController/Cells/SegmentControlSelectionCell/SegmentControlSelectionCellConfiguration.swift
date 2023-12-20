//
//  SegmentControlSelectionCellConfiguration.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 08.12.2023.
//

import Foundation

struct SegmentControlSelectionCellConfiguration: Hashable {
    
    let title: String
    let segments: [String]
    let selectedIndex: Int
    var valueChangedCallback: SegmentValueChangedCallback?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(segments)
        hasher.combine(selectedIndex)
    }
    
    static func == (lhs: SegmentControlSelectionCellConfiguration, rhs: SegmentControlSelectionCellConfiguration) -> Bool {
        return lhs.title == rhs.title &&
        lhs.segments == rhs.segments &&
        lhs.selectedIndex == rhs.selectedIndex
    }
}

extension SegmentControlSelectionCellConfiguration {
    static func selectAppearanceModeConfiguration() -> SegmentControlSelectionCellConfiguration {
        let environments = OnboardingEnvironment.allCases
        let selectedIndex = OnboardingEnvironment.allCases.firstIndex(of: ExampleSharedOnboardingConfiguration.shared.env) ?? 0
        
        return .init(title: OnboardingEnvironment.title,
                     segments: environments.map { $0.rawValue },
                     selectedIndex: selectedIndex,
                     valueChangedCallback: { index in
            let selectedItem = environments[index]
            ExampleSharedOnboardingConfiguration.shared.env = selectedItem
        })
    }
    
    static func selectOnboardingLocationConfiguration() -> SegmentControlSelectionCellConfiguration {
        let locations = OnboardingLocation.allCases
        let selectedIndex = OnboardingLocation.allCases.firstIndex(of: ExampleSharedOnboardingConfiguration.shared.location) ?? 0
        
        return .init(title: OnboardingLocation.title,
                     segments: locations.map { $0.rawValue },
                     selectedIndex: selectedIndex,
                     valueChangedCallback: { index in
            let selectedItem = locations[index]
            ExampleSharedOnboardingConfiguration.shared.location = selectedItem
        })
    }
    
    static func selectAppearanceConfiguration() -> SegmentControlSelectionCellConfiguration {
        let appearances = OnboardingAppearanceStyle.allCases
        let selectedIndex = OnboardingAppearanceStyle.allCases.firstIndex(of: ExampleSharedOnboardingConfiguration.shared.appearance) ?? 0
        
        return .init(title: OnboardingAppearanceStyle.title,
                     segments: appearances.map { $0.rawValue },
                     selectedIndex: selectedIndex,
                     valueChangedCallback: { index in
            let selectedItem = appearances[index]
            ExampleSharedOnboardingConfiguration.shared.appearance = selectedItem
        })
    }
    
    static func selectAssetsPrefetchModeConfiguration() -> SegmentControlSelectionCellConfiguration {
        let appearances = OnboardingAssetsPrefetchMode.allCases
        let selectedIndex = OnboardingAssetsPrefetchMode.allCases.firstIndex(of: ExampleSharedOnboardingConfiguration.shared.assetsPrefetchMode) ?? 0
        
        return .init(title: OnboardingAssetsPrefetchMode.title,
                     segments: appearances.map { $0.rawValue },
                     selectedIndex: selectedIndex,
                     valueChangedCallback: { index in
            let selectedItem = appearances[index]
            ExampleSharedOnboardingConfiguration.shared.assetsPrefetchMode = selectedItem
        })
    }
    
    static func selectLoadingScreenTypeConfiguration() -> SegmentControlSelectionCellConfiguration {
        let appearances = OnboardingLoadingScreenType.allCases
        let selectedIndex = OnboardingLoadingScreenType.allCases.firstIndex(of: ExampleSharedOnboardingConfiguration.shared.loadingScreenType) ?? 0
        
        return .init(title: OnboardingLoadingScreenType.title,
                     segments: appearances.map { $0.rawValue },
                     selectedIndex: selectedIndex,
                     valueChangedCallback: { index in
            let selectedItem = appearances[index]
            ExampleSharedOnboardingConfiguration.shared.loadingScreenType = selectedItem
        })
    }
}



