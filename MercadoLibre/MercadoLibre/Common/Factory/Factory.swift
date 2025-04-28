//
//  Factory.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//

import UIKit


final class StateFeedbackManager {

    private weak var view: UIView?
    private var blurView: UIVisualEffectView?
    private var overlayView: UIView?
    private var loader: UIActivityIndicatorView?

    init(view: UIView) {
        self.view = view
    }

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

    func hideLoader() {
        loader?.stopAnimating()
        overlayView?.removeFromSuperview()
        loader = nil
        overlayView = nil
    }


    func showError(message: String = "Ocurrió un error inesperado") {
        guard let viewController = view?.parentViewController else { return }

        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        viewController.present(alert, animated: true)
    }
    
}

private extension UIView {
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
