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
            }.padding(.bottom, 10)
            ForEach(transactionData){ item in
                TransactionRowView(transactionData: item)
            }
        }
        .padding(.bottom)
    }
}

struct TransactionRowView: View {
    @ObservedObject var transactionsManager = TransactionsManager.shared
    @ObservedObject var transactionsViewModel = TransactionsViewModel.shared
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    @ObservedObject var helper = Helper.shared
    @ObservedObject var homeViewModel = HomeViewModel.shared
    @ObservedObject var creationViewModel = CreationViewModel.shared
    
    var transactionData: TransactionsModel
    @State var showToolBar: Bool = false
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    withAnimation {
                        showToolBar.toggle()
                    }
                }, label: {
                    VStack {
                        HStack(spacing: 10){
                            Image(transactionData.category?.icon ?? "")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color(UIColor(named: transactionData.category?.color ?? "") ?? UIColor.black))
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading){
                                Text(transactionData.title).textCase(.uppercase)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(Color.TextColor)
                                Text(transactionData.description)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            if transactionData.transactionType == 0 {
                                VStack(alignment: .trailing){
                                    Text("\(currencyPickerModel.getCurrencyById(id: transactionData.currencyType).code)"+transactionData.amount)
                                        .font(.system(size: 15, weight: .bold))
                                        .strikethrough()
                                        .foregroundStyle(Color.gray)
                                    HStack {
                                        Image(currencyPickerModel.getCurrencyById(id: transactionData.currencyType).icon)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        Text("\(currencyPickerModel.getCurrencyById(id: transactionData.currencyType).code)"+transactionsViewModel.getDividedAmount(amount: transactionData.amount, peopleIncluded: transactionData.peopleIncluded))
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundStyle(Color.TextColor)
                                    }
                                }
                            } else {
                                VStack(alignment: .trailing){
                                    HStack {
                                        Image(currencyPickerModel.getCurrencyById(id: transactionData.currencyType).icon)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        Text("\(currencyPickerModel.getCurrencyById(id: transactionData.currencyType).code)"+transactionData.amount)
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundStyle(Color.TextColor)
                                    }
                                    if showToolBar {
                                        HStack {
                                            Button(action: {
                                                transactionsViewModel.populateIncomeData(id: transactionData.id, title: transactionData.title, amount: transactionData.amount, description: transactionData.description, category: transactionData.category, createdDate: transactionData.createdDate)
                                                CreationViewModel.shared.pubIsUpdatingTransaction = true
                                                homeViewModel.pubShowCreationView = true
                                            }, label: {
                                                VStack {
                                                    Image(systemName: "pencil")
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .bold()
                                                        .foregroundStyle(Color.white)
                                                }
                                                .padding(10)
                                                .frame(width: 50)
                                                .background(Color.DarkBlue)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .shadow(radius: 5)
                                            })
                                            Spacer().frame(height: 10)
                                            Button(action: {
                                                transactionsManager.deleteTransaction(idValue: transactionData.id, peopleIncluded: transactionData.peopleIncluded, amountValue: transactionData.amount, transactionCurrencyType: transactionData.currencyType)
                                            }, label: {
                                                VStack {
                                                    Image(systemName: "trash.fill")
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .bold()
                                                        .foregroundStyle(Color.white)
                                                }
                                                .padding(10)
                                                .frame(width: 50)
                                                .background(Color.red)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .shadow(radius: 5)
                                            })
                                        }
                                        .padding(.horizontal, 10)
                                        .frame(width: 100)
                                    }
                                }
                            }
                        }.padding(.leading, 5)
                        if transactionData.transactionType == 0 {
                            HStack {
                                Text("People Included")
                                    .font(.system(size: 10))
                                    .lineLimit(2)
                                    .frame(width: 60)
                                    .foregroundStyle(Color.TextColor)
                                    .multilineTextAlignment(.leading)
                                    .frame(minHeight: 40)
                                Spacer().frame(width: 5)
                                if !transactionData.peopleIncluded.isEmpty {
                                    ForEach(transactionsViewModel.getPeopleIncluded(people: transactionData.peopleIncluded)) { item in
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
                            .padding(.leading, 0)
                        }
                    }
                })
                if transactionData.transactionType == 0 && showToolBar {
                    VStack {
                        Button(action: {
                            transactionsViewModel.populateExpenseData(id: transactionData.id, title: transactionData.title, amount: transactionData.amount, description: transactionData.description, category: transactionData.category, createdDate: transactionData.createdDate, peopleIncluded: transactionData.peopleIncluded)
                            CreationViewModel.shared.pubIsUpdatingTransaction = true
                            homeViewModel.pubShowCreationView = true
                        }, label: {
                            VStack {
                                Spacer()
                                Image(systemName: "pencil")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                    .bold()
                                    .foregroundStyle(Color.white)
                                Spacer()
                            }
                            .padding(10)
                            .background(Color.DarkBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                        })
                        Spacer().frame(height: 10)
                        Button(action: {
                            transactionsManager.deleteTransaction(idValue: transactionData.id, peopleIncluded: transactionData.peopleIncluded, amountValue: transactionData.amount, transactionCurrencyType: transactionData.currencyType)
                        }, label: {
                            VStack {
                                Spacer()
                                Image(systemName: "trash.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                    .bold()
                                    .foregroundStyle(Color.white)
                                Spacer()
                            }
                            .padding(10)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                        })
                    }
                    .padding(.leading, 10)
                    .padding(.top, 10)
                }
            }
        }
        .padding(10)
        .background(Color.SwitchBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .padding(.vertical, 5)
        .shadow(radius: 5)
    }
}
