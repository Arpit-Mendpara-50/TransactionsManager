//
//  TransactionRowView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-04-12.
//

import SwiftUI

struct TransactionSectionView: View {
    var dateText: String
    var transactionData: [TransactionsModel]
    
    var body: some View {
        VStack{
            HStack{
                Text(dateText).bold().padding(.leading, 10)
                Line(padding: 30)
            }.padding(.bottom)
            ForEach(transactionData){ item in
                TransactionRowView(transactionData: item)
            }
        }
    }
}

struct TransactionRowView: View {
    var transactionData: TransactionsModel
    
    var body: some View {
        VStack{
            HStack(spacing: 10){
                Image(transactionData.category?.icon ?? "")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(UIColor(named: transactionData.category?.color ?? "") ?? UIColor.black))
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading){
                    Text(transactionData.title).textCase(.uppercase)
                        .font(.system(size: 18, weight: .bold))
                    Text(transactionData.description)
                        .foregroundColor(Color.gray)
                }
                Spacer()
                Text("$"+transactionData.amount)
                    .font(.system(size: 17, weight: .bold))
            }.padding(.leading, 10)
            if transactionData.transactionType == 0 {
                HStack {
                    Text("People Included")
                        .font(.system(size: 10))
                        .lineLimit(2)
                        .frame(width: 50)
                    Spacer().frame(width: 5)
                    if !transactionData.peopleIncluded.isEmpty {
                        ForEach(TransactionsManager.shared.getPeopleIncluded(people: transactionData.peopleIncluded)) { item in
                            HStack(spacing: 5){
                                if let image = ImagePickerManager.shared.loadImageFromDocumentsDirectory(imageName: item.imagePath) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 10)
            }
            Line(padding: 0).padding(.vertical, 5)
            Spacer()
        }
        .padding(.horizontal)
    }
}
