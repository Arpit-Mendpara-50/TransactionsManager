//
//  Helper.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-02.
//

import Foundation
import SwiftUI

class Helper : ObservableObject {
    
    /// Prepare the shared instance
    public static var shared:Helper = {
        let model = Helper()
        model.getCurrency()
        return model
    }()
    
    @Published var keyboardHeight: CGFloat = 0.0
    @Published var currencyCode: String = "$"
    
    func setupKeyboardObserving() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation {
                    self.keyboardHeight = keyboardFrame.height
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            DispatchQueue.main.async {
                withAnimation {
                    self.keyboardHeight = 0.0
                }
            }
        }
    }
    
    func getCurrency() {
        let currencyId = UserDefaults.standard.integer(forKey: "SelectedCurrency")
        if let currency = CurrencyPickerModel.shared.currencies.first(where: {$0.id == currencyId}) {
            currencyCode = currency.code
        }
    }
    
}
