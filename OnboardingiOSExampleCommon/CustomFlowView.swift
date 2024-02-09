//
//  CustomFlowView.swift
//  OnboardingiOSExampleAppSwiftUI
//
//  Created by Oleg Kuplin on 08.12.2023.
//

import SwiftUI

struct CustomFlowView: View {
    
    var finishedCallback: (()->())
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Run custom block of the code within onboarding.")
            Text("Notify OnboardingService when custom flow is finished")
                .bold()
            Button {
                finishedCallback()
            } label: {
                Text("Finish custom flow")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(8)
            }
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

//#Preview {
//    CustomFlowView(finishedCallback: { })
//}
