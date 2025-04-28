//
//  FavoriteProductModel.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//
import Foundation
import RealmSwift

/// A Realm model representing a favorite product.
final class FavoriteProductModel: Object {
    
    /// The unique identifier of the product.
    @Persisted(primaryKey: true) var id: String
    
    /// The product's name.
    @Persisted var name: String
    
    /// The URL string of the product's image.
    @Persisted var imageUrlString: String?
    
    /// The product's brand name.
    @Persisted var brand: String?
    
    /// The product's model name.
    @Persisted var model: String?
    
    /// The product's color.
    @Persisted var color: String?
    
    /// A list of badges associated with the product.
    @Persisted var badges: List<ProductBadge>

    /// Creates a `FavoriteProductModel` from a `ProductListItemViewModel`.
    /// - Parameter model: The view model to map from.
    /// - Returns: A populated `FavoriteProductModel` instance.
    static func from(model: ProductListItemViewModel) -> FavoriteProductModel {
        let favorite = FavoriteProductModel()
        favorite.id = model.id
        favorite.name = model.name
        favorite.imageUrlString = model.imageUrl?.absoluteString
        favorite.brand = model.brand
        favorite.model = model.model
        favorite.color = model.color
        favorite.badges.append(objectsIn: model.badges)
        return favorite
    }

    /// Converts the current model into a `ProductListItemViewModel`.
    /// - Returns: A `ProductListItemViewModel` populated with the model's data.
    func toProductListItemViewModel() -> ProductListItemViewModel {
        return ProductListItemViewModel(
            id: id,
            name: name,
            imageUrl: imageUrlString.flatMap { URL(string: $0) },
            brand: brand,
            model: model,
            color: color,
            badges: Array(badges),
            isFavorite: true
        )
    }
}

