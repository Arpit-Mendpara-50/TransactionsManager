//
//  IntTransactionRowView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-26.
//

import Foundation
import SwiftUI

struct IntTransactionSectionView: View {
    var dateText: String
    var transactionData: [InternationalTransactionsModel]
    
    var body: some View {
        VStack{
            HStack{
                Text(dateText).bold().padding(.leading, 10)
                Line(padding: 30)
            }.padding(.bottom)
            ForEach(transactionData){ item in
                IntTransactionRowView(transactionData: item)
            }
        }
    }
}

struct IntTransactionRowView: View {
    @ObservedObject var helper = Helper.shared
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    var transactionData: InternationalTransactionsModel
    
    var body: some View {
        VStack{
            HStack {
                VStack(spacing: 0){
                    Image(currencyPickerModel.getCurrencyById(id: transactionData.baseCurrencyType).icon)
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text(currencyPickerModel.getCurrencyById(id: transactionData.baseCurrencyType).name)
                        .font(.system(size: 10, weight: .bold)).padding(.bottom, 5)
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .bold()
                    Image(currencyPickerModel.getCurrencyById(id: transactionData.conversionCurrencyType).icon)
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text(currencyPickerModel.getCurrencyById(id: transactionData.conversionCurrencyType).name)
                        .font(.system(size: 10, weight: .bold))
                }
                VStack(alignment: .leading, spacing: 5){
                    VStack(alignment: .leading){
                        Text(transactionData.title).textCase(.uppercase)
                            .font(.system(size: 18, weight: .bold))
                        Text(transactionData.description)
                            .foregroundColor(Color.gray)
                    }
                    Spacer().frame(height: 5)
                    Text("\(currencyPickerModel.getCurrencyById(id: transactionData.baseCurrencyType).code)"+transactionData.baseAmount+" x \(currencyPickerModel.getCurrencyById(id: transactionData.conversionCurrencyType).code)"+transactionData.conversionAmount)
                        .font(.system(size: 17, weight: .bold))
                    (Text("\(currencyPickerModel.getCurrencyById(id: transactionData.conversionCurrencyType).code)")+Text(String(format: "%.2f",(Double(transactionData.baseAmount) ?? 0.0)*(Double(transactionData.conversionAmount) ?? 0.0))))
                        .font(.system(size: 17, weight: .bold))
                }.padding(.leading, 10)
                Spacer()
            }
            Line(padding: 0).padding(.vertical, 5)
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    IntTransactionRowView(transactionData: InternationalTransactionsModel())
}
