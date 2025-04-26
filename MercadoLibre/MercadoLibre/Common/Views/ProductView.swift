//
//  ProductView.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 25/04/25.
//


import UIKit
import Kingfisher

///// A reusable view that displays product information such as image, name, and brand.
//public final class ProductView: UIView {
//    
//    // MARK: - UI Components
//    
//    private var productImageView = UIImageView()
//    
//    private lazy var nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 14, weight: .semibold)
//        label.textColor = .label
//        label.numberOfLines = 2
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private lazy var brandLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 12)
//        label.textColor = .secondaryLabel
//        label.numberOfLines = 1
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    // MARK: - Initializer
//    
//    public convenience init(
//        produtModel: ProductListItemViewModel
//    ) {
//        let data = ProductListItemViewModel(
//            id: produtModel.id,
//            name: produtModel.name,
//            imageUrl: produtModel.imageUrl,
//            brand: produtModel.brand,
//            model: produtModel.model,
//            color: produtModel.color
//        )
//        self.init(data: data)
//    }
//    
//    public init(data: ProductListItemViewModel) {
//        super.init(frame: .zero)
//        configure(with: data)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Setup View
//    
//    private func setupView() {
//        backgroundColor = .white
//        
//        productImageView.contentMode = .scaleAspectFit
//        productImageView.clipsToBounds = true
//        productImageView.layer.cornerRadius = 8
//        productImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        nameLabel.font = .boldSystemFont(ofSize: 16)
//        nameLabel.numberOfLines = 2
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        brandLabel.font = .systemFont(ofSize: 14)
//        brandLabel.textColor = .gray
//        brandLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        addSubview(productImageView)
//        addSubview(nameLabel)
//        addSubview(brandLabel)
//        
//        setupConstraints()
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//            productImageView.widthAnchor.constraint(equalToConstant: 80),
//            productImageView.heightAnchor.constraint(equalToConstant: 80),
//            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
//
//            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
//            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            nameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
//
//            brandLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
//            brandLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
//            brandLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
//            brandLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
//        ])
//    }
//    
//    // MARK: - Configuration
//    
//    /// Configures the view with product data.
//    ///
//    /// - Parameter productModel: The view model representing product information.
//    private func configure(with productModel: ProductListItemViewModel) {
//        nameLabel.text = productModel.name
//        brandLabel.text = productModel.brand ?? ""
//        
//        if let imageUrl = productModel.imageUrl {
//            productImageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "photo"))
//        } else {
//            productImageView.image = UIImage(systemName: "photo")
//        }
//    }
//}


/// A reusable view that displays product information such as image, name, and brand.
public final class ProductView: UIView {
    
    // MARK: - UI Components
    
    private let productImageView = UIImageView()
    private let nameLabel = UILabel()
    private let brandLabel = UILabel()
    
    // 🔥 Guardar el modelo de forma ligera
    private var viewModel: ProductListItemViewModel?
    
    // MARK: - Initializer
    
    public init(data: ProductListItemViewModel) {
        super.init(frame: .zero)
        self.viewModel = data
        setupView()
        configure(with: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .white
        
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        brandLabel.font = .systemFont(ofSize: 14)
        brandLabel.textColor = .secondaryLabel
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(productImageView)
        addSubview(nameLabel)
        addSubview(brandLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),

            brandLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            brandLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            brandLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            brandLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func configure(with model: ProductListItemViewModel) {
        nameLabel.text = model.name
        brandLabel.text = model.brand
        
        if let imageUrl = model.imageUrl {
            productImageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "photo"))
        } else {
            productImageView.image = UIImage(systemName: "photo")
        }
    }
    
    // 🔥 Método público para exponer el modelo si lo necesitas (opcional)
    public func getModel() -> ProductListItemViewModel? {
        return viewModel
    }
}
