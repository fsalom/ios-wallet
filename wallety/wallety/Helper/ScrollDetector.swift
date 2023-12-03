//
//  ScrollDetector.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/12/23.
//

import SwiftUI

struct ScrollDetector: UIViewRepresentable {
    var onScroll: (CGFloat) -> ()
    var onDraggingEnd: (CGFloat, CGFloat) -> ()

    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            var scrollView: UIScrollView? = nil
            var superview = uiView.superview
            while superview != nil || scrollView != nil {
                if let scrollViewFound = superview as? UIScrollView,
                   !context.coordinator.isDelegatedAdded{
                    scrollView = scrollViewFound
                    scrollViewFound.delegate = context.coordinator
                    context.coordinator.isDelegatedAdded = true
                    print(scrollViewFound)
                }
                superview = superview?.superview
            }
        }
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollDetector

        init(parent: ScrollDetector) {
            self.parent = parent
        }

        var isDelegatedAdded: Bool = false

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentOffset.y)
        }

        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            parent.onDraggingEnd(targetContentOffset.pointee.y, velocity.y)
        }
    }
}
