//
//  BadgeView.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 27/04/25.
//

import UIKit


// MARK: - InsetLabel

/// A UILabel subclass that adds padding around its text.
class InsetLabel: UILabel {
    
    var contentInset = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + contentInset.left + contentInset.right,
            height: size.height + contentInset.top + contentInset.bottom
        )
    }
}

// MARK: - BadgeView

/// A badge view with custom padding and background color.
final class BadgeView: InsetLabel {

    init(text: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.text = text
        self.font = .systemFont(ofSize: 11, weight: .semibold)
        self.textColor = .white
        self.backgroundColor = backgroundColor
        self.textAlignment = .center
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - BadgesFlowView

/// A custom view that arranges badges in a wrapping flow layout.
final class BadgesFlowView: UIView {
    
    // MARK: - Properties
    
    private var badges: [ProductBadge] = []
    private let spacing: CGFloat = 4
    private let badgeHeight: CGFloat = 20
    private var badgeLabels: [UILabel] = []

    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()

        badgeLabels.forEach { $0.removeFromSuperview() }
        badgeLabels.removeAll()

        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        let maxWidth = bounds.width

        for badge in badges {
            let label = makeLabel(for: badge)
            label.sizeToFit()

            var labelWidth = label.frame.width + 12
            if labelWidth > maxWidth {
                labelWidth = maxWidth
            }

            if currentX + labelWidth > maxWidth {
                currentX = 0
                currentY += badgeHeight + spacing
            }

            label.frame = CGRect(x: currentX, y: currentY, width: labelWidth, height: badgeHeight)
            addSubview(label)
            badgeLabels.append(label)

            currentX += labelWidth + spacing
        }

        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        let totalHeight = badgeLabels.last?.frame.maxY ?? 0
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    // MARK: - Public Methods

    /// Sets the badges to display.
    func setBadges(_ badges: [ProductBadge]) {
        self.badges = badges
        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - Private Methods

    private func makeLabel(for badge: ProductBadge) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = badgeHeight / 2
        label.clipsToBounds = true
        label.backgroundColor = backgroundColor(for: badge)
        label.text = text(for: badge)
        return label
    }

    private func backgroundColor(for badge: ProductBadge) -> UIColor {
        switch badge {
        case .freeShipping:
            return UIColor.systemGreen
        case .limitedStock:
            return UIColor.systemOrange
        case .internationalShipping:
            return UIColor.systemBlue
        }
    }

    private func text(for badge: ProductBadge) -> String {
        switch badge {
        case .freeShipping:
            return "Free Shipping"
        case .limitedStock:
            return "Limited Stock"
        case .internationalShipping:
            return "International Shipping"
        }
    }
}

// MARK: - BadgeCell

/// A UICollectionViewCell that displays a badge.
final class BadgeCell: UICollectionViewCell {
    
    static let reuseIdentifier = "BadgeCell"
    
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.backgroundColor = .systemGray
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    /// Configures the cell with a given badge.
    func configure(with badge: ProductBadge) {
        switch badge {
        case .freeShipping:
            contentView.backgroundColor = UIColor.systemGreen
            label.text = "Free Shipping"
        case .limitedStock:
            contentView.backgroundColor = UIColor.systemOrange
            label.text = "Limited Stock"
        case .internationalShipping:
            contentView.backgroundColor = UIColor.systemBlue
            label.text = "International Shipping"
        }
    }
}

// MARK: - LeftAlignedCollectionViewFlowLayout

/// A custom flow layout that aligns cells to the left.
final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0

        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }

        return attributes
    }
}
