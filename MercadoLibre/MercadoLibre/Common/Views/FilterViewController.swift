//
//  FilterViewController.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import UIKit

/// A view controller that allows users to select brand and color filters.
final class FilterViewController: UIViewController {

    // MARK: - Properties

    var brands: [String] = []
    var colors: [String] = []
    
    /// Closure called when the user applies selected filters.
    var onApplyFilters: ((String?, String?) -> Void)?
    
    private var selectedBrand: String?
    private var selectedColor: String?
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filters"
        view.backgroundColor = .systemGroupedBackground
        setupTableView()
        setupNavigationBar()
    }

    // MARK: - Setup Methods

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Apply",
            style: .done,
            target: self,
            action: #selector(applyFilters)
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Clear",
            style: .plain,
            target: self,
            action: #selector(clearFilters)
        )
    }

    // MARK: - Actions

    @objc private func applyFilters() {
        onApplyFilters?(selectedBrand, selectedColor)
        dismiss(animated: true)
    }

    @objc private func clearFilters() {
        selectedBrand = nil
        selectedColor = nil
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? brands.count : colors.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Brand" : "Color"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()

        if indexPath.section == 0 {
            let brand = brands[indexPath.row]
            config.text = brand
            config.image = UIImage(systemName: "tag")
            cell.accessoryType = (brand == selectedBrand) ? .checkmark : .none
        } else {
            let color = colors[indexPath.row]
            config.text = color
            config.image = UIImage(systemName: "paintpalette")
            cell.accessoryType = (color == selectedColor) ? .checkmark : .none
        }

        config.textProperties.color = .label
        cell.contentConfiguration = config
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let brand = brands[indexPath.row]
            selectedBrand = (selectedBrand == brand) ? nil : brand
        } else {
            let color = colors[indexPath.row]
            selectedColor = (selectedColor == color) ? nil : color
        }

        tableView.reloadData()
    }
}
