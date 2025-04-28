//
//  ProductDetailView.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//

import UIKit

/// A custom view that displays product details including image, name, price, and stock status.
final class ProductDetailView: UIView {
    
    // MARK: - UI Components

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let stockLabel = UILabel()

    // MARK: - Initializers

    init(product: ProductListItemViewModel) {
        super.init(frame: .zero)
        setupView()
        configure(with: product)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    /// Configures the view hierarchy and layout.
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center

        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.textColor = .systemGreen
        priceLabel.textAlignment = .center

        stockLabel.font = .systemFont(ofSize: 13)
        stockLabel.textColor = .secondaryLabel
        stockLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, priceLabel, stockLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    // MARK: - Public Methods

    /// Configures the view with a product's information.
    /// - Parameter product: The product to display.
    func configure(with product: ProductListItemViewModel) {
        if let url = product.imageUrl {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        nameLabel.text = product.name
        priceLabel.text = "$\(Int.random(in: 300...999)) MXN"
        stockLabel.text = Bool.random() ? "Available for immediate shipping" : "Limited stock"
    }
}
