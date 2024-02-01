//
//  SliderMessageManager.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-31.
//

import Foundation

class SliderMessageManager: ObservableObject {
    
    @Published var pubShowSliderMessageView = false
    
    @Published var pubSliderTitle = ""
    @Published var pubSliderMessage = ""
    
    public static var shared: SliderMessageManager = {
        let mgr = SliderMessageManager()
        return mgr
    }()
    
}
