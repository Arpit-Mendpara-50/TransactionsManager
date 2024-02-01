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
    @State var showListView = false
    @State var showIntListView = false
//    @State var showPeopleCreationView = false
    @ObservedObject var creationManager = CreationManager.shared
    @ObservedObject var transactionsManager = TransactionsManager.shared
    @ObservedObject var creationViewModel = CreationViewModel.shared
    @ObservedObject var transactionsViewModel = TransactionsViewModel.shared
    @ObservedObject var databaseManager = DatabaseManager.shared
    @ObservedObject var peopleManager = PeopleManager.shared
    @ObservedObject var peopleViewModel = PeopleViewModel.shared
    @ObservedObject var sliderMessageManager = SliderMessageManager.shared
    
    var body: some View {
        ZStack {
            if !transactionsViewModel.pubIsTransactionsLoading {
                ScrollView {
                    VStack {
                        HStack {
                            Text("Transactions").font(.system(size: 30, weight: .bold))
                            Spacer()
                        }.padding()
                        VStack(spacing: 15) {
                            TransactionTotalView(title: "Total Income", amount: transactionsManager.transactionTotal(type: .income), color: Color.green, isAdd: true, onShowList: {
                                transactionsViewModel.pubCurrentListType = .income
                                openListPage()
                            }, onAdd: {
                                creationViewModel.pubCurrentType = .income
                                showCreationView = true
                            })
                            TransactionTotalView(title: "Total Expense", amount: transactionsManager.transactionTotal(type: .expense), color: Color.red, isAdd: true, onShowList: {
                                transactionsViewModel.pubCurrentListType = .expense
                                openListPage()
                            }, onAdd: {
                                creationViewModel.pubCurrentType = .expense
                                showCreationView = true
                            })
                            TransactionTotalView(title: "Remaining Balance", amount: transactionsManager.transactionTotal(type: .transaction), color: Color.gray, isAdd: false, onShowList: {
                                transactionsViewModel.pubCurrentListType = .transaction
                                openListPage()
                            }, onAdd: {})
                        }
                        HStack {
                            Text("International").font(.system(size: 30, weight: .bold))
                            Spacer()
                        }.padding()
                        VStack {
                            TransactionTotalView(title: "Transfers", amount: transactionsManager.internationalTransactionBaseTotal(), secondAmount: transactionsManager.internationalTransactionConversionTotal(), color: Color.DarkBlue, isAdd: true, onShowList: {
                                transactionsManager.loadInternationalSectionData(data: transactionsViewModel.allIntTransactions)
                                showIntListView = true
                            }, onAdd: {
                                showInternationalCreationView = true
                            })
                        }
                        HStack {
                            Text("People").font(.system(size: 30, weight: .bold))
                            Spacer()
                        }.padding()
                        /*ScrollView(.horizontal) {
                            HStack(spacing: 15) {
                                if !peopleViewModel.pubIsPeopleLoading {
                                    ForEach(0..<peopleViewModel.pubPeopleData.count) { index in
                                        PeopleView(id: peopleViewModel.pubPeopleData[index].id, title: peopleViewModel.pubPeopleData[index].personName, image: peopleViewModel.pubPeopleData[index].imagePath, amount: peopleViewModel.pubPeopleData[index].amount, color: Color.white, isAdd: false, isSelectable: false, onTap: {
                                            
                                        })
                                    }
                                }
                                //MARK:  Default add button
                                PeopleView(id: 0, title: "Add new member", image: "", amount: "", color: Color.gray, isAdd: true, isSelectable: false) {
                                    withAnimation {
                                        peopleViewModel.pubShowPeopleCreationView.toggle()
                                    }
                                }
                                
                            }
                            .padding(.horizontal, 5)
                        }
                        .frame(height: 130)
                        .padding(.horizontal)*/
                        PeopleListView()
                        Spacer().frame(height: ScreenSize.safeBottom())
                        /*
                        HStack {
                            Text("Transactions").font(.system(size: 30, weight: .bold))
                            Spacer()
                        }.padding()
                        VStack{
                            RowView(title: "In-Bound", subtitle: "Description Label", isDirect: false, onShowList: {
                                transactionsViewModel.pubCurrentListType = .income
                                openListPage()
                            }, onAdd: {
                                creationViewModel.pubCurrentType = .income
                                showCreationView = true
                            })
                            RowView(title: "Out-Bound", subtitle: "Description Label", isDirect: false, onShowList: {
                                transactionsViewModel.pubCurrentListType = .expense
                                openListPage()
                            }, onAdd: {
                                creationViewModel.pubCurrentType = .expense
                                showCreationView = true
                            })
                            RowView(title: "Transactions", subtitle: "Description Label", isDirect: true, onShowList: {
                                transactionsViewModel.pubCurrentListType = .transaction
                                openListPage()
                            }, onAdd: {})
                        }
                         */
                    }
                }
                
                if showInternationalCreationView{
                    InternationalTransactionView(isShowView: $showInternationalCreationView).edgesIgnoringSafeArea(.all)
                }
                
                if showCreationView{
                    CreationView(isShowView: $showCreationView).edgesIgnoringSafeArea(.all)
                }
                
                if showListView{
                    TransactionsListView(isShowView: $showListView).edgesIgnoringSafeArea(.all)
                }
                
                if showIntListView{
                    IntTransactionsListView(isShowView: $showIntListView).edgesIgnoringSafeArea(.all)
                }
                if peopleViewModel.pubShowPeopleCreationView {
                    BlurView()
                }
                
                if peopleViewModel.pubShowPeopleCreationView {
                    VStack {
                        Spacer()
                        PeopleCreationView() { title, message, isShow in
                            withAnimation {
                                peopleViewModel.pubShowPeopleCreationView.toggle()
                                if isShow {
                                    sliderMessageManager.pubShowSliderMessageView = isShow
                                    sliderMessageManager.pubSliderTitle = title
                                    sliderMessageManager.pubSliderMessage = message
                                }
                            }
                        }
                    }
                    .transition(.move(edge: .bottom))
                }
                
                if sliderMessageManager.pubShowSliderMessageView {
                    SliderMessageView(title: sliderMessageManager.pubSliderTitle, message: sliderMessageManager.pubSliderMessage) {
                        withAnimation {
                            sliderMessageManager.pubShowSliderMessageView = false
                        }
                    }
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
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                withAnimation {
                    sliderMessageManager.pubShowSliderMessageView = true
                }
            })
        }
    }
    
    func openListPage() {
        transactionsViewModel.pubTransactionsSectionData.removeAll()
        transactionsViewModel.pubPreviousTransactionDate = nil
        transactionsManager.loadSectionData(data: transactionsViewModel.allTransactions)
        showListView = true
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
