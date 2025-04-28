//
//  Factory.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//

import UIKit


/// A manager responsible for displaying loading indicators and error messages over a given view.
final class StateFeedbackManager {

    /// The main view where feedback elements (loader, overlay) will be displayed.
    private weak var view: UIView?
    
    /// A blurred background view (currently unused).
    private var blurView: UIVisualEffectView?
    
    /// A semi-transparent overlay view used when showing a loader.
    private var overlayView: UIView?
    
    /// An activity indicator displayed during loading states.
    private var loader: UIActivityIndicatorView?

    /// Initializes the manager with a target view.
    /// - Parameter view: The view to display loading or error feedback on.
    init(view: UIView) {
        self.view = view
    }

    /// Displays a loading indicator over the entire view with a semi-transparent background.
    func showLoader() {
        guard let view = view else { return }
        if overlayView != nil { return }

        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.startAnimating()
        overlay.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
        ])

        self.overlayView = overlay
        self.loader = loader
    }

    /// Hides the loading indicator and removes the overlay view.
    func hideLoader() {
        loader?.stopAnimating()
        overlayView?.removeFromSuperview()
        loader = nil
        overlayView = nil
    }

    /// Displays an error alert with a given message.
    /// - Parameter message: The error message to display. Defaults to a generic error message.
    func showError(message: String = "An unexpected error occurred") {
        guard let viewController = view?.parentViewController else { return }

        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}

private extension UIView {
    /// Finds the parent view controller of the view, if it exists.
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
