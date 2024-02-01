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
    
    var databaseManager = DatabaseManager.shared
    var viewModel = PeopleViewModel.shared
    
    public func addPerson(nameValue: String, imageValue: String, amountValue: String, createdDateValue: String, updatedDateValue: String){
        if let db = databaseManager.db, let people = databaseManager.people{
            do{
                try db.run(people.insert(databaseManager.personName <- nameValue, databaseManager.personImage <- imageValue, databaseManager.personAmount <- amountValue, databaseManager.personCreatedDate <- createdDateValue, databaseManager.personUpdatedDate <- updatedDateValue))
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    public func updatePerson(personId: Int64, nameValue: String, imageValue: String, amountValue: String, createdDateValue: String, updatedDateValue: String){
        if let db = databaseManager.db, let people = databaseManager.people{
            do{
                let person: Table = people.filter(databaseManager.personId == personId)
                try db.run(person.update(databaseManager.personName <- nameValue, databaseManager.personImage <- imageValue, databaseManager.personAmount <- amountValue, databaseManager.personCreatedDate <- createdDateValue, databaseManager.personUpdatedDate <- updatedDateValue))
                
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    public func getPeopleList() {
        var peopleArray: [PeopleModel] = []
        if let db = databaseManager.db, var people = databaseManager.people{
            people = people.order(databaseManager.id.asc)
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
            viewModel.pubIsPeopleLoading = false
        }else{
            print("Something went wrong")
            viewModel.pubIsPeopleLoading = false
        }
    }
    
    public func getPersonById(id: Int64) -> PeopleModel? {
        print("current person id: \(id)")
        let people = viewModel.pubPeopleData
        for item in people {
            if item.id == id {
                return item
            }
        }
        return nil
    }
    
//    public func getPersonAmount(id: Int64) -> String {
//        var returnAmount = 0.0
//        let transactions = TransactionsViewModel.shared.pubTransactionsData
//        for item in transactions {
//            let people = TransactionsManager.shared.getPeopleIncluded(people: item.peopleIncluded)
//            if !people.isEmpty {
//                if people.contains(where: {$0.id == id}) {
//                    returnAmount += Double(item.amount) ?? 0.0
//                }
//            }
//        }
//        return "$" + String(format: "%.2f", returnAmount)
//    }
    
}
