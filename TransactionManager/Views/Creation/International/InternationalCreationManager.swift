//
//  InternationalCreationManager.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-26.
//

import Foundation
import SQLite
import SwiftUI

class InternationalCreationManager : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:InternationalCreationManager = {
        let model = InternationalCreationManager()
        return model
    }()
    
    @ObservedObject var databaseManager = DatabaseManager.shared
    
    public func addIntTransaction(titleValue: String, baseAmountValue: String, conversionAmountValue: String, descriptionValue: String, createdDateValue: String, updatedDateValue: String){
        if let db = databaseManager.db, let transactions = databaseManager.internationalTransactions{
            do{
                try db.run(transactions.insert(databaseManager.intTransactionTitle <- titleValue, databaseManager.intTransactionBaseamount <- baseAmountValue, databaseManager.intTransactionConversionAmount <- conversionAmountValue, databaseManager.intTransactionDescription <- descriptionValue,  databaseManager.intTransactionCreatedDate <- createdDateValue, databaseManager.intTransactionUpdatedDate <- updatedDateValue))
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

