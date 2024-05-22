//
//  AdaptyPaymentAdapter.swift
//  OnboardingiOSExampleApp
//
//  Created by Oleg Kuplin on 22.05.2024.
//

import Foundation
import Adapty
import OnboardingiOSSDK
import OnboardingPaymentKit

func setupAdaptyPaymentProvider() {
    OnboardingService.shared.paymentService = AdaptyPaymentAdapter(adaptyPlacementId: "YOUR_ADAPTY_PLACEMENT_ID")
}


import StoreKit

/// In this example there's paywall fetcher ready to use.
/// If you already have the paywall entity you might want to pass it directly into this class.
final class AdaptyPaymentAdapter: OnboardingPaymentServiceProtocol {
    
    private let paywallFetcher: AdaptyPaymentPaywallFetcher
    
    init(adaptyPlacementId: String) {
        self.paywallFetcher = AdaptyPaymentPaywallFetcher(adaptyPlacementId: adaptyPlacementId)
    }
    
    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }
    
    /// Since Adapty rely on internal structure to fetch products list, it is developer's responsibility to ensure
    /// That the list of products in Onboarding and Adapty match
    func fetchProductsWith(ids: Set<String>) async throws -> [SKProduct] {
        let paywall = try await paywallFetcher.getPaywall()
        let products = try await Adapty.getPaywallProducts(paywall: paywall)
        return products.map { $0.skProduct }.filter({ ids.contains($0.productIdentifier) })
    }
    
    func cashedProductsWith(ids: Set<String>) -> [SKProduct]? {
        nil
    }
    
    func restorePurchases() async throws {
        _ = try await Adapty.restorePurchases()
    }
    
    func purchaseProduct(_ product: SKProduct) async throws {
        let paywall = try await paywallFetcher.getPaywall()
        let products = try await Adapty.getPaywallProducts(paywall: paywall)
        guard let product = products.first(where: { $0.skProduct.productIdentifier == product.productIdentifier }) else {
            throw AdaptyPaymentAdapterError.productNotFound
        }
        _ = try await Adapty.makePurchase(product: product)
    }
    
    func activeSubscriptionReceipt() async throws -> OnboardingPaymentReceipt? {
        let profile = try await Adapty.getProfile()
        if let activeSubscription = profile.subscriptions.values.first(where: { $0.isActive }) {
            return transformAdaptySubscriptionToOnboardingPaymentReceipt(activeSubscription)
        }
        return nil
    }
    
    func lastPurchaseReceipts() async throws -> OnboardingPaymentReceipt? {
        let profile = try await Adapty.getProfile()
        let nonSubscriptions = profile.nonSubscriptions.values.flatMap { $0 }
        if let purchase = nonSubscriptions.sorted(by: { $0.purchasedAt > $1.purchasedAt }).first {
            return transformAdaptyNonSubscriptionToOnboardingPaymentReceipt(purchase)
        }
        return nil
    }
    
    func hasActiveSubscription() async throws -> Bool {
        let profile = try await Adapty.getProfile()
        return profile.subscriptions.values.first(where: { $0.isActive }) != nil
    }
    
    private func transformAdaptySubscriptionToOnboardingPaymentReceipt(_ subscription: AdaptyProfile.Subscription) -> OnboardingPaymentReceipt {
        OnboardingPaymentReceipt(productId: subscription.vendorProductId,
                                 quantity: "1",
                                 transactionId: subscription.vendorTransactionId,
                                 originalTransactionId: subscription.vendorOriginalTransactionId,
                                 purchaseDate: subscription.renewedAt ?? subscription.activatedAt,
                                 originalPurchaseDate: subscription.activatedAt,
                                 isTrialPeriod: subscription.activeIntroductoryOfferType == "free_trial" ? "1" : "0",
                                 expiresDate: subscription.expiresAt,
                                 cancellationDate: subscription.unsubscribedAt)
    }
    
    private func transformAdaptyNonSubscriptionToOnboardingPaymentReceipt(_ purchase: AdaptyProfile.NonSubscription) -> OnboardingPaymentReceipt {
        OnboardingPaymentReceipt(productId: purchase.vendorProductId,
                                 quantity: "1",
                                 transactionId: purchase.vendorTransactionId ?? "",
                                 originalTransactionId: purchase.vendorTransactionId ?? "",
                                 purchaseDate: purchase.purchasedAt,
                                 originalPurchaseDate: purchase.purchasedAt,
                                 isTrialPeriod: "0")
    }
    
    enum AdaptyPaymentAdapterError: String, LocalizedError {
        case productNotFound
        
        public var errorDescription: String? {
            return rawValue
        }
    }
}

private actor AdaptyPaymentPaywallFetcher {
    
    let adaptyPlacementId: String
    private var paywall: AdaptyPaywall?
    private var fetchTask: Task<AdaptyPaywall, Error>?
    
    init(adaptyPlacementId: String) {
        self.adaptyPlacementId = adaptyPlacementId
    }
    
    func getPaywall() async throws -> AdaptyPaywall {
        if let paywall {
            return paywall
        }
        
        if let fetchTask {
            return try await fetchTask.value
        }
        
        let adaptyPlacementId = self.adaptyPlacementId
        let task = Task {
            try await Adapty.getPaywall(placementId: adaptyPlacementId)
        }
        
        fetchTask = task
        do {
            let paywall = try await task.value
            self.paywall = paywall
            fetchTask = nil
            return paywall
        } catch {
            fetchTask = nil
            throw error
        }
    }
}
