//
//  MonthYearPicker.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-02.
//

import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

struct MonthYearPicker: View {
    @Binding var selectedMonth: String
    @Binding var selectedYear: String
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    let years = Array(2020...2030).map { String($0) }
    
    var body: some View {
        HStack(spacing: 10){
            HStack {
                Menu {
                    Picker(selection: $selectedMonth) {
                        ForEach(0..<months.count) { value in
                            Text(months[value])
                                .tag(months[value])
                        }
                    } label: {}
                } label: {
                    HStack {
                        Text(String(selectedMonth))
                            .font(.system(size: 20, weight: .semibold))
                        Image(systemName: "chevron.up.chevron.down")
                            .bold()
                    }.foregroundStyle(Color.TextColor)
                }
            }
            .padding(10)
            .background(Color.SwitchBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
            HStack {
                Menu {
                    Picker(selection: $selectedYear) {
                        ForEach(0..<years.count) { value in
                            Text(years[value])
                                .tag(years[value])
                        }
                    } label: {}
                } label: {
                    HStack {
                        Text(String(selectedYear))
                            .font(.system(size: 20, weight: .semibold))
                        Image(systemName: "chevron.up.chevron.down")
                            .bold()
                    }.foregroundStyle(Color.TextColor)
                }
            }
            .padding(10)
            .background(Color.SwitchBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
            Spacer()
        }
    }
}

#Preview {
    MonthYearPicker(selectedMonth: .constant("January"), selectedYear: .constant("2004"))
}
