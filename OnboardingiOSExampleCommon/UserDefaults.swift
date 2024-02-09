//
//  UserDefaults.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 20.12.2023.
//

import Foundation

public enum UserDefaultsKey: String {
    case didFinishOnboarding
    case location
    case launchWithAnimation
    case customFlowEnabled
    case env
    case appearance
    case assetsPrefetchMode
    case loadingScreenType
}


extension UserDefaults {
    @UserDefaultsValue(key: UserDefaultsKey.didFinishOnboarding, defaultValue: false) static var didFinishOnboarding: Bool
    @UserDefaultsValue(key: UserDefaultsKey.launchWithAnimation, defaultValue: false) static var launchWithAnimation: Bool
    @UserDefaultsValue(key: UserDefaultsKey.customFlowEnabled, defaultValue: false) static var customFlowEnabled: Bool
    @UserDefaultsRawRepresentableValue(key: UserDefaultsKey.location, defaultValue: .local) static var location: OnboardingLocation
    @UserDefaultsRawRepresentableValue(key: UserDefaultsKey.env, defaultValue: .qa) static var env: OnboardingEnvironment
    @UserDefaultsRawRepresentableValue(key: UserDefaultsKey.appearance, defaultValue: .default) static var appearance: OnboardingAppearanceStyle
    @UserDefaultsRawRepresentableValue(key: UserDefaultsKey.loadingScreenType, defaultValue: .default) static var loadingScreenType: OnboardingLoadingScreenType
    @UserDefaultsRawRepresentableValue(key: UserDefaultsKey.assetsPrefetchMode, defaultValue: .waitForFirstDone) static var assetsPrefetchMode: OnboardingAssetsPrefetchMode
}

@propertyWrapper
struct UserDefaultsValue<Key: RawRepresentable, Value> where Key.RawValue == String {
    
    let key: Key
    let defaultValue: Value
    
    var wrappedValue: Value {
        get {
            return UserDefaults.standard.value(forKey: key.rawValue) as? Value ?? defaultValue
        }
        set { UserDefaults.standard.setValue(newValue, forKey: key.rawValue) }
    }
    
}

@propertyWrapper
struct UserDefaultsRawRepresentableValue<Value: RawRepresentable> {
    
    let key: UserDefaultsKey
    let defaultValue: Value
    
    var wrappedValue: Value {
        get {
            if let rawValue = UserDefaults.standard.value(forKey: key.rawValue) as? Value.RawValue,
               let value = Value(rawValue: rawValue) {
                return value
            }
            return defaultValue
        }
        set { UserDefaults.standard.setValue(newValue.rawValue, forKey: key.rawValue) }
    }
    
}
