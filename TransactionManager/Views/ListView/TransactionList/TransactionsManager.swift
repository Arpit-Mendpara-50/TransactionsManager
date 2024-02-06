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
    
    public static var shared: TransactionsManager = {
        let mgr = TransactionsManager()
        return mgr
    }()
    
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
            viewModel.allTransactions = transactionsArray
            viewModel.pubIsTransactionsLoading = false
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

}
