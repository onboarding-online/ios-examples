//
//  TunedOnboardingRunner.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 22.11.2023.
//

import Foundation
import OnboardingiOSSDK
import SwiftUI
import OnboardingPaymentKit


final class TunedOnboardingRunner {
    
    static let shared = TunedOnboardingRunner()
    
    private let projectId = "80520419-00a7-4e0c-a724-8ff97fd028b5"
    private let jsonName = "onboarding-v#1-24"
    private var configuration: ExampleSharedOnboardingConfiguration { ExampleSharedOnboardingConfiguration.shared }
    
    private init() { }
    
}

// MARK: - Open methods
extension TunedOnboardingRunner {
    func startOnboardingWithSelectedSettings(finishedCallback: (()->())? = nil) {
        prepareOnboardingToStartWithSelectedConfiguration()
        switch configuration.location {
        case .local:
            OnboardingService.shared.startOnboardingFrom(localJSONFileName: jsonName,
                                                         launchWithAnimation: configuration.launchWithAnimation) { [weak self] result in
                self?.handleOnboardingResult(result)
                finishedCallback?()
            }
        case .remote:
            OnboardingService.shared.startOnboarding(projectId: projectId,
                                                     localJSONFileName: jsonName,
                                                     env: getOnboardingEnvironment(),
                                                     useLocalJSONAfterTimeout: 2,
                                                     launchWithAnimation: configuration.launchWithAnimation) { [weak self] result in
                self?.handleOnboardingResult(result)
                finishedCallback?()
            }
        }
    }
}

// MARK: - Prepared onboarding
extension TunedOnboardingRunner {
    func prepareOnboarding() {
        OnboardingService.prepareFullOnboardingFor(projectId: projectId,
                                                   localJSONFileName: jsonName,
                                                   env: getOnboardingEnvironment(), 
                                                   prefetchMode: getSelectedPrefetchMode()) { result in
            AppLogger.log("Did prepare onboarding with result \(result)")
        }
    }
    
    func startPreparedOnboarding() {
        prepareOnboardingToStartWithSelectedConfiguration()
        OnboardingService.shared.startPreparedOnboardingWhenReady(projectId: projectId,
                                                                  localJSONFileName: jsonName,
                                                                  env: getOnboardingEnvironment(),
                                                                  useLocalJSONAfterTimeout: 2,
                                                                  launchWithAnimation: configuration.launchWithAnimation) { [weak self] result in
            self?.handleOnboardingResult(result)
        }
    }
    
    func getSoloPaywall(completion: @escaping (PaywallVC?)->()) {
        OnboardingService.shared.paymentService = OnboardingPaymentService(sharedSecret: "your_shared_secret")
        
        OnboardingService.shared.getPaywall(paywallId: "screen4", projectId: projectId, localJSONFileName: jsonName, env: .prod, useLocalJSONAfterTimeOut: 3.0) { result in
            switch result {
            case .success(let paywall):
                completion(paywall)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func showSoloPaywall(navigationController: UINavigationController?) {
        getSoloPaywall { [weak navigationController] paywall in
            guard let paywall else { return }
            
            paywall.closePaywallHandler =  { (controller) in
                navigationController?.popViewController(animated: true)
            }
            
            paywall.purchaseHandler =  { (controller, receipt) in
                navigationController?.popViewController(animated: true)
            }
            
            navigationController?.pushViewController(paywall, animated: true)
        }
    }
    
    func clearCache() {
        OnboardingService.shared.cleanCash()
    }
}

// MARK: - Private methods
private extension TunedOnboardingRunner {
    func prepareOnboardingToStartWithSelectedConfiguration() {
        setupAnalyticEventsListener()
        setupCustomFlowIfNeeded()
        applySelectedOnboardingConfiguration()
    }
    
    func handleOnboardingResult(_ result: GenericResult<OnboardingData>) {
        switch result {
        case .success(let onboardingData):
            AppLogger.log("Did finish onboarding with data: \(onboardingData)")
        case .failure(let error):
            AppLogger.log("Failed to start onboarding with error: \(error)")
        }
    }
}

// MARK: - Apply configuration properties
private extension TunedOnboardingRunner {
    func applySelectedOnboardingConfiguration() {
        applySelectedLoadingScreenType()
        applySelectedAppearanceStyle()
        applyPrefetchMode()
    }
    
    func getOnboardingEnvironment() -> OnboardingiOSSDK.OnboardingEnvironment {
        switch configuration.env {
        case .qa:
            return .qa
        case .prod:
            return .prod
        }
    }
    
    func applySelectedLoadingScreenType() {
        let customLoadingViewController: UIViewController?
        switch configuration.loadingScreenType {
        case .default:
            customLoadingViewController = nil
        case .custom:
            customLoadingViewController = UIHostingController(rootView: CustomLoadingView())
        }
        OnboardingService.shared.customLoadingViewController = customLoadingViewController
    }
    
    func applySelectedAppearanceStyle() {
        switch configuration.appearance {
        case .default:
            OnboardingService.shared.appearance = .default
        case .window:
            let window = getMyWindow()
            OnboardingService.shared.appearance = .window(window)
        case .presentIn:
            guard let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: \.isKeyWindow),
                  let rootVC = keyWindow.rootViewController else {
                AppLogger.log("Failed to get root view controller", logType: .error)
                return
            }
            OnboardingService.shared.appearance = .presentIn(rootVC)
        }
    }
    
    func getMyWindow() -> UIWindow {
        /// In case you want to run onboarding on specific window
        let window = UIWindow()
        return window
    }
    
    func getSelectedPrefetchMode() -> OnboardingService.AssetsPrefetchMode {
        switch configuration.assetsPrefetchMode {
        case .waitForAllDone:
            return .waitForAllDone
        case .waitForFirstDone:
            return .waitForFirstDone
        case .waitForScreenToLoad:
            return .waitForScreenToLoad(timeout: 0.5) // Set to 0 if don't want to wait at all
        }
    }
    
    func applyPrefetchMode() {
        OnboardingService.shared.assetsPrefetchMode = getSelectedPrefetchMode()
    }
}

// MARK: - Setup analytics
private extension TunedOnboardingRunner {
    func setupAnalyticEventsListener() {
        OnboardingService.shared.userEventListener = { [weak self] (event, params) in
            guard let self else { return }
            
            switch event {
            case .screenDisappeared:
                return
            case .userUpdatedValue:
                self.checkForSelectedValue(event: event, params: params)
            default:
                Void()
            }
            AnalyticsService.shared.log(event: event,
                                        withCustomParameters: self.convertOnboardingParamsToAnalyticParams(params))
        }
        
        OnboardingService.shared.systemEventListener = { [weak self] (data, params) in
            guard let self else { return }
            AnalyticsService.shared.log(event: data,
                                        withCustomParameters: self.convertOnboardingParamsToAnalyticParams(params))
        }
    }
    
    func checkForSelectedValue(event: AnalyticsEvent, params: [String: Any]?) {
        guard let screenId = params?["screenID"] as? String else { return }
        // TODO: - Show how to get input value
        switch screenId {
        case "screen7":
            guard let selectedValue = params?[AnalyticsEventParams.userInputValue.rawValue] as? Int else { return }
            //            if let formatStr = params?["buttonTitle"] as? String {
            //                AnalyticsService.shared.set(userProperties: [.onboardingExportFormat: formatStr])
            //            }
            
            return
        default:
            return
        }
    }
    
    func convertOnboardingParamsToAnalyticParams(_ onboardingParams: [String : Any]?) -> [String : String] {
        var aParams = [String : String]()
        for (key, value) in onboardingParams ?? [:] {
            aParams[key] = String(describing: value)
        }
        return aParams
    }
}

// MARK: - Setup custom flow
private extension TunedOnboardingRunner {
    func setupCustomFlowIfNeeded() {
        OnboardingService.shared.customFlow = { screen, navigation in
            //            let productIdsString = screen.customScreenValue()?.labels["product_ids"]?.value.l10n.first?.value ?? ""
            //            let productIds = productIdsString.components(separatedBy: ",")
            //            PurchasesService.productIds = Set(productIds)
            // TODO: - Show how to pass input value from custom flow
            switch screen.name {
            case "custom":
                let view = CustomFlowView(finishedCallback: {
                    OnboardingService.shared.customFlowFinished(customScreen: screen, userInputValue: nil)
                })
                let vc = UIHostingController(rootView: view)
                navigation?.viewControllers = [vc]
            default:
                OnboardingService.shared.customFlowFinished(customScreen: screen, userInputValue: nil)
            }
        }
    }
}
