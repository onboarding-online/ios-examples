//
//  OnboardingPaywallWrapperView.swift
//  OnboardingiOSExampleAppSwiftUI
//
//  Created by Oleg Kuplin on 30.04.2024.
//

import SwiftUI
import OnboardingiOSSDK

struct OnboardingPaywallWrapperView: View {
    
    @Environment(\.presentationMode) var presentationMode /// Or dismiss starting iOS 15
    @State private var paywallVC: UIViewController?
    
    var body: some View {
        contentView()
            .ignoresSafeArea()
            .onAppear(perform: onAppear)
    }
    
}

// MARK: - Private methods
private extension OnboardingPaywallWrapperView {
    func onAppear() {
        TunedOnboardingRunner.shared.getSoloPaywall(completion: { paywall in
            guard let paywall else {
                dismiss()
                return
            }
            
            paywall.closePaywallHandler = { _ in
                dismiss()
            }
            paywall.purchaseHandler = { _, receipt in
                didPurchaseWith(receipt: receipt)
            }
            self.paywallVC = paywall
        })
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func didPurchaseWith(receipt: OnboardingPaymentReceipt?) {
        dismiss()
    }
}

// MARK: - Private methods
private extension OnboardingPaywallWrapperView {
    @ViewBuilder
    func contentView() -> some View {
        if let paywallVC {
            OnboardingPaywallViewControllerRepresentable(paywallVC: paywallVC)
        } else {
            ProgressView()
        }
    }
}

private struct OnboardingPaywallViewControllerRepresentable: UIViewControllerRepresentable {
    
    let paywallVC: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        paywallVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
