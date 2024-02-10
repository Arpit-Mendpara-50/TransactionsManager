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
    
    func updatePeopleData() {
        let currencies = currencyPickerModel.currencies
        let allTransactions = TransactionsViewModel.shared.unFilterdData
        for pubPeopleDatum in pubPeopleData {
            var finalAmountArray: [String] = []
            for currency in currencies {
                var totalAmount = 0.0
                for transaction in allTransactions {
                    let peopleIncludedString = transaction.peopleIncluded
                    let peopleIncluded = TransactionsViewModel.shared.getPeopleIncluded(people: peopleIncludedString)
                    if transaction.currencyType == currency.id {
                        if peopleIncluded.contains(where: {$0.id == pubPeopleDatum.id}) {
                            let amount = Double(transaction.amount) ?? 0.0
                            let finalAmount = amount / Double(peopleIncluded.count)
                            totalAmount += finalAmount
                        }
                    }
                }
                finalAmountArray.append(currency.name + String(format: "%.2f", totalAmount))
                PeopleManager.shared.updatePerson(personId: pubPeopleDatum.id, nameValue: pubPeopleDatum.personName, imageValue: pubPeopleDatum.imagePath, amountValue: finalAmountArray.joined(separator: ","), createdDateValue: pubPeopleDatum.createdDate, updatedDateValue: Date().ISO8601Format())
            }
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
