//
//  SettingsViewModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-01.
//

import Foundation

class SettingsViewModel : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:SettingsViewModel = {
        let model = SettingsViewModel()
        return model
    }()
    
    @Published var pubShowSettingsView = false
}
