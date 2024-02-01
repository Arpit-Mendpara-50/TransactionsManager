//
//  CreationViewModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-04-21.
//

import SwiftUI

enum CreationType: Int{
    case expense = 0
    case income = 1
    case transaction = 2
}

class CreationViewModel : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:CreationViewModel = {
        let model = CreationViewModel()
        return model
    }()
    
    @Published var pubPresentMapPicker = false
    @Published var pubLastUpdatedTimestamp = Date().timeIntervalSince1970
    @Published var pubTitleString = ""
    @Published var pubAmountString = ""
    @Published var pubDescriptionString = ""
    @Published var pubSelectedDate = Date()
    @Published var pubSelectedCategory: CategoryModel?
    @Published var pubCategoryData: [CategoryModel] = []
    @Published var pubCurrentType: CreationType = .income
    @Published var pubSelectedPeopleID: [Int64] = []
    
    public func clearFormData(){
        self.pubSelectedPeopleID.removeAll()
        self.pubTitleString = ""
        self.pubAmountString = ""
        self.pubSelectedCategory = nil
        self.pubDescriptionString = ""
        self.pubSelectedDate = Date()
    }
    
    func getTypeValue() -> (Int,Int) {
        if self.pubCurrentType == .income{
            return (1,2)
        }else if self.pubCurrentType == .expense{
            return (0,2)
        }else{
            return (0,0)
        }
    }
    
    func getTitle() -> String {
        if self.pubCurrentType == .income{
            return "Income"
        }else if self.pubCurrentType == .expense{
            return "Expense"
        }else{
            return "Transaction"
        }
    }
    
}
