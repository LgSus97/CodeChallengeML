//
//  SearchViewController.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import UIKit

final class SearchProductsViewController: UIViewController {
    
    private var state: SearchState = .idle
    private var products: [ProductListItemViewModel] = []
    private var productViews = [ProductView]()
    
    private let emptyStateView = EmptyStateView()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchBar = UISearchBar()
    
    private var searchHistory: [String] = []
    private var suggestions: [String] = []
    private var filteredSuggestions: [String] = []
    private var isSearching: Bool = false
    
    
    // MARK: - Properties
    
    var interactor: SearchProductsInteractorProtocol?
    var router: SearchProductsRouterProtocol?
    
    // MARK: - Initializers
    
    init(wireframe: SearchProductsRouterProtocol) {
        self.router = wireframe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupEmptyStateActions()
        state = .results
        interactor?.getProducts(from: "tazas")
        searchHistory = interactor?.getHistory() ?? []
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Inicio"
        
        setupMainStackView()
        setupSearchBar()
        setupNavigationBar()
        setupTableView()
        setupEmptyStateView()
    }
    
    private func setupMainStackView() {
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(title: "Filtros", style: .plain, target: self, action: #selector(didTapFilter))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Buscar productos"
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        
        mainStackView.addArrangedSubview(searchBar)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.addArrangedSubview(tableView)
    }
    
    private func setupEmptyStateView() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(emptyStateView)
        emptyStateView.isHidden = true
    }
    
    private func setupTableViewData(options: [ProductView]) {
        productViews = options
        tableView.reloadData()
        tableView.animateVisibleCells()
    }
    
    @objc
    private func didTapFilter() {
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
        let filteredModels = interactor?.filterProducts(
            products: products,
            brand: brand?.isEmpty == true ? nil : brand,
            model: model?.isEmpty == true ? nil : model,
            color: color?.isEmpty == true ? nil : color
        ) ?? []
        
        productViews = filteredModels.map { ProductView(data: $0) }
        
        if productViews.isEmpty {
            showEmptyState()
            navigationItem.rightBarButtonItem?.isHidden = true
        } else {
            emptyStateView.isHidden = true
            tableView.isHidden = false
            navigationItem.rightBarButtonItem?.isHidden = false
            tableView.reloadData()
            tableView.animateVisibleCells()
        }
    }
    
    private func setupEmptyStateActions() {
        emptyStateView.onButtonTap = { [weak self] in
            self?.resetFilters()
        }
    }
    
    private func resetFilters() {
        self.productViews = self.products.map { ProductView(data: $0) }
        
        emptyStateView.animateDisappear { [weak self] in
            self?.tableView.isHidden = false
            self?.navigationItem.rightBarButtonItem?.isHidden = false
            self?.tableView.reloadData()
            self?.tableView.animateVisibleCells()
        }
    }
    
}

extension SearchProductsViewController: SearchProductsViewProtocol {
    
    func displayData(products: [ProductView]) {
        self.productViews = products
        self.products = products.compactMap { $0.getModel() }
        
        let hasProducts = !products.isEmpty
        emptyStateView.isHidden = hasProducts
        tableView.isHidden = !hasProducts
        navigationItem.rightBarButtonItem?.isHidden = !hasProducts
        
        if hasProducts {
            tableView.reloadData()
            tableView.animateVisibleCells()
        }
    }
    
    func showEmptyState(showClearButton: Bool = false) {
        emptyStateView.configure(showButton: showClearButton)
        emptyStateView.animateFallIn()
        tableView.isHidden = true
        navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
    
    func showError() {
        
    }
    
}

extension SearchProductsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .idle:
            return searchHistory.count
        case .suggesting:
            return filteredSuggestions.count
        case .results:
            return productViews.count
        case .empty:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.imageView?.image = nil
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        switch state {
        case .idle:
            let searchText = searchHistory[indexPath.row]
            cell.textLabel?.text = searchText
            cell.imageView?.image = UIImage(systemName: "clock")
            cell.imageView?.tintColor = .gray
            
        case .suggesting:
            let suggestion = filteredSuggestions[indexPath.row]
            cell.textLabel?.text = suggestion
            
        case .results:
            cell.textLabel?.text = nil
            
            let productView = productViews[indexPath.row]
            productView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(productView)
            
            NSLayoutConstraint.activate([
                productView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                productView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                productView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                productView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
            
            productView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                productView.alpha = 1
            }
            
        case .empty:
            showEmptyState(showClearButton: true)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected: String
        switch state {
        case .idle:
            selected = searchHistory[indexPath.row]
        case .suggesting:
            selected = filteredSuggestions[indexPath.row]
        case .results, .empty:
            return
        }
        
        searchBar.text = selected
        searchBar.resignFirstResponder()
        
        state = .results
        tableView.reloadData()
        tableView.animateVisibleCells()
        
        interactor?.getProducts(from: selected)
    }
    
}

extension SearchProductsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        searchHistory = interactor?.getHistory() ?? []
        filteredSuggestions = searchHistory
        
        state = .idle
        tableView.reloadData()
        tableView.animateVisibleCells()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        state = .results
        interactor?.getProducts(from: "tazas")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty else { return }
        
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
        // Guardar nueva búsqueda en Realm
        interactor?.saveSearch(query)
        
        // Actualizar el historial para futuras sugerencias
        searchHistory = interactor?.getHistory() ?? []
        
        // 🟡 MANDAR A PEDIR PRODUCTOS
        interactor?.getProducts(from: query)
        
        // 🟡 Mostrar el estado de resultados
        state = .results
        tableView.reloadData()
        tableView.animateVisibleCells()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            // Si no hay texto, muestra historial
            filteredSuggestions = searchHistory
            state = .idle
            tableView.reloadData()
            tableView.animateVisibleCells()
            return
        }
        
        // Si hay texto, filtra sugerencias
        filteredSuggestions = interactor?.getSuggestions(from: searchText) ?? []
        
        state = .suggesting
        tableView.reloadData()
        tableView.animateVisibleCells()
    }
    
}

