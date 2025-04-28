//
//  ProductGridCell.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 27/04/25.
//

import UIKit
import Kingfisher

// MARK: - ProductGridCell

final class ProductGridCell: UICollectionViewCell {

    private let containerView = UIView()
    private let badgesFlow = BadgesFlowView()
    private let productImageView = UIImageView()
    private let nameLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    var onFavoriteTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.translatesAutoresizingMaskIntoConstraints = false

        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .systemFont(ofSize: 13, weight: .medium)
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemGray
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        badgesFlow.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)
        containerView.addSubview(favoriteButton)
        containerView.addSubview(productImageView)
        containerView.addSubview(badgesFlow)
        containerView.addSubview(nameLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            favoriteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),

            productImageView.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalToConstant: 80),

            badgesFlow.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            badgesFlow.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            badgesFlow.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            nameLabel.topAnchor.constraint(equalTo: badgesFlow.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }


    func configure(with model: ProductListItemViewModel) {
        nameLabel.text = model.name

        if let url = model.imageUrl {
            productImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }

        let heartImage = model.isFavorite ? "heart.fill" : "heart"
        let heartColor: UIColor = model.isFavorite ? UIColor.systemBlue : UIColor.systemGray
        favoriteButton.setImage(UIImage(systemName: heartImage), for: .normal)
        favoriteButton.tintColor = heartColor

        badgesFlow.setBadges(model.badges)
    }

    @objc private func favoriteTapped() {
        onFavoriteTapped?()
    }
}
