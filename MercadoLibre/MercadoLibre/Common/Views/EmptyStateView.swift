//
//  EmptyStateView.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import UIKit

/// A reusable view that displays an empty state with a message and optional action button.
final class EmptyStateView: UIView {
    
    // MARK: - UI Components

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No results found."
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear filters", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Hidden by default
        return button
    }()

    // MARK: - Public Properties

    /// Closure executed when the action button is tapped.
    var onButtonTap: (() -> Void)?

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        setupView()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupView() {
        addSubview(imageView)
        addSubview(messageLabel)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func setupActions() {
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func buttonTapped() {
        onButtonTap?()
    }

    // MARK: - Public Methods

    /// Configures the empty state view to show or hide the action button.
    /// - Parameter showButton: Boolean value to determine if the button should be visible.
    func configure(showButton: Bool) {
        actionButton.isHidden = !showButton
    }
}

