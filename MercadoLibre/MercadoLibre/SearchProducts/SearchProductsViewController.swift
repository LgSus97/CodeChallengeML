//
//  SearchViewController.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import UIKit


final class SearchProductsViewController: UIViewController {

    private var state: SearchState = .results
    private var products: [ProductListItemViewModel] = []
    private var searchHistory: [String] = []
    private var filteredSuggestions: [String] = []

    private let emptyStateView = EmptyStateView()
    private let searchBar = UISearchBar()

    var interactor: SearchProductsInteractorProtocol?
    var router: SearchProductsRouterProtocol?

    private lazy var collectionView: UICollectionView = {
        let layout = makeFlowLayoutForProducts()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductGridCell.self, forCellWithReuseIdentifier: "ProductGridCell")
        collectionView.register(SearchHistoryCell.self, forCellWithReuseIdentifier: "SearchHistoryCell")
        return collectionView
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupEmptyStateActions()
        interactor?.getProducts(from: "tazas")
        searchHistory = interactor?.getHistory() ?? []
    }

    private func setupView() {
        view.backgroundColor = .white
        title = "Inicio"

        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(searchBar)
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(emptyStateView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        searchBar.placeholder = "Buscar productos"
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()

        let filterButton = UIBarButtonItem(title: "Filtros", style: .plain, target: self, action: #selector(didTapFilter))
        navigationItem.rightBarButtonItem = filterButton

        collectionView.isHidden = true
        emptyStateView.isHidden = true
    }

    private func setupEmptyStateActions() {
        emptyStateView.onButtonTap = { [weak self] in
            self?.interactor?.getProducts(from: "tazas")
        }
    }

    @objc private func didTapFilter() {
        guard let filters = interactor?.extractAvailableFilters(from: products) else { return }
        let filterVC = FilterViewController()
        filterVC.brands = filters.brands
        filterVC.colors = filters.colors
        filterVC.onApplyFilters = { [weak self] brand, color in
            self?.applyFilters(brand: brand, model: nil, color: color)
        }
        let navController = UINavigationController(rootViewController: filterVC)
        navController.modalPresentationStyle = .automatic
        present(navController, animated: true)
    }

    private func applyFilters(brand: String?, model: String?, color: String?) {
        let filteredModels = interactor?.filterProducts(products: products, brand: brand, model: model, color: color) ?? []
        self.products = filteredModels
        collectionView.reloadData()
    }

    private func makeFlowLayoutForProducts() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let width = (UIScreen.main.bounds.width - 48) / 2
        layout.itemSize = CGSize(width: width, height: 240)
        return layout
    }

    private func makeFlowLayoutForHistory() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        return layout
    }

    private func updateLayout() {
        let layout = (state == .results) ? makeFlowLayoutForProducts() : makeFlowLayoutForHistory()
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    private func handleFavoriteTapped(for model: ProductListItemViewModel) {
        var newModel = model
        newModel.isFavorite.toggle()

        if newModel.isFavorite {
            FavoritesManager.shared.addFavorite(model: newModel)
        } else {
            FavoritesManager.shared.removeFavorite(id: newModel.id)
        }

        if let index = products.firstIndex(where: { $0.id == model.id }) {
            products[index] = newModel
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
}

// MARK: - SearchProductsViewProtocol

extension SearchProductsViewController: SearchProductsViewProtocol {

    func displayData(products: [ProductListItemViewModel]) {
        let favorites = FavoritesManager.shared.fetchFavorites()

        self.products = products.map { product in
            var mutableProduct = product
            mutableProduct.isFavorite = favorites.contains(where: { $0.id == product.id })
            return mutableProduct
        }

        DispatchQueue.main.async {
            self.state = .results
            self.updateLayout()
            self.collectionView.isHidden = false
            self.emptyStateView.isHidden = true
            self.collectionView.reloadData()
        }
    }

    func showEmptyState(showClearButton: Bool = false) {
        emptyStateView.configure(showButton: showClearButton)
        emptyStateView.animateFallIn()
        collectionView.isHidden = true
        navigationItem.rightBarButtonItem?.isHidden = true
    }

    func showLoader() {}
    func hideLoader() {}
    func showError() {}
}

// MARK: - UICollectionViewDataSource & Delegate

extension SearchProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .idle: return searchHistory.count
        case .suggesting: return filteredSuggestions.count
        case .results: return products.count
        case .empty: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch state {
        case .idle, .suggesting:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchHistoryCell", for: indexPath) as? SearchHistoryCell else {
                return UICollectionViewCell()
            }
            let text = (state == .idle ? searchHistory[indexPath.item] : filteredSuggestions[indexPath.item])
            cell.configure(with: text)
            return cell

        case .results:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductGridCell", for: indexPath) as? ProductGridCell else {
                return UICollectionViewCell()
            }
            let model = products[indexPath.item]
            cell.configure(with: model)
            cell.onFavoriteTapped = { [weak self] in
                self?.handleFavoriteTapped(for: model)
            }
            return cell

        case .empty:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected: String
        switch state {
        case .idle: selected = searchHistory[indexPath.item]
        case .suggesting: selected = filteredSuggestions[indexPath.item]
        case .results, .empty: return
        }

        searchBar.text = selected
        searchBar.resignFirstResponder()
        state = .results
        updateLayout()
        interactor?.getProducts(from: selected)
    }
}

// MARK: - UISearchBarDelegate

extension SearchProductsViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchHistory = interactor?.getHistory() ?? []
        filteredSuggestions = searchHistory
        state = .idle
        updateLayout()
        collectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        state = .results
        updateLayout()
        interactor?.getProducts(from: "tazas")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        interactor?.saveSearch(query)
        searchHistory = interactor?.getHistory() ?? []
        state = .results
        updateLayout()
        interactor?.getProducts(from: query)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            state = .idle
            updateLayout()
            collectionView.reloadData()
        } else {
            state = .suggesting
            filteredSuggestions = interactor?.getSuggestions(from: searchText) ?? []
            collectionView.reloadData()
        }
    }
}
