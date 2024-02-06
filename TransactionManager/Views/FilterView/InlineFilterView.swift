//
//  InlineFilterView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-02.
//

import SwiftUI

struct InlineFilterView: View {
    
    @ObservedObject var viewModel = FilterViewModel.shared
    
    var body: some View {
        HStack(spacing: 0){
            Button(action: {
                viewModel.pubShowFilterView = true
            }, label: {
                HStack {
                    Image("ic_filter")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.black)
                }
                .frame(width: 45, height: 45)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 5)
            })
            ScrollView(.horizontal){
                HStack(spacing: 10){
                    if !viewModel.pubSelectedMonth.isEmpty {
                        Text(viewModel.pubSelectedMonth)
                            .bold()
                            .padding(13)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                    
                    if !String(viewModel.pubSelectedYear).isEmpty {
                        Text("\(viewModel.pubSelectedYear)")
                            .bold()
                            .padding(13)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                    
                    if viewModel.pubSelectedRange > 0 {
                        Text("< $\(Int(viewModel.pubSelectedRange))")
                            .bold()
                            .padding(13)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
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
                    
                    if let currency = viewModel.pubSelectedCurrency {
                        HStack {
                            Image(currency.icon)
                                .resizable()
                                .frame(width: 32, height: 32)
                            Text(currency.name)
                                .bold()
                                .foregroundStyle(Color.black)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                    }
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
