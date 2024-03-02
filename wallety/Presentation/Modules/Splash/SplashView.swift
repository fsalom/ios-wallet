//
//  SplashView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 28/12/23.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var VM: SplashViewModel

    var isActive: Bool = true
    var body: some View {
        ZStack {
            switch VM.currentScreen {
            case .onBoarding:
                OnBoardingBuilder().build(with: context.container,
                                          screen: $VM.currentScreen)
            case .app:
                MainTabbedView()
            case .none:
                ZStack {
                    Color.white
                    Image(.logo)
                        .resizable()
                        .frame(width: 350, height: 350)
                        .aspectRatio(contentMode: .fit)

                }.ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    VM.load()
                }
            }
        }
    }
}

#Preview {
    SplashView(VM: SplashViewModel(userUseCases: UserMockUseCases()))
}
