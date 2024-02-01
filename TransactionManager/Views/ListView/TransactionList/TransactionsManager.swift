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
            transactions = transactions.order(databaseManager.id.asc)
            do{
                for transaction in try db.prepare(transactions){
                    let transactionData: TransactionsModel = TransactionsModel()
                    transactionData.id = transaction[databaseManager.id]
                    transactionData.title = transaction[databaseManager.title]
                    transactionData.amount = transaction[databaseManager.amount]
                    transactionData.category = CategoryManager.shared.getCategory(idValue: transaction[databaseManager.category])
                    transactionData.description = transaction[databaseManager.description]
                    transactionData.transactionType = transaction[databaseManager.transactionType]
                    transactionData.peopleIncluded = transaction[databaseManager.peopleIncluded]
                    transactionData.createdDate = transaction[databaseManager.createdDate]
                    transactionData.updatedDate = transaction[databaseManager.updatedDate]
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
            transactions = transactions.order(databaseManager.id.asc)
            do{
                for transaction in try db.prepare(transactions){
                    let transactionData: InternationalTransactionsModel = InternationalTransactionsModel()
                    transactionData.id = transaction[databaseManager.intTransactionId]
                    transactionData.title = transaction[databaseManager.intTransactionTitle]
                    transactionData.baseAmount = transaction[databaseManager.intTransactionBaseamount]
                    transactionData.conversionAmount = transaction[databaseManager.intTransactionConversionAmount]
                    transactionData.description = transaction[databaseManager.intTransactionDescription]
                    transactionData.createdDate = transaction[databaseManager.intTransactionCreatedDate]
                    transactionData.updatedDate = transaction[databaseManager.intTransactionUpdatedDate]
                    transactionsArray.append(transactionData)
                }
            } catch{
                print(error.localizedDescription)
            }
            viewModel.allIntTransactions = transactionsArray
            viewModel.pubIsIntTransactionsLoading = false
            for item in transactionsArray {
                print("-----------------------")
                print(item.title)
                print((Double(item.baseAmount) ?? 0.0)*(Double(item.conversionAmount) ?? 0.0))
                print("-----------------------")
            }
        }else{
            print("Something went wrong")
            viewModel.pubIsIntTransactionsLoading = false
        }
    }
    
    func loadSectionData(data: [TransactionsModel]){
        var dates = [String]()
        for item in data{
            let date = item.createdDate.convertDate()
            dates.append(date.toStringDate())
        }
        let uniqueDates = getUniqueValues(from: dates)
        var sectionArray = [TransactionSectionData]()
        for date in uniqueDates {
            var sectionData = [TransactionsModel]()
            var sectionDate = ""
            for item in data{
                if item.transactionType == viewModel.pubCurrentListType.rawValue ||  viewModel.pubCurrentListType.rawValue == 2{
                    let convertedDate = item.createdDate.convertDate()
                    if date == convertedDate.toStringDate(){
                        sectionDate = convertedDate.toStringDate()
                        sectionData.append(item)
                    }
                }
            }
            if !sectionData.isEmpty {
                sectionArray.append(TransactionSectionData(date: sectionDate, data: sectionData))
            }
        }
        viewModel.pubTransactionsSectionData = sectionArray
    }
    
    func loadInternationalSectionData(data: [InternationalTransactionsModel]){
        var dates = [String]()
        for item in data{
            let date = item.createdDate.convertDate()
            dates.append(date.toStringDate())
        }
        let uniqueDates = getUniqueValues(from: dates)
        var sectionArray = [IntTransactionSectionData]()
        for date in uniqueDates {
            var sectionData = [InternationalTransactionsModel]()
            var sectionDate = ""
            for item in data{
                    let convertedDate = item.createdDate.convertDate()
                    if date == convertedDate.toStringDate(){
                        sectionDate = convertedDate.toStringDate()
                        sectionData.append(item)
                    }
            }
            if !sectionData.isEmpty {
                sectionArray.append(IntTransactionSectionData(date: sectionDate, data: sectionData))
            }
        }
        viewModel.pubIntTransactionsSectionData = sectionArray
    }
    
    func getUniqueValues<T: Hashable>(from array: [T]) -> [T] {
        var uniqueValues = Set<T>()
        var result = [T]()
        
        for item in array {
            if !uniqueValues.contains(item) {
                uniqueValues.insert(item)
                result.append(item)
            }
        }
        
        return result
    }
    
    func transactionTotal(type: CreationType) -> String {
        var allTransactions: [TransactionsModel] = []
        if type == .transaction {
            let incomeTransactions = viewModel.allTransactions.filter({$0.transactionType == 1})
            let expenseTransactions = viewModel.allTransactions.filter({$0.transactionType == 0})
            var allIncomeAmount = incomeTransactions.compactMap({Double($0.amount)})
            let totalIncomeAmount = allIncomeAmount.reduce(0, +)
            var allExpenseAmount = expenseTransactions.compactMap({Double($0.amount)})
            let totalExpenseAmount = allExpenseAmount.reduce(0, +)
            return "$" + String(format: "%.2f", (totalIncomeAmount - totalExpenseAmount))
        } else {
            allTransactions = viewModel.allTransactions.filter({$0.transactionType == type.rawValue})
            let allAmount = allTransactions.compactMap({Double($0.amount)})
            let totalAmount = allAmount.reduce(0, +)
            return "$" + String(format: "%.2f", totalAmount)
        }
    }
    
    func internationalTransactionBaseTotal() -> String {
        var returnTotalBaseAmount = ""
        let allTransactions = viewModel.allIntTransactions
        let allBaseAmount = allTransactions.compactMap({Double($0.baseAmount)})
        let totalBaseAmount = allBaseAmount.reduce(0, +)
        returnTotalBaseAmount = "$" + String(format: "%.2f", totalBaseAmount)
        return returnTotalBaseAmount
    }
    
    func internationalTransactionConversionTotal() -> String {
        var returnTotalConvertedAmount = ""
        let allTransactions = viewModel.allIntTransactions
        let allConvertedAmount = allTransactions.compactMap({(Double($0.baseAmount) ?? 0.0) * (Double($0.conversionAmount) ?? 0.0)})
        let totalConvertedAmount = allConvertedAmount.reduce(0, +)
        returnTotalConvertedAmount = "₹" + String(format: "%.2f", totalConvertedAmount)
        return returnTotalConvertedAmount
    }
    
    func getPeopleIncluded(people: String) -> [PeopleModel] {
        let peopleIncluded = people.components(separatedBy: ",")
        let peopleArray = PeopleViewModel.shared.pubPeopleData
        let peopleIncludedInt = peopleIncluded.compactMap({Int64($0)})
        var returnArray: [PeopleModel] = []
        for item in peopleArray {
            if peopleIncludedInt.contains({item.id}()) {
                returnArray.append(item)
            }
        }
        return returnArray
    }
}
