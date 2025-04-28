//
//  SearchHistoryCell.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 27/04/25.
//

import UIKit

/// A custom UICollectionViewCell that displays a previous search query from the search history.
final class SearchHistoryCell: UICollectionViewCell {
    
    // MARK: - UI Components

    private let clockIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let historyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        
        contentView.addSubview(clockIcon)
        contentView.addSubview(historyLabel)
        
        NSLayoutConstraint.activate([
            clockIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            clockIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            clockIcon.widthAnchor.constraint(equalToConstant: 20),
            clockIcon.heightAnchor.constraint(equalToConstant: 20),
            
            historyLabel.leadingAnchor.constraint(equalTo: clockIcon.trailingAnchor, constant: 12),
            historyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            historyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // MARK: - Public Methods

    /// Configures the cell with a given search text.
    /// - Parameter text: The search query to display.
    func configure(with text: String) {
        historyLabel.text = text
    }
}

