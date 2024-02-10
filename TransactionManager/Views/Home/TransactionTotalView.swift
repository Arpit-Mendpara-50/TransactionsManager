//
//  TransactionTotalView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-21.
//

import SwiftUI

struct TransactionTotalView: View {
    @ObservedObject var transactionsViewModel = TransactionsViewModel.shared
    var title: String
    var amount: String
    var secondAmount: String = ""
    var isAdd: Bool
    var showFlags: Bool = false
    var onShowList: (()->Void)?
    var onAdd: (()->Void)?
    
    var body: some View {
        let (baseFlags, conversionFlags) = transactionsViewModel.getIntTransactionsFlags()
        return ZStack {
            VStack(spacing: 0){
                HStack{
                    Spacer().frame(width: 20)
                    Text(title)
                        .bold()
                        .foregroundStyle(Color.white)
                    Spacer()
                }
                .frame(height: 40)
                .background(Color.DarkBlue)
                HStack(spacing: 5){
                    Spacer().frame(width: 20)
                    if showFlags && !baseFlags.isEmpty {
                        MultiCurrencyView(flags: baseFlags)
                            .frame(height: 40)
                    }
                    Text(amount)
                        .bold()
                        .font(.system(size: 20))
                        .foregroundStyle(Color.TextColor)
                        .offset(x: (showFlags && !baseFlags.isEmpty) ? -CGFloat(((baseFlags.count-1)*15)) : 0)
                    Spacer()
                }
                .frame(height: !secondAmount.isEmpty ? 40 : 50)
                .background(Color.SwitchBackgroundColor)
                if !secondAmount.isEmpty {
                    Line(padding: 0)
                    HStack(spacing: 5){
                        Spacer().frame(width: 20)
                        if showFlags && !conversionFlags.isEmpty {
                            MultiCurrencyView(flags: conversionFlags)
                                .frame(height: 40)
                        }
                        Text(secondAmount)
                            .bold()
                            .font(.system(size: 20))
                            .foregroundStyle(Color.TextColor)
                            .offset(x: (showFlags && !conversionFlags.isEmpty) ? -CGFloat(((conversionFlags.count-1)*15)) : 0)
                        Spacer()
                    }
                    .frame(height: !secondAmount.isEmpty ? 40 : 50)
                    .background(Color.SwitchBackgroundColor)
                }
            }
            if isAdd {
                VStack {
                    if !secondAmount.isEmpty {
                        Spacer().frame(height: 20)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            onAdd?()
                        }, label: {
                            Image(systemName: "plus")
                                .renderingMode(.template)
                                .bold()
                                .foregroundColor(Color.black)
                        })
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                    }
                    if !secondAmount.isEmpty {
                        Spacer()
                    }
                }
                .padding(.trailing)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .shadow(radius: 5)
        .onTapGesture(perform: {
            onShowList?()
        })
    }
}

struct InternationalTransactionTotalView: View {
    @ObservedObject var helper = Helper.shared
    
    var baseAmount: String
    var multiplierAmount: String
    var totalAmount: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Spacer().frame(width: 20)
                Text("\(helper.currencyCode)\(baseAmount) x ₹\(multiplierAmount)")
                    .bold()
                Spacer()
            }
            .frame(height: 40)
            .background(Color.white)
            HStack {
                Spacer().frame(width: 20)
                Text("₹\(totalAmount)")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .frame(height: 50)
            .background(Color.DarkBlue)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .shadow(radius: 5)
    }
}
