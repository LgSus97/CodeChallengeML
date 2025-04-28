//
//  FavoriteProductCell.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 27/04/25.
//

import UIKit

/// A custom UICollectionViewCell used to display a favorite product.
final class FavoriteProductCell: UICollectionViewCell {

    // MARK: - UI Components

    private let containerView = UIView()
    private let productImageView = UIImageView()
    private let nameLabel = UILabel()
    private let brandLabel = UILabel()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    /// Configures the visual appearance and layout of the cell.
    private func setupCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Card Style
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false

        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
        productImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        brandLabel.font = .systemFont(ofSize: 14)
        brandLabel.textColor = .secondaryLabel
        brandLabel.numberOfLines = 1
        brandLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)
        [productImageView, nameLabel, brandLabel].forEach {
            containerView.addSubview($0)
        }

        setupConstraints()
    }

    /// Sets up Auto Layout constraints for the cell's subviews.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            productImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 64),
            productImageView.heightAnchor.constraint(equalToConstant: 64),

            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),

            brandLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            brandLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            brandLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
    }

    // MARK: - Public Methods

    /// Configures the cell with product data.
    /// - Parameter model: The view model containing product information.
    func configure(with model: ProductListItemViewModel) {
        nameLabel.text = model.name
        brandLabel.text = model.brand ?? ""

        if let url = model.imageUrl {
            productImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }
    }
}

