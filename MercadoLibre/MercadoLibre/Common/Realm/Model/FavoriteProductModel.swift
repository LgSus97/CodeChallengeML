//
//  FavoriteProductModel.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//
import Foundation
import RealmSwift

final class FavoriteProductModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var imageUrlString: String?
    @Persisted var brand: String?
    @Persisted var model: String?
    @Persisted var color: String?
    @Persisted var badges: List<ProductBadge>

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

