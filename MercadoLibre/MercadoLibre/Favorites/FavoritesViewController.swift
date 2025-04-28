//
//  FavoritesViewController.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 25/04/25.
//

import UIKit

final class FavoritesViewController: UIViewController {

    var interactor: FavoritesInteractorProtocol?
    private var favorites: [ProductListItemViewModel] = []
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let width = UIScreen.main.bounds.width - 32
        layout.itemSize = CGSize(width: width, height: 120)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let emptyStateView = EmptyStateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Favoritos"

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(FavoriteProductCell.self, forCellWithReuseIdentifier: "FavoriteProductCell")
        
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            emptyStateView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
        
        emptyStateView.isHidden = true
    }

    private func loadFavorites() {
        favorites = interactor?.getProducts() ?? []
        collectionView.reloadData()
        collectionView.animateVisibleCells()
        checkIfFavoritesEmpty()
    }
    
    private func checkIfFavoritesEmpty() {
        let hasFavorites = !favorites.isEmpty
        collectionView.isHidden = !hasFavorites
        emptyStateView.isHidden = hasFavorites
    }
    
    private func makePreview(for product: ProductListItemViewModel) -> UIViewController {
        let previewContainer = UIViewController()
        previewContainer.view.backgroundColor = .clear

        let previewCard = ProductPreviewView(product: product)
        previewCard.translatesAutoresizingMaskIntoConstraints = false

        previewContainer.view.addSubview(previewCard)

        NSLayoutConstraint.activate([
            previewCard.leadingAnchor.constraint(equalTo: previewContainer.view.leadingAnchor, constant: 20),
            previewCard.trailingAnchor.constraint(equalTo: previewContainer.view.trailingAnchor, constant: -20),
            previewCard.centerYAnchor.constraint(equalTo: previewContainer.view.centerYAnchor)
        ])

        previewCard.animateAppearWithSpring()

        return previewContainer
    }

    private func handleDeleteFavorite(at indexPath: IndexPath) {
        let favorite = favorites[indexPath.item]

        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                cell.alpha = 0
            }, completion: { _ in
                self.interactor?.removeRemoveProduct(favorite.id)
                self.favorites.remove(at: indexPath.item)
                self.collectionView.deleteItems(at: [indexPath])
                self.checkIfFavoritesEmpty()
            })
        } else {
            self.interactor?.removeRemoveProduct(favorite.id)
            self.favorites.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
            self.checkIfFavoritesEmpty()
        }
    }

}

// MARK: - CollectionView

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = favorites[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteProductCell", for: indexPath) as? FavoriteProductCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let favorite = favorites[indexPath.item]
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] in
                guard let self = self else { return nil }
                return self.makePreview(for: favorite)
            },
            actionProvider: { [weak self] _ in
                guard let self = self else { return nil }
                
                let delete = UIAction(title: "Eliminar", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    self.handleDeleteFavorite(at: indexPath)
                }
                
                return UIMenu(title: "", children: [delete])
            }
        )
    }

}


