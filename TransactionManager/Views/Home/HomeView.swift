//
//  HomeView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-01-06.
//

import SwiftUI

struct HomeView: View {
    
    @State var showCreationView = false
    @State var showInternationalCreationView = false
//    @State var showListView = false
//    @State var showIntListView = false
    @ObservedObject var creationManager = CreationManager.shared
    @ObservedObject var creationViewModel = CreationViewModel.shared
    @ObservedObject var transactionsManager = TransactionsManager.shared
    @ObservedObject var transactionsViewModel = TransactionsViewModel.shared
    @ObservedObject var intTransactionsViewModel = InternationalCreationViewModel.shared
    @ObservedObject var databaseManager = DatabaseManager.shared
    @ObservedObject var peopleManager = PeopleManager.shared
    @ObservedObject var peopleViewModel = PeopleViewModel.shared
    @ObservedObject var sliderMessageManager = SliderMessageManager.shared
    @ObservedObject var settingsViewModel = SettingsViewModel.shared
    @ObservedObject var personTransactionsViewModel = PersonTransactionsViewModel.shared
    @ObservedObject var filterViewModel = FilterViewModel.shared
    @ObservedObject var helper = Helper.shared
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    
    var body: some View {
        ZStack {
            if !transactionsViewModel.pubIsTransactionsLoading {
                ScrollView {
                    VStack {
                        HStack {
                            Text("Transactions").font(.system(size: 30, weight: .bold))
                            Spacer()
                            Button(action: {
                                settingsViewModel.pubShowSettingsView = true
                            }, label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 40, height: 40)
                                        .shadow(radius: 5)
                                    Image(systemName: "gear")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(Color.black)
                                        .frame(width: 25, height: 25)
                                }
                            })
                        }.padding()
                        VStack(spacing: 15) {
                            TransactionTotalView(title: "Total Income", amount: transactionsViewModel.transactionTotal(type: .income), color: Color.green, isAdd: true, onShowList: {
                                transactionsViewModel.pubCurrentListType = .income
                                openListPage()
                            }, onAdd: {
                                creationViewModel.pubCurrentType = .income
                                showCreationView = true
                            })
                            TransactionTotalView(title: "Total Expense", amount: transactionsViewModel.transactionTotal(type: .expense), color: Color.red, isAdd: true, onShowList: {
                                transactionsViewModel.pubCurrentListType = .expense
                                openListPage()
                            }, onAdd: {
                                creationViewModel.pubCurrentType = .expense
                                showCreationView = true
                            })
                            TransactionTotalView(title: "Remaining Balance", amount: transactionsViewModel.transactionTotal(type: .transaction), color: Color.gray, isAdd: false, onShowList: {
                                transactionsViewModel.pubCurrentListType = .transaction
                                openListPage()
                            }, onAdd: {})
                        }
                        HStack {
                            Text("International").font(.system(size: 30, weight: .bold))
                            Spacer()
                        }.padding()
                        VStack {
                            TransactionTotalView(title: "Transfers", amount: transactionsViewModel.internationalTransactionBaseTotal(), secondAmount: transactionsViewModel.internationalTransactionConversionTotal(), color: Color.DarkBlue, isAdd: true, showFlags: true, onShowList: {
                                transactionsViewModel.loadInternationalSectionData(data: transactionsViewModel.allIntTransactions)
                                transactionsViewModel.pubShowIntListView = true
                            }, onAdd: {
                                showInternationalCreationView = true
                            })
                        }
                        HStack {
                            Text("People").font(.system(size: 30, weight: .bold))
                            Spacer()
                        }.padding()
                        if !peopleViewModel.pubIsPeopleLoading {
                            PeopleListView(isSelectable: false)
                        }
                        Spacer().frame(height: ScreenSize.safeBottom())
                    }
                }
                
                if showInternationalCreationView{
                    InternationalTransactionView(isShowView: $showInternationalCreationView).edgesIgnoringSafeArea(.all)
                }
                
                if showCreationView{
                    CreationView(isShowView: $showCreationView).edgesIgnoringSafeArea(.all)
                }
                
                if transactionsViewModel.pubShowListView{
                    TransactionsListView().edgesIgnoringSafeArea(.all)
                }
                
                if transactionsViewModel.pubShowIntListView{
                    IntTransactionsListView().edgesIgnoringSafeArea(.all)
                }
                
                if personTransactionsViewModel.pubShowPersonTransactionsList {
                    PersonTransactionsList()
                }
                
                if peopleViewModel.pubShowPeopleCreationView {
                    BlurView()
                }
                
                if peopleViewModel.pubShowPeopleCreationView {
                    VStack {
                        Spacer()
                        PeopleCreationView()
                            .offset(y: -(helper.keyboardHeight > 0.0 ? helper.keyboardHeight - 50 : helper.keyboardHeight))
                    }
                    .transition(.move(edge: .bottom))
                }
                
                if settingsViewModel.pubShowSettingsView {
                    SettingsView()
                }
                
                if filterViewModel.pubShowFilterView {
                    FilterView()
                }
                
                if sliderMessageManager.pubShowSliderMessageView {
                    SliderMessageView(title: sliderMessageManager.pubSliderTitle, message: sliderMessageManager.pubSliderMessage)
                        .transition(.move(edge: .top))
                }
                
            } else {
                VStack {
                    Spacer()
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                    Spacer()
                }
            }
            
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            getAllTransactions()
            getPeople()
            getAllInternationalTransactions()
            currencyPickerModel.getSelectedCurrency()
        }
    }
    
    func openListPage() {
        transactionsViewModel.pubTransactionsSectionData.removeAll()
        transactionsViewModel.pubPreviousTransactionDate = nil
        transactionsViewModel.filterTransactionsData()
        transactionsViewModel.pubShowListView = true
    }
    
    func getAllTransactions() {
        transactionsViewModel.pubIsTransactionsLoading = true
        transactionsManager.getTransactionsList()
    }
    
    func getAllInternationalTransactions() {
        transactionsViewModel.pubIsIntTransactionsLoading = true
        transactionsManager.getInternationalTransactionsList()
    }
    
    func getPeople() {
        peopleViewModel.pubIsPeopleLoading = true
        peopleManager.getPeopleList()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
