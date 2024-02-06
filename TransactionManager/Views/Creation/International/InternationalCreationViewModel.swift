//
//  InternationalCreationViewModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-26.
//

import Foundation

class InternationalCreationViewModel : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:InternationalCreationViewModel = {
        let model = InternationalCreationViewModel()
        return model
    }()
    
    @Published var pubTitleString = ""
    @Published var pubBaseAmountString = ""
    @Published var pubConversionAmountString = ""
    @Published var pubDescriptionString = ""
    @Published var pubSelectedDate = Date()
    @Published var pubSelectedBaseCurrency: Currency = Currency(id: 2, name: "CAD", icon: "ic_canada", code: "$")
    @Published var pubSelectedConversionCurrency: Currency = Currency(id: 1, name: "INR", icon: "ic_india", code: "₹")
//    @Published var pubShowIntListView = false
    
    
    public func clearFormData(){
        self.pubTitleString = ""
        self.pubBaseAmountString = ""
        self.pubConversionAmountString = ""
        self.pubDescriptionString = ""
        self.pubSelectedDate = Date()
    }
}
