//
//  CurrencyPickerView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-04.
//

import SwiftUI

struct CurrencyView: View {
    @ObservedObject var viewModel = CurrencyPickerModel.shared
    let currency: Currency
    let isSelectable: Bool
    let selectedCurrency: Currency
    var body: some View {
        VStack {
            ZStack {
                VStack(spacing: 5){
                    if isSelectable {
                        Spacer().frame(height: 10)
                    }
                    Image(currency.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Text(currency.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                if isSelectable && selectedCurrency == currency{
                    VStack {
                        HStack {
                            Spacer()
                            HStack {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .renderingMode(.template)
                                    .bold()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(Color.white)
                                    .offset(x: -2, y: 2)
                            }
                            .frame(width: 30, height: 30)
                            .background(Color.green)
                            .clipShape(Circle())
                            .offset(x: 7, y: -7)
                        }
                        Spacer()
                    }
                }
            }
        }
        .frame(width: 70, height: 80)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}

struct CurrencyPickerView: View {
    
    @ObservedObject var viewModel = CurrencyPickerModel.shared
    let showSelectedView: Bool
    let selectedCurrency: Currency
    var onSelect: ((Currency) -> Void)? = nil
    
    var body: some View {
        HStack {
            if showSelectedView {
                CurrencyView(currency: selectedCurrency, isSelectable: false, selectedCurrency: selectedCurrency)
                    .padding(.leading, 5)
                VLine()
                    .padding(.leading, 5)
            }
            ScrollView(.horizontal) {
                HStack(spacing: 10){
                    ForEach(0..<viewModel.currencies.count, id: \.self) { index in
                        Button(action: {
//                            if showSelectedView {
//                                viewModel.pubSelectedCurrency = viewModel.currencies[index]
//                                UserDefaults.standard.setValue(viewModel.pubSelectedCurrency.id, forKey: "SelectedCurrency")
//                                UserDefaults.standard.synchronize()
//                            } else {
//                                viewModel.pubSelectedCurrencyForTransaction = viewModel.currencies[index]
//                                onSelect?()
//                            }
                            onSelect?(viewModel.currencies[index])
                        }, label: {
                            CurrencyView(currency: viewModel.currencies[index], isSelectable: showSelectedView, selectedCurrency: selectedCurrency)
                                .padding(.vertical)
                        })
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .frame(height: 90)
        .background(Color.white)
    }
}

