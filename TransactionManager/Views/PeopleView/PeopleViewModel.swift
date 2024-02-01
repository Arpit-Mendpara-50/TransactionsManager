//
//  PeopleViewModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-26.
//

import Foundation

class PeopleViewModel : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:PeopleViewModel = {
        let model = PeopleViewModel()
        return model
    }()
    
    @Published var pubPeopleData: [PeopleModel] = []
    @Published var pubSelectedPeopleData: [PeopleModel] = []
    @Published var pubIsPeopleLoading: Bool = true
    @Published var pubLastUpdated: TimeInterval = Date().timeIntervalSince1970
    @Published var pubShowPeopleCreationView = false
    public var personName: String = ""
    
    
    public func clearPeopleForms() {
        personName = ""
        ImagePickerManager.shared.selectedImage = nil
        
    }
}
