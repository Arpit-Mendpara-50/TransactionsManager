//
//  CreationManager.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-04-23.
//

import Foundation
import SwiftUI
import SQLite

class CreationManager: ObservableObject {
    
    public static var shared: CreationManager = {
        let mgr = CreationManager()
        return mgr
    }()
    
    
    enum CreationType: Int{
        case expense = 0
        case income = 1
        case transaction = 2
    }
    @ObservedObject var databaseManager = DatabaseManager.shared
    
    public func addTransaction(titleValue: String, amountValue: String, categoryValue: Int64, descriptionValue: String, transactionTypeValue: Int, currencyTypeValue: Int, peopleIncluded: [Int64], createdDateValue: String, updatedDateValue: String, completionHandler: @escaping (String, String) -> Void){
        let peopleIncludedString = CreationViewModel.shared.pubSelectedPeopleID.compactMap({String($0)}).joined(separator: ",")
        let messagePrefix = transactionTypeValue == 0 ? "Expense" : "Income"
        if let db = databaseManager.db, let transactions = databaseManager.transactions{
            do{
                try db.run(transactions.insert(databaseManager.transactionTitle <- titleValue, databaseManager.transactionAmount <- amountValue, databaseManager.transactionCategory <- categoryValue, databaseManager.transactionDescription <- descriptionValue, databaseManager.transactionType <- transactionTypeValue, databaseManager.peopleIncluded <- peopleIncludedString, databaseManager.transactionCurrencyType <- currencyTypeValue,  databaseManager.transactionCreatedDate <- createdDateValue, databaseManager.transactionUpdatedDate <- updatedDateValue))
                DispatchQueue.main.async {
                    completionHandler("Success", "\(messagePrefix) is added successfully")
                    PeopleViewModel.shared.updatePeopleData(transactionCurrencyType: currencyTypeValue)
                }
            }catch{
                completionHandler("Failed", "Failed to add \(messagePrefix)")
                print(error.localizedDescription)
            }
        }
    }
    
}
