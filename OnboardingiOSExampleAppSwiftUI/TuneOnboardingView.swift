//
//  ContentView.swift
//  OnboardingiOSExampleAppSwiftUI
//
//  Created by Oleg Kuplin on 08.12.2023.
//

import SwiftUI

struct TuneOnboardingView: View {
    
    @StateObject private var configuration: ExampleSharedOnboardingConfiguration = .shared
    @State private var didClearCache = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    configurationsListView()
                }
                actionButtonsView()
            }
            .alert(isPresented: $didClearCache, content: cacheClearedAlert)
            .navigationTitle(Strings.tuneScreenTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        TunedOnboardingRunner.shared.clearCache()
                        didClearCache = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}

// MARK: - Configurations list
private extension TuneOnboardingView {
    @ViewBuilder
    func configurationsListView() -> some View {
        VStack(spacing: 16) {
            environmentConfigurationView()
            locationConfigurationView()
            appearanceModeConfigurationView()
            prefetchModeConfigurationView()
            loadingScreenTypeConfigurationView()
            launchWithAnimationConfigurationView()
//            customFlowEnabledConfigurationView()
        }
        .padding()
    }

    @ViewBuilder
    func launchWithAnimationConfigurationView() -> some View {
        Toggle(Strings.launchAnimated, isOn: $configuration.launchWithAnimation)
    }
    
    @ViewBuilder
    func customFlowEnabledConfigurationView() -> some View {
        Toggle(Strings.customFlowEnabled, isOn: $configuration.customFlowEnabled)
    }
}

// MARK: - Segmented views
private extension TuneOnboardingView {
    @ViewBuilder
    func environmentConfigurationView() -> some View {
        segmentedCaseIterableViewWithTitle(OnboardingEnvironment.title,
                                           selection: $configuration.env)
    }
    
    @ViewBuilder
    func appearanceModeConfigurationView() -> some View {
        segmentedCaseIterableViewWithTitle(OnboardingAppearanceStyle.title,
                                           selection: $configuration.appearance)
    }
    
    @ViewBuilder
    func locationConfigurationView() -> some View {
        segmentedCaseIterableViewWithTitle(OnboardingLocation.title,
                                           selection: $configuration.location)
    }
    
    @ViewBuilder
    func prefetchModeConfigurationView() -> some View {
        segmentedCaseIterableViewWithTitle(OnboardingAssetsPrefetchMode.title,
                                           selection: $configuration.assetsPrefetchMode)
    }
    
    @ViewBuilder
    func loadingScreenTypeConfigurationView() -> some View {
        segmentedCaseIterableViewWithTitle(OnboardingLoadingScreenType.title,
                                           selection: $configuration.loadingScreenType)
    }
    
    @ViewBuilder
    func segmentedCaseIterableViewWithTitle<T: Hashable & RawRepresentable & CaseIterable>(_ title: String,
                                                                                           selection: Binding<T>) -> some View where T.RawValue == String {
        segmentedViewWithTitle(title,
                               items: Array(T.allCases),
                               selection: selection)
    }
    
    @ViewBuilder
    func segmentedViewWithTitle<T: Hashable & RawRepresentable>(_ title: String,
                                                                items: [T],
                                                                selection: Binding<T>) -> some View where T.RawValue == String {
        verticalViewWithTitle(title) {
            Picker("", selection: selection) {
                ForEach(items, id: \.self) { appearance in
                    Text(appearance.rawValue)
                }
            }.pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder
    func verticalViewWithTitle(_ title: String,
                               @ViewBuilder _ builder:  ()->(some View)) -> some View {
        VStack {
            Text(title)
                .font(.title3)
            builder()
        }
    }
}

// MARK: - Action buttons
private extension TuneOnboardingView {
    @ViewBuilder
    func actionButtonsView() -> some View {
        VStack {
            actionButtonViewWith(title: Strings.startOnboarding) {
                TunedOnboardingRunner.shared.startOnboardingWithSelectedSettings()
            }
            HStack {
                actionButtonViewWith(title: Strings.prepareOnboarding) {
                    TunedOnboardingRunner.shared.prepareOnboarding()
                }
                actionButtonViewWith(title: Strings.runPreparedOnboarding) {
                    TunedOnboardingRunner.shared.startPreparedOnboarding()
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func actionButtonViewWith(title: String,
                              action: @escaping ()->()) -> some View {
        Button(title) {
            action()
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(Color.white)
        .cornerRadius(8)
    }
}

// MARK: - Alerts
private extension TuneOnboardingView {
    func cacheClearedAlert() -> Alert {
        Alert(title: Text(Strings.cacheClearedAlertTitle),
              message: Text(Strings.cacheClearedAlertMessage))
    }
}

//#Preview {
//    TuneOnboardingView()
//}
