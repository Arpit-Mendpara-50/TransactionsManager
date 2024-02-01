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
    
    
    public func clearFormData(){
        self.pubTitleString = ""
        self.pubBaseAmountString = ""
        self.pubConversionAmountString = ""
        self.pubDescriptionString = ""
        self.pubSelectedDate = Date()
    }
}
