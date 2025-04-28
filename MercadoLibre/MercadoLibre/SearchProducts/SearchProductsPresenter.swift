//
//  SearchProductsPresenter.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

class SearchProductsPresenter {
    weak var view: SearchProductsViewProtocol?
    
    init(view: SearchProductsViewProtocol?) {
        self.view = view
    }
}

extension SearchProductsPresenter: SearchProductsPresenterProtocol {
    func displayData(products: [ProductListItemViewModel]) {
        view?.displayData(products: products)
    }
        
    func showLoader() {
        view?.showLoader()
    }
    
    func hideLoader() {
        view?.hideLoader()
    }
    
    func showError() {
        view?.showError()
    }
}
