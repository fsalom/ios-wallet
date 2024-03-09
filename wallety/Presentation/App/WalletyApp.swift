//
//  walletyApp.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 30/11/23.
//

import SwiftUI
import SwiftData

@main
struct WalletyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var container: ModelContainer! = {
        do {
            let container = try ModelContainer(for: CryptoDBO.self,
                                               CryptoPortfolioDBO.self,
                                               RateDBO.self,
                                               FavoriteCryptoDBO.self)
            if let url = container.configurations.first?.url.path(percentEncoded: false) {
                print("🗄️ sqlite3 \"\(url)\"")
            } else {
                print("🗄️ No SQLite database found.")
            }
            return container
        } catch {
            fatalError("ERROR")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SplashBuilder().build()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
        .modelContainer(container)
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = UIApplication.keyWindow else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }

    static var keyWindow: UIWindow? {
      let allScenes = UIApplication.shared.connectedScenes
      for scene in allScenes {
        guard let windowScene = scene as? UIWindowScene else { continue }
        for window in windowScene.windows where window.isKeyWindow {
           return window
         }
       }
        return nil
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}

