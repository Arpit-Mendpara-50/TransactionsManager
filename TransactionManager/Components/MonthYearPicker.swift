//
//  MonthYearPicker.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-02.
//

import SwiftUI

struct MonthYearPicker: View {
    @Binding var selectedMonth: String
    @Binding var selectedYear: Int
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    let years = Array(1990...2030).map { String($0) }
    
    var body: some View {
        HStack(spacing: 0){
            Spacer()
            Picker("Month", selection: $selectedMonth) {
                ForEach(0..<months.count) { index in
                    Text(self.months[index]).tag(self.months[index])
                }
            }
            .pickerStyle(.menu)
            
            Picker("Year", selection: $selectedYear) {
                ForEach(0..<years.count) { index in
                    Text(self.years[index]).tag(self.years[index])
                }
            }
            .pickerStyle(.menu)
        }
    }
}
