//
//  PersonTransactionsViewModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-02.
//

import Foundation
import SwiftUI

class PersonTransactionsViewModel : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:PersonTransactionsViewModel = {
        let model = PersonTransactionsViewModel()
        return model
    }()
    
    @Published var pubShowPersonTransactionsList = false
    @Published var pubSelectedPerson: PeopleModel?
    @Published var pubPersonTransactions: [TransactionsModel] = []
    @Published var pubIsLoading = true
    
    @ObservedObject var transactionsManager = TransactionsManager.shared
    @ObservedObject var transactionsViewModel = TransactionsViewModel.shared
    @ObservedObject var filterViewModel = FilterViewModel.shared
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    
    
    func openPeronTransactionListView(person: PeopleModel) {
        self.pubSelectedPerson = person
        self.filterPersonData()
//        transactionsViewModel.pubCurrentListType = .transaction
//        transactionsViewModel.pubTransactionsSectionData.removeAll()
//        transactionsManager.loadSectionData(data: self.pubPersonTransactions)
//        self.pubShowPersonTransactionsList = true
//        pubIsLoading = false
    }
    
    func filterPersonData() {
        let allData = transactionsViewModel.allTransactions
        if !allData.isEmpty, let person = pubSelectedPerson {
            let id = String(person.id)
            let transactionsData = allData.filter({$0.peopleIncluded.contains(id)})
//            print(filteredData.map({$0.createdDate}))
//            self.pubPersonTransactions = filteredData
            let monthAndYear = "\(filterViewModel.pubSelectedMonth) \(filterViewModel.pubSelectedYear)"
            let filteredData = filterViewModel.applyFilter(data: transactionsData, filterMonthAndYear: monthAndYear, selectedCategory: filterViewModel.pubSelectedCategory, amountRange: filterViewModel.pubSelectedRange, currency: currencyPickerModel.pubSelectedCurrency)
            self.pubPersonTransactions = filteredData
            transactionsViewModel.pubCurrentListType = .transaction
            transactionsViewModel.pubTransactionsSectionData.removeAll()
            transactionsViewModel.loadSectionData(data: self.pubPersonTransactions)
            self.pubShowPersonTransactionsList = true
            pubIsLoading = false
        }
    }
}
