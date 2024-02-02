//
//  SettingsManager.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-01.
//

import Foundation

class SettingsManager : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:SettingsManager = {
        let model = SettingsManager()
        return model
    }()
    
}
