//
//  InlineFilterView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-02.
//

import SwiftUI

struct InlineFilterView: View {
    
    @ObservedObject var viewModel = FilterViewModel.shared
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    var showFilterButton: Bool = true
    
    var body: some View {
        HStack(spacing: 0){
            if showFilterButton {
                Button(action: {
                    viewModel.pubShowFilterView = true
                }, label: {
                    HStack {
                        Image("ic_filter")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.TextColor)
                    }
                    .frame(width: 45, height: 45)
                    .background(Color.SwitchBackgroundColor)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                })
            }
            ScrollView(.horizontal){
                HStack(spacing: 10){
                    if !viewModel.pubSelectedMonth.isEmpty {
                        Text(viewModel.pubSelectedMonth)
                            .bold()
                            .padding(13)
                            .background(Color.SwitchBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                            .foregroundStyle(Color.TextColor)
                    }
                    
                    if !String(viewModel.pubSelectedYear).isEmpty {
                        Text("\(viewModel.pubSelectedYear)")
                            .bold()
                            .padding(13)
                            .background(Color.SwitchBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                            .foregroundStyle(Color.TextColor)
                    }
                    
                    if viewModel.pubSelectedRange > 0 {
                        Text("< $\(Int(viewModel.pubSelectedRange))")
                            .bold()
                            .padding(13)
                            .background(Color.SwitchBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                            .foregroundStyle(Color.TextColor)
                    }
                    
                    if let category = viewModel.pubSelectedCategory {
                        HStack {
                            Image(category.icon)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 32, height: 32)
                                .foregroundStyle(Color.white)
                            Text(category.title)
                                .bold()
                                .foregroundStyle(Color.white)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(Color(UIColor(named: category.color) ?? UIColor.black))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                    }
                    
                    HStack {
                        Image(currencyPickerModel.pubSelectedCurrency.icon)
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text(currencyPickerModel.pubSelectedCurrency.name)
                            .bold()
                            .foregroundStyle(Color.TextColor)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(Color.SwitchBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                }
                .padding()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    InlineFilterView()
}
