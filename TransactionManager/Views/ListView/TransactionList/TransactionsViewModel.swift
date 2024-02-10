//
//  TransactionsViewModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-05-29.
//

import Foundation
import SwiftUI

class TransactionsViewModel : ObservableObject {
    
    public static var shared:TransactionsViewModel = {
        let model = TransactionsViewModel()
        return model
    }()
    
    @ObservedObject var filterViewModel = FilterViewModel.shared
    @ObservedObject var helper = Helper.shared
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    @ObservedObject var creationViewModel = CreationViewModel.shared
    
    @Published var pubTransactionsData: [TransactionsModel] = []
    @Published var pubTransactionsSectionData: [TransactionSectionData] = []
    @Published var pubPreviousTransactionDate: Date?
    @Published var pubIsTransactionsLoading: Bool = true
    @Published var pubCurrentListType: CreationType = .income
    
    @Published var allTransactions: [TransactionsModel] = []
    @Published var unFilterdData: [TransactionsModel] = []
    
    @Published var pubIsIntTransactionsLoading: Bool = true
    @Published var allIntTransactions: [InternationalTransactionsModel] = []
    @Published var pubIntTransactionsSectionData: [IntTransactionSectionData] = []
    @Published var pubShowListView = false
    @Published var pubShowIntListView = false
    @Published var pubLastUpdated = Date().timeIntervalSince1970
    
    func getTitle() -> String {
        if self.pubCurrentListType == .income{
            return "Income"
        }else if self.pubCurrentListType == .expense{
            return "Expenses"
        }else{
            return "Transactions"
        }
    }
    
    func getTopColor() -> Color {
//        if self.pubCurrentListType == .income{
//            return Color.green
//        }else if self.pubCurrentListType == .expense{
//            return Color.red
//        }else{
//            return Color.gray
//        }
        return Color.DarkBlue
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
                if item.transactionType == self.pubCurrentListType.rawValue ||  self.pubCurrentListType.rawValue == 2{
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
        self.pubTransactionsSectionData = sectionArray
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
        self.pubIntTransactionsSectionData = sectionArray
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
            let incomeTransactions = self.allTransactions.filter({$0.transactionType == 1})
            let expenseTransactions = self.allTransactions.filter({$0.transactionType == 0})
            let allIncomeAmount = incomeTransactions.compactMap({Double($0.amount)})
            let totalIncomeAmount = allIncomeAmount.reduce(0, +)
            let allExpenseAmount = expenseTransactions.compactMap({Double($0.amount)})
            let totalExpenseAmount = allExpenseAmount.reduce(0, +)
            return "\(helper.currencyCode)" + String(format: "%.2f", (totalIncomeAmount - totalExpenseAmount))
        } else {
            allTransactions = self.allTransactions.filter({$0.transactionType == type.rawValue})
            let allAmount = allTransactions.compactMap({Double($0.amount)})
            let totalAmount = allAmount.reduce(0, +)
            return "\(helper.currencyCode)" + String(format: "%.2f", totalAmount)
        }
    }
    
    func internationalTransactionBaseTotal() -> String {
        var returnTotalBaseAmount = ""
        let allTransactions = self.allIntTransactions
        let allBaseAmount = allTransactions.compactMap({Double($0.baseAmount)})
        let totalBaseAmount = allBaseAmount.reduce(0, +)
        returnTotalBaseAmount = String(format: "%.2f", totalBaseAmount)
        return returnTotalBaseAmount
    }
    
    func internationalTransactionConversionTotal() -> String {
        var returnTotalConvertedAmount = ""
        let allTransactions = self.allIntTransactions
        let allConvertedAmount = allTransactions.compactMap({(Double($0.baseAmount) ?? 0.0) * (Double($0.conversionAmount) ?? 0.0)})
        let totalConvertedAmount = allConvertedAmount.reduce(0, +)
        returnTotalConvertedAmount = String(format: "%.2f", totalConvertedAmount)
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
    
    func getDividedAmount(amount: String, peopleIncluded: String) -> String{
        let people = self.getPeopleIncluded(people: peopleIncluded)
        let doubleAmount = Double(amount) ?? 0.0
        let dividedAmount = doubleAmount / Double(people.count)
        return String(format: "%.2f", dividedAmount)
    }
    
    func filterIntTransactionsData(){
    }
    
    func filterTransactionsData() {
        let monthAndYear = "\(filterViewModel.pubSelectedMonth) \(filterViewModel.pubSelectedYear)"
        let filteredData = filterViewModel.applyFilter(data: allTransactions, filterMonthAndYear: monthAndYear, selectedCategory: filterViewModel.pubSelectedCategory, amountRange: filterViewModel.pubSelectedRange, currency: currencyPickerModel.pubSelectedCurrency)
        self.loadSectionData(data: filteredData)
    }
    
    func getIntTransactionsFlags() -> ([String], [String]) {
        var returnBaseFlags: [String] = []
        var returnConversionFlags: [String] = []
        let baseCurrencies = self.allIntTransactions.map({$0.baseCurrencyType})
        let conversionCurrencies = self.allIntTransactions.map({$0.conversionCurrencyType})
        let allcurrencies = currencyPickerModel.currencies
        for item in allcurrencies {
            if baseCurrencies.contains(item.id) {
                if !returnBaseFlags.contains(item.icon) {
                    returnBaseFlags.append(item.icon)
                }
            }
            if conversionCurrencies.contains(item.id) {
                if !returnConversionFlags.contains(item.icon) {
                    returnConversionFlags.append(item.icon)
                }
            }
        }
        return (returnBaseFlags, returnConversionFlags)
    }
    
    func populateExpenseData(id: Int64, title: String, amount: String, description: String, category: CategoryModel?, createdDate: String, peopleIncluded: String) {
        creationViewModel.pubTransactionId = id
        creationViewModel.pubCurrentType = self.pubCurrentListType
        creationViewModel.pubTitleString = title
        creationViewModel.pubAmountString = amount
        creationViewModel.pubDescriptionString = description
        creationViewModel.pubSelectedCategory = category
        creationViewModel.pubSelectedDate = creationViewModel.convertStringToDate(stringDate: createdDate)
        creationViewModel.pubSelectedPeopleID = creationViewModel.convertStringToPeople(peopleString: peopleIncluded)
    }
    
    func populateIncomeData(id: Int64, title: String, amount: String, description: String, category: CategoryModel?, createdDate: String) {
        creationViewModel.pubTransactionId = id
        creationViewModel.pubCurrentType = self.pubCurrentListType
        creationViewModel.pubTitleString = title
        creationViewModel.pubAmountString = amount
        creationViewModel.pubDescriptionString = description
        creationViewModel.pubSelectedCategory = category
        creationViewModel.pubSelectedDate = creationViewModel.convertStringToDate(stringDate: createdDate)
    }
    
}
