//
//  TransactionTotalView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-21.
//

import SwiftUI

struct TransactionTotalView: View {
    
    var title: String
    var amount: String
    var secondAmount: String = ""
    var color: Color
    var isAdd: Bool
    var onShowList: (()->Void)?
    var onAdd: (()->Void)?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                HStack{
                    Spacer().frame(width: 20)
                    Text(title)
                        .bold()
                        .foregroundStyle(Color.white)
                    Spacer()
                }
                .frame(height: 40)
                .background(color.opacity(0.7))
                HStack {
                    Spacer().frame(width: 20)
                    Text(amount)
                        .bold()
                        .font(.system(size: 20))
                        .foregroundStyle(Color.black)
                    Spacer()
                }
                .frame(height: !secondAmount.isEmpty ? 40 : 50)
                .background(Color.white)
                if !secondAmount.isEmpty {
                    Line(padding: 0)
                    HStack {
                        Spacer().frame(width: 20)
                        Text(secondAmount)
                            .bold()
                            .font(.system(size: 20))
                            .foregroundStyle(Color.black)
                        Spacer()
                    }
                    .frame(height: !secondAmount.isEmpty ? 40 : 50)
                    .background(Color.white)
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
    
    var baseAmount: String
    var multiplierAmount: String
    var totalAmount: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Spacer().frame(width: 20)
                Text("$\(baseAmount) x ₹\(multiplierAmount)")
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
            .background(color.opacity(0.7))
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .shadow(radius: 5)
    }
}
