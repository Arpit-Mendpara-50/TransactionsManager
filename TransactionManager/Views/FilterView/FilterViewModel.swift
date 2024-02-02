//
//  FilterViewModel.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-02.
//

import Foundation

class FilterViewModel : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:FilterViewModel = {
        let model = FilterViewModel()
        return model
    }()
    
    @Published var pubSelectedMonth: String = "January"
    @Published var pubSelectedYear: String = "2024"
    @Published var pubSelectedCategory: CategoryModel?
}
