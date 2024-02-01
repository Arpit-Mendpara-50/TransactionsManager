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
    
    public func addTransaction(titleValue: String, amountValue: String, categoryValue: Int64, descriptionValue: String, transactionTypeValue: Int, peopleIncluded: [Int64], createdDateValue: String, updatedDateValue: String, completionHandler: (String, String) -> Void){
        let peopleIncludedString = CreationViewModel.shared.pubSelectedPeopleID.compactMap({String($0)}).joined(separator: ",")
        let messagePrefix = transactionTypeValue == 0 ? "Expense" : "Income"
        if let db = databaseManager.db, let transactions = databaseManager.transactions{
            do{
                try db.run(transactions.insert(databaseManager.title <- titleValue, databaseManager.amount <- amountValue, databaseManager.category <- categoryValue, databaseManager.description <- descriptionValue, databaseManager.transactionType <- transactionTypeValue, databaseManager.peopleIncluded <- peopleIncludedString,  databaseManager.createdDate <- createdDateValue, databaseManager.updatedDate <- updatedDateValue))
                completionHandler("Success", "\(messagePrefix) is added successfully")
            }catch{
                completionHandler("Failed", "Failed to add \(messagePrefix)")
                print(error.localizedDescription)
            }
        }
        for personId in peopleIncluded {
            let totalAmount = Double(amountValue) ?? 0.0
            let newAmout = totalAmount / Double(peopleIncluded.count)
            let person = PeopleManager.shared.getPersonById(id: personId)
            if let person = person {
                let finalAmount = (Double(person.amount) ?? 0.0) + newAmout
                PeopleManager.shared.updatePerson(personId: personId, nameValue: person.personName, imageValue: person.imagePath, amountValue: String(format: "%.2f", finalAmount), createdDateValue: person.createdDate, updatedDateValue: Date().ISO8601Format())
            }
        }
    }
    
}
