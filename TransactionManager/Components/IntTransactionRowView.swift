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
    var transactionData: InternationalTransactionsModel
    
    var body: some View {
        VStack{
            HStack {
                VStack(alignment: .leading, spacing: 5){
                    //                Image(transactionData.category?.icon ?? "")
                    //                    .resizable()
                    //                    .renderingMode(.template)
                    //                    .foregroundColor(Color(UIColor(named: transactionData.category?.color ?? "") ?? UIColor.black))
                    //                    .frame(width: 40, height: 40)
                    VStack(alignment: .leading){
                        Text(transactionData.title).textCase(.uppercase)
                            .font(.system(size: 18, weight: .bold))
                        Text(transactionData.description)
                            .foregroundColor(Color.gray)
                    }
                    Spacer().frame(height: 5)
                    Text("$"+transactionData.baseAmount+" x ₹"+transactionData.conversionAmount)
                        .font(.system(size: 17, weight: .bold))
                    (Text("₹")+Text(String(format: "%.2f",(Double(transactionData.baseAmount) ?? 0.0)*(Double(transactionData.conversionAmount) ?? 0.0))))
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
