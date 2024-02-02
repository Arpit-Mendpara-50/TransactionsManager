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
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .resizable()
                .background(Color.white)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 5)
            ScrollView(.horizontal){
                HStack(spacing: 10){
                    if !viewModel.pubSelectedMonth.isEmpty {
                        Text(viewModel.pubSelectedMonth)
                            .bold()
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                    
                    if !viewModel.pubSelectedYear.isEmpty {
                        Text(viewModel.pubSelectedYear)
                            .bold()
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                    
                        
                    
                    if let category = viewModel.pubSelectedCategory {
                        HStack {
                            Image(category.icon)
                                .resizable()
                                .background(Color.white)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                            Text(category.title)
                                .bold()
                                .foregroundStyle(Color.white)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.blue)
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
