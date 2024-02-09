//
//  PeopleViewModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-26.
//

import Foundation
import SwiftUI

class PeopleViewModel : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:PeopleViewModel = {
        let model = PeopleViewModel()
        return model
    }()
    
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    @ObservedObject var imagePickerManager = ImagePickerManager.shared
    
    @Published var pubPeopleData: [PeopleModel] = []
    @Published var pubSelectedPeopleData: [PeopleModel] = []
    @Published var pubIsPeopleLoading: Bool = true
    @Published var pubLastUpdated: TimeInterval = Date().timeIntervalSince1970
    @Published var pubShowPeopleCreationView = false
    public var personName: String = ""
    
    
    public func clearPeopleForms() {
        personName = ""
        imagePickerManager.selectedImage = nil
        
    }
    
    func checkValidInputs() -> String{
        if personName.isEmpty {
            return "Please enter person name"
        }
        guard imagePickerManager.selectedImage != nil else{
            return "Please select photo for person"
        }
        return ""
    }
    
    func updatePeopleData(transactionCurrencyType: Int) {
        let currency = currencyPickerModel.getCurrencyById(id: transactionCurrencyType)
        let people = PeopleViewModel.shared.pubPeopleData
        let allTransactions = TransactionsViewModel.shared.allTransactions
        for pubPeopleDatum in pubPeopleData {
            var preAmountArray = pubPeopleDatum.amount.components(separatedBy: ",")
            var totalAmount = 0.0
            for transaction in allTransactions {
                let peopleIncludedString = transaction.peopleIncluded
                let peopleIncluded = TransactionsViewModel.shared.getPeopleIncluded(people: peopleIncludedString)
                if peopleIncluded.contains(where: {$0.id == pubPeopleDatum.id}) {
                    let amount = Double(transaction.amount) ?? 0.0
                    let finalAmount = amount / Double(peopleIncluded.count)
                    totalAmount += finalAmount
                }
            }
            
            if pubPeopleDatum.amount.isEmpty || pubPeopleDatum.amount == "0.0" {
                preAmountArray.append(currency.name + String(format: "%.2f", totalAmount))
            } else {
                let preAmountString = pubPeopleDatum.amount
                let preAmount = preAmountArray.first(where: {$0.contains(currency.name)})
                if let preAmount = preAmount {
                    let appendStringAmount = currency.name + String(format: "%.2f", totalAmount)
                    preAmountArray = preAmountArray.filter({$0 != preAmount})
                    preAmountArray.append(appendStringAmount)
                } else {
                    let appendStringAmount = currency.name + String(format: "%.2f", totalAmount)
                    preAmountArray.append(appendStringAmount)
                }
            }
            
            PeopleManager.shared.updatePerson(personId: pubPeopleDatum.id, nameValue: pubPeopleDatum.personName, imageValue: pubPeopleDatum.imagePath, amountValue: preAmountArray.joined(separator: ","), createdDateValue: pubPeopleDatum.createdDate, updatedDateValue: Date().ISO8601Format())
        }
    }
    
    public func getPersonById(id: Int64) -> PeopleModel? {
        let people = self.pubPeopleData
        for item in people {
            if item.id == id {
                return item
            }
        }
        return nil
    }
    
    public func extractPersonAmount(amountString: String) -> String{
        let currency = currencyPickerModel.getCurrencyById(id: currencyPickerModel.pubSelectedCurrency.id)
        let amountArray = amountString.components(separatedBy: ",")
        let filteredAmount = amountArray.first(where: {$0.contains(currency.name)})
        if let filteredAmount = filteredAmount {
            return filteredAmount.replacingOccurrences(of: currency.name, with: "")
        }
        return "0.0"
    }
}
