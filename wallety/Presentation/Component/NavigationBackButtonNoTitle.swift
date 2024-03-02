//
//  NavigationBackButtonNoTitle.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 28/1/24.
//

import Foundation
import SwiftUI

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
