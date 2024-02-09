//
//  HomeViewModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-06.
//

import SwiftUI

class HomeViewModel : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:HomeViewModel = {
        let model = HomeViewModel()
        model.initialize()
        return model
    }()
    
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    @ObservedObject var transactionsManager = TransactionsManager.shared
    @ObservedObject var transactionsViewModel = TransactionsViewModel.shared
    @ObservedObject var peopleManager = PeopleManager.shared
    @ObservedObject var peopleViewModel = PeopleViewModel.shared
    @ObservedObject var helper = Helper.shared
    
    @Published var pubShowCreationView = false
    @Published var pubShowInternationalCreationView = false
    
    public func initialize() {
        helper.getCurrency()
        getAllTransactions()
        getPeople()
        getAllInternationalTransactions()
        currencyPickerModel.getSelectedCurrency()
    }
    
    func openListPage() {
        transactionsViewModel.pubTransactionsSectionData.removeAll()
        transactionsViewModel.pubPreviousTransactionDate = nil
        transactionsViewModel.filterTransactionsData()
        transactionsViewModel.pubShowListView = true
    }
    
    func getAllTransactions() {
        transactionsViewModel.pubIsTransactionsLoading = true
        transactionsManager.getTransactionsList()
    }
    
    func getAllInternationalTransactions() {
        transactionsViewModel.pubIsIntTransactionsLoading = true
        transactionsManager.getInternationalTransactionsList()
    }
    
    func getPeople() {
        peopleViewModel.pubIsPeopleLoading = true
        peopleManager.getPeopleList()
    }
}
