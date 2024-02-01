//
//  TransactionsViewModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-05-29.
//

import Foundation
import SQLite

class TransactionsViewModel : ObservableObject {
    
    public static var shared:TransactionsViewModel = {
        let model = TransactionsViewModel()
        return model
    }()
    
    @Published var pubTransactionsData: [TransactionsModel] = []
    @Published var pubTransactionsSectionData: [TransactionSectionData] = []
    @Published var pubPreviousTransactionDate: Date?
    @Published var pubIsTransactionsLoading: Bool = true
    @Published var pubCurrentListType: CreationType = .income
    
    @Published var allTransactions: [TransactionsModel] = []
    @Published var incomeTransactions: [TransactionsModel] = []
    @Published var expenseTransactions: [TransactionsModel] = []
    
    @Published var pubIsIntTransactionsLoading: Bool = true
    @Published var allIntTransactions: [InternationalTransactionsModel] = []
    @Published var pubIntTransactionsSectionData: [IntTransactionSectionData] = []
    
}
