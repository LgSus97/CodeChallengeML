//
//  UIView+AnimationsFactory.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import UIKit

extension UIView {

    /// Animates the view's appearance with a subtle spring (bloom/rebound) effect.
    func animateAppearWithSpring() {
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        self.isHidden = false

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut],
            animations: {
                self.alpha = 1
                self.transform = .identity
            }
        )
    }
    
    /// Animates the view's disappearance with a smooth fade-out effect.
    func animateDisappear(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.alpha = 0
            },
            completion: { _ in
                self.isHidden = true
                completion?()
            }
        )
    }
    
    /// Performs a cross-dissolve transition between two views inside a container.
    static func transition(from oldView: UIView, to newView: UIView, in containerView: UIView, duration: TimeInterval = 0.4) {
        UIView.transition(
            from: oldView,
            to: newView,
            duration: duration,
            options: [.transitionCrossDissolve, .showHideTransitionViews],
            completion: nil
        )
    }
    
    /// Animates the view falling in from the top with a bounce effect.
    func animateFallIn(from offsetY: CGFloat = -200) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: offsetY)
        self.isHidden = false

        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut],
            animations: {
                self.alpha = 1
                self.transform = .identity
            }
        )
    }
}

private extension UIView {

    /// Animates an array of views to appear sequentially with a cascading spring effect.
    static func animateCascade(
        views: [UIView],
        duration: TimeInterval,
        delay: TimeInterval,
        damping: CGFloat,
        initialVelocity: CGFloat
    ) {
        for (index, view) in views.enumerated() {
            view.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            view.alpha = 0
            
            UIView.animate(
                withDuration: duration,
                delay: delay * Double(index),
                usingSpringWithDamping: damping,
                initialSpringVelocity: initialVelocity,
                options: [.curveEaseOut],
                animations: {
                    view.transform = .identity
                    view.alpha = 1
                }
            )
        }
    }
}

extension UITableView {

    /// Animates all currently visible cells with a cascading spring effect.
    func animateVisibleCells(
        duration: TimeInterval = 0.6,
        delay: TimeInterval = 0.05,
        damping: CGFloat = 0.7,
        initialVelocity: CGFloat = 0.7
    ) {
        UIView.animateCascade(
            views: visibleCells,
            duration: duration,
            delay: delay,
            damping: damping,
            initialVelocity: initialVelocity
        )
    }
}

extension UICollectionView {

    /// Animates all currently visible cells with a cascading spring effect.
    func animateVisibleCells(
        duration: TimeInterval = 0.6,
        delay: TimeInterval = 0.05,
        damping: CGFloat = 0.7,
        initialVelocity: CGFloat = 0.7
    ) {
        UIView.animateCascade(
            views: visibleCells,
            duration: duration,
            delay: delay,
            damping: damping,
            initialVelocity: initialVelocity
        )
    }
}
