//
//  TransactionsManager.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-05-29.
//

import Foundation
import SwiftUI

class TransactionsManager: ObservableObject {
    
    @ObservedObject var viewModel = TransactionsViewModel.shared
    @ObservedObject var databaseManager = DatabaseManager.shared
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    
    public static var shared: TransactionsManager = {
        let mgr = TransactionsManager()
        return mgr
    }()
    
    /*public func applyFilter(transactionsArray: [TransactionsModel]) {
     var returnData = transactionsArray
     let monthAndYear = "\(filterViewModel.pubSelectedMonth) \(filterViewModel.pubSelectedYear)"
     let currency = currencyPickerModel.pubSelectedCurrency.id
     returnData = transactionsArray.filter({$0.currencyType == currency})
     if !monthAndYear.isEmpty {
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
     
     let filterDateFormatter = DateFormatter()
     filterDateFormatter.dateFormat = "MMMM yyyy"
     
     let filterMonthAndYearData = returnData.filter { item in
     if let date = dateFormatter.date(from: item.createdDate),
     filterDateFormatter.string(from: date) == monthAndYear {
     return true
     }
     return false
     }
     returnData = filterMonthAndYearData
     }
     
     viewModel.allTransactions = returnData
     viewModel.pubIsTransactionsLoading = false
     }*/
    
    public func applyFilter(transactionsArray: [TransactionsModel]) {
        let currency = currencyPickerModel.pubSelectedCurrency.id
        let currencyFilter = transactionsArray.filter({$0.currencyType == currency})
        viewModel.allTransactions = currencyFilter
        viewModel.pubIsTransactionsLoading = false
    }
    
    public func getTransactionsList() {
        var transactionsArray: [TransactionsModel] = []
        if let db = databaseManager.db, var transactions = databaseManager.transactions{
            transactions = transactions.order(databaseManager.transactionId.asc)
            do{
                for transaction in try db.prepare(transactions){
                    let transactionData: TransactionsModel = TransactionsModel()
                    transactionData.id = transaction[databaseManager.transactionId]
                    transactionData.title = transaction[databaseManager.transactionTitle]
                    transactionData.amount = transaction[databaseManager.transactionAmount]
                    transactionData.category = CategoryManager.shared.getCategory(idValue: transaction[databaseManager.transactionCategory])
                    transactionData.description = transaction[databaseManager.transactionDescription]
                    transactionData.transactionType = transaction[databaseManager.transactionType]
                    transactionData.currencyType = transaction[databaseManager.transactionCurrencyType]
                    transactionData.peopleIncluded = transaction[databaseManager.peopleIncluded]
                    transactionData.createdDate = transaction[databaseManager.transactionCreatedDate]
                    transactionData.updatedDate = transaction[databaseManager.transactionUpdatedDate]
                    transactionsArray.append(transactionData)
                }
            } catch{
                print(error.localizedDescription)
            }
            applyFilter(transactionsArray: transactionsArray)
        }else{
            print("Something went wrong")
            viewModel.pubIsTransactionsLoading = false
        }
    }
    
    public func getInternationalTransactionsList() {
        var transactionsArray: [InternationalTransactionsModel] = []
        if let db = databaseManager.db, var transactions = databaseManager.internationalTransactions{
            transactions = transactions.order(databaseManager.transactionId.asc)
            do{
                for transaction in try db.prepare(transactions){
                    let transactionData: InternationalTransactionsModel = InternationalTransactionsModel()
                    transactionData.id = transaction[databaseManager.intTransactionId]
                    transactionData.title = transaction[databaseManager.intTransactionTitle]
                    transactionData.baseAmount = transaction[databaseManager.intTransactionBaseamount]
                    transactionData.conversionAmount = transaction[databaseManager.intTransactionConversionAmount]
                    transactionData.description = transaction[databaseManager.intTransactionDescription]
                    transactionData.baseCurrencyType = transaction[databaseManager.intTransactionBaseCurrencyType]
                    transactionData.conversionCurrencyType = transaction[databaseManager.intTransactionConversionCurrencyType]
                    transactionData.createdDate = transaction[databaseManager.intTransactionCreatedDate]
                    transactionData.updatedDate = transaction[databaseManager.intTransactionUpdatedDate]
                    transactionsArray.append(transactionData)
                }
            } catch{
                print(error.localizedDescription)
            }
            viewModel.allIntTransactions = transactionsArray
            viewModel.pubIsIntTransactionsLoading = false
        }else{
            print("Something went wrong")
            viewModel.pubIsIntTransactionsLoading = false
        }
    }
    
    func deleteTransaction(idValue: Int64, peopleIncluded: String, amountValue: String, transactionCurrencyType: Int) {
        databaseManager.deleteTransaction(idValue: idValue, completionHandler: { [self]_,_ in
            HomeViewModel.shared.getAllTransactions()
            viewModel.filterTransactionsData()
            PeopleManager.shared.getPeopleList()
            let people = viewModel.getPeopleIncluded(people: peopleIncluded)
            let peopleId = people.map({$0.id})
            PeopleViewModel.shared.updatePeopleData(transactionCurrencyType: transactionCurrencyType)
        })
    }
    
}
