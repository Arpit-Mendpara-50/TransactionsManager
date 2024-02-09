//
//  CurrencyPickerModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-04.
//

import Foundation

struct Currency: Identifiable, Hashable {
    let id: Int
    let name: String
    let icon: String
    let code: String
}

class CurrencyPickerModel : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:CurrencyPickerModel = {
        let model = CurrencyPickerModel()
        model.getSelectedCurrency()
        return model
    }()
    
    @Published var pubSelectedCurrency: Currency = Currency(id: 2, name: "CAD", icon: "ic_canada", code: "$")
    @Published var pubSelectedCurrencyForTransaction: Currency = Currency(id: 2, name: "CAD", icon: "ic_canada", code: "$")
    @Published var pubShowCurrencyListView: Bool = false
    
    let currencies = [
        Currency(id: 1, name: "INR", icon: "ic_india", code: "₹"),
        Currency(id: 2, name: "CAD", icon: "ic_canada", code: "$"),
        Currency(id: 3, name: "USD", icon: "ic_usa", code: "$"),
        Currency(id: 4, name: "AUD", icon: "ic_australia", code: "$"),
        Currency(id: 5, name: "RUB", icon: "ic_russia", code: "₽")
        // Add more currencies as needed
    ]
    
    func getSelectedCurrency() {
        let currencyId = UserDefaults.standard.integer(forKey: "SelectedCurrency")
        if let currency = self.currencies.first(where: {$0.id == currencyId}) {
            pubSelectedCurrency = currency
            pubSelectedCurrencyForTransaction = currency
        }
    }
    
    func getCurrencyById(id: Int) -> Currency {
        if let currency = CurrencyPickerModel.shared.currencies.first(where: {$0.id == id}) {
            return currency
        }
        return currencies[0]
    }
}
