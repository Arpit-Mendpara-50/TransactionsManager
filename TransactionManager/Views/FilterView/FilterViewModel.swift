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
        let model = FilterViewModel(
        )
        let (month, year) = model.currentMonthAndYear()
//        model.getPreSelectedCurrency()
        model.pubSelectedMonth = month
        model.pubSelectedYear = year
        return model
    }()
    
    @Published var pubShowFilterView: Bool = false
    @Published var pubSelectedMonth: String = ""
    @Published var pubSelectedYear: String = ""
    @Published var pubSelectedCategory: CategoryModel?
    @Published var pubSelectedRange: Double = 0.0
//    @Published var pubSelectedCurrency: Currency?
    @Published var pubLastUpdated = Date().timeIntervalSince1970
    
    
    func currentMonthAndYear() -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM,yyyy"
        let date = dateFormatter.string(from: Date())
        let components = date.components(separatedBy: ",")
        if components.count == 2 {
            return (components[0], components[1])
        }
        return ("", "")
    }
    
    func applyFilter(data: [TransactionsModel], filterMonthAndYear: String, selectedCategory: CategoryModel?, amountRange: Double, currency: Currency?) -> [TransactionsModel]{
        var returnData = data
        if !filterMonthAndYear.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            
            let filterDateFormatter = DateFormatter()
            filterDateFormatter.dateFormat = "MMMM yyyy"
            
            let filterMonthAndYearData = data.filter { item in
                if let date = dateFormatter.date(from: item.createdDate),
                   filterDateFormatter.string(from: date) == filterMonthAndYear {
                    return true
                }
                return false
            }
            returnData = filterMonthAndYearData
        }
        
        if let category = selectedCategory {
            let categoryFilter = returnData.filter({$0.category?.id == category.id})
            returnData = categoryFilter
        }
        
        if amountRange > 0.0 {
            let rangeFilter = returnData.filter({Double($0.amount) ?? 0.0 <= amountRange})
            returnData = rangeFilter
        }
        if let currency = currency {
            let currencyFilter = returnData.filter({$0.currencyType == currency.id})
            returnData = currencyFilter
        }
        return returnData
    }
    
    func getUpperRangeForSlider() -> Double {
        let allTransactions = TransactionsViewModel.shared.allTransactions.map({Double($0.amount)})
        var largestNumber = 10.0
        
        for number in allTransactions {
            if let number = number, number > largestNumber {
                largestNumber = number
            }
        }
        
        return roundUpToNearestMultiple(of: 100, value: largestNumber)
    }
    
    func roundUpToNearestMultiple(of base: Double, value: Double) -> Double {
        let roundedValue = base * ceil(value / base)
        return roundedValue
    }
    
    func isShowClearButton(selectedMonth: String, selectedYear: String, selectedCategory: CategoryModel?, selectedRange: Double) -> Bool {
        let (month, year) = currentMonthAndYear()
        if selectedMonth != month || selectedYear != year || (selectedCategory != nil) || selectedRange > 0.0 {
            return true
        }
        return false
    }
    
//    func getPreSelectedCurrency() {
//        guard let currency = currencyPickerModel.pubSelectedCurrency else{
//            pubSelectedCurrency = CurrencyPickerModel.shared.pubSelectedCurrency
//            return
//        }
//    }
}
