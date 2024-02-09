//
//  PeopleManager.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-26.
//

import Foundation
import SQLite

class PeopleManager: ObservableObject {
    
    public static var shared: PeopleManager = {
        let mgr = PeopleManager()
        return mgr
    }()
    
    var currencyPickerModel = CurrencyPickerModel.shared
    var transactionsViewModel = TransactionsViewModel.shared
    var databaseManager = DatabaseManager.shared
    var viewModel = PeopleViewModel.shared
    
    public func addPerson(nameValue: String, imageValue: String, amountValue: String, createdDateValue: String, updatedDateValue: String, completionHandler: @escaping (String, String) -> Void){
        if let db = databaseManager.db, let people = databaseManager.people{
            do{
                try db.run(people.insert(databaseManager.personName <- nameValue, databaseManager.personImage <- imageValue, databaseManager.personAmount <- amountValue, databaseManager.personCreatedDate <- createdDateValue, databaseManager.personUpdatedDate <- updatedDateValue))
                DispatchQueue.main.async {
                    completionHandler("Success", "\(nameValue) is added to people")
                }
            }catch{
                completionHandler("Failed", "Failed to add \(nameValue) to people")
                print(error.localizedDescription)
            }
        }
    }
    
    public func updatePerson(personId: Int64, nameValue: String, imageValue: String, amountValue: String, createdDateValue: String, updatedDateValue: String){
        if let db = databaseManager.db, let people = databaseManager.people{
            do{
                let person: Table = people.filter(databaseManager.personId == personId)
                try db.run(person.update(databaseManager.personName <- nameValue, databaseManager.personImage <- imageValue, databaseManager.personAmount <- amountValue, databaseManager.personCreatedDate <- createdDateValue, databaseManager.personUpdatedDate <- updatedDateValue))
                DispatchQueue.main.async {
                    self.getPeopleList()
                }
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    public func getPeopleList() {
        viewModel.pubIsPeopleLoading = true
        var peopleArray: [PeopleModel] = []
        if let db = databaseManager.db, var people = databaseManager.people{
            people = people.order(databaseManager.transactionId.asc)
            do{
                for person in try db.prepare(people){
                    let peopleData: PeopleModel = PeopleModel()
                    peopleData.id = person[databaseManager.personId]
                    peopleData.personName = person[databaseManager.personName]
                    peopleData.imagePath = person[databaseManager.personImage]
                    peopleData.amount = person[databaseManager.personAmount]
                    peopleData.createdDate = person[databaseManager.personCreatedDate]
                    peopleData.updatedDate = person[databaseManager.personUpdatedDate]
                    peopleArray.append(peopleData)
                }
            } catch{
                print(error.localizedDescription)
            }
            viewModel.pubPeopleData = peopleArray
            if !peopleArray.isEmpty {
                print("people amount: \(peopleArray[0].amount)")
            }
            viewModel.pubIsPeopleLoading = false
        }else{
            print("Something went wrong")
            viewModel.pubIsPeopleLoading = false
        }
    }
    
    public func getPersonAmount(personId: Int64) -> String{
        var returnAmount = 0.0
        let currency = currencyPickerModel.pubSelectedCurrency.id
        let allTransactions = transactionsViewModel.allTransactions
        for transaction in allTransactions {
            let peopleIncluded = transactionsViewModel.getPeopleIncluded(people: transaction.peopleIncluded)
            if peopleIncluded.contains(where: {$0.id == personId}) {
                if transaction.currencyType == currency {
                    returnAmount += Double(transaction.amount) ?? 0.0
                }
            }
        }
        return String(format: "%.2f", returnAmount)
    }
    
}
