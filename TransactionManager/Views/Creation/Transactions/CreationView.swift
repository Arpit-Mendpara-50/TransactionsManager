//
//  CreationView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-04-20.
//

import SwiftUI

struct CreationView: View {
    @State var showCategoryView = false
    @State var showCalendarView = false
    @State var showCurrencyPicker = false
    @ObservedObject var categoryManager = CategoryManager.shared
    @ObservedObject var viewModel = CreationViewModel.shared
    @ObservedObject var creationManager = CreationManager.shared
    @ObservedObject var databaseManager = DatabaseManager.shared
    @ObservedObject var transactionsViewModel = TransactionsViewModel.shared
    @ObservedObject var transactionsManager = TransactionsManager.shared
    @ObservedObject var peopleViewModel = PeopleViewModel.shared
    @ObservedObject var peopleManager = PeopleManager.shared
    @ObservedObject var sliderMessageManager = SliderMessageManager.shared
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    @ObservedObject var homeViewModel = HomeViewModel.shared
    
    var body: some View {
        ZStack{
            VStack{
                header
                HStack{
                    Spacer()
                }
                ScrollView{
                    VStack{
                        titleView
                        amountView
                        descriptionView
                        categoryView
                        if viewModel.pubCurrentType == .expense {
                            peopleView
                        }
                        dateView
                        saveButton
                        Spacer().frame(height: ScreenSize.safeBottom())
                    }
                }
                Spacer()
            }
            
            if showCategoryView {
                CategoryPickerView(data: viewModel.pubCategoryData, closeAction: {
                    withAnimation {
                        showCategoryView.toggle()
                    }
                }, onCategorySelected: { item in
                    withAnimation {
                        showCategoryView.toggle()
                    }
                    viewModel.pubSelectedCategory = item
                }).offset(y: ScreenSize.safeTop())
                .transition(.move(edge: .bottom))
            }
            if showCalendarView {
                DatePickerView(closeAction: { selectedDate  in
                    viewModel.pubSelectedDate = selectedDate
                    withAnimation {
                        showCalendarView.toggle()
                    }
                }).offset(y: ScreenSize.safeTop())
                .transition(.move(edge: .bottom))
            }
        }
            .edgesIgnoringSafeArea(.all)
            .background(Color.white)
            .onAppear(perform: {
                var data = categoryManager.getCategories()
                let (filter1, filter2) = viewModel.getTypeValue()
                data = data.filter({$0.type == filter1 || $0.type == filter2})
                viewModel.pubCategoryData = data.sorted(by: {$0.priority < $1.priority})
            })
    }
    
    var titleView: some View {
        VStack{
            HStack{
                Text("\(viewModel.getTitle()) Title")
                    .bold()
                Spacer()
            }
            TextField("Title", text: $viewModel.pubTitleString)
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2)
            Spacer().frame(height: 30)
        }
        .padding(.horizontal)
    }
    
    var amountView: some View {
        VStack{
            HStack{
                Text("\(viewModel.getTitle()) Amount")
                    .bold()
                Spacer()
            }
            HStack {
                Button(action: {
                    showCurrencyPicker.toggle()
                }, label: {
                    HStack {
                        VStack(spacing: 2){
                            Image(currencyPickerModel.pubSelectedCurrencyForTransaction.icon)
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text(currencyPickerModel.pubSelectedCurrencyForTransaction.name)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(Color.black)
                            
                        }
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(radius: 2)
                    }
                    .padding(.trailing, 5)
                })
                TextField("Amount", text: $viewModel.pubAmountString)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 2)
            }
            if showCurrencyPicker {
                CurrencyPickerView(showSelectedView: false, selectedCurrency: currencyPickerModel.pubSelectedCurrencyForTransaction) { currency in
                    currencyPickerModel.pubSelectedCurrencyForTransaction = currency
                    showCurrencyPicker.toggle()
                }
                .padding(.top, 10)
                Text("Your chosen primary currency is \(currencyPickerModel.pubSelectedCurrency.name). If you switch your current transaction currency, it won't appear in the list of current transactions. To view such transactions, please go to settings and update the currency type.")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.red)
            }
            Spacer().frame(height: showCurrencyPicker ? 10 :30)
        }
        .padding(.horizontal)
    }
    
    var descriptionView: some View {
        VStack{
            HStack{
                Text("\(viewModel.getTitle()) Description")
                    .bold()
                Spacer()
            }
            TextField("Description", text: $viewModel.pubDescriptionString)
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2)
            Spacer().frame(height: 30)
        }
        .padding(.horizontal)
    }
    
    var dateView: some View {
        VStack{
            HStack{
                Text("\(viewModel.getTitle()) Date")
                    .bold()
                Spacer()
            }
            HStack{
                Button(action: {
                    withAnimation {
                        showCalendarView.toggle()
                    }
                }, label: {
                    HStack{
                        Text(viewModel.pubSelectedDate.toStringDate()).padding(.horizontal, 10)
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .frame(height: 45)
                })
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2)
            }
            Spacer().frame(height: 30)
        }
        .padding(.horizontal)
    }
    
    var categoryView: some View {
        VStack{
            HStack{
                Text("\(viewModel.getTitle()) Category")
                    .bold()
                Spacer()
            }
            HStack{
                Button(action: {
                    withAnimation {
                        showCategoryView.toggle()
                    }
                }, label: {
                    if let category = viewModel.pubSelectedCategory{
                        HStack(spacing: 20){
                            Image(category.icon)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.leading)
                            
                            Text(category.title).bold()
                            Spacer().frame(width: 10)
                        }
                        .foregroundColor(Color.white)
                        .frame(height: 80)
                        .background(Color(UIColor(named: category.color) ?? UIColor.black))
                    }else{
                        HStack{
                            Text("Category").opacity(0.5).padding(.horizontal, 10)
                            Spacer()
                        }
                        .foregroundColor(Color.gray)
                        .frame(height: 45)
                    }
                })
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2)
                Spacer()
            }
            Spacer().frame(height: 30)
        }
        .padding(.horizontal)
    }
    
    var peopleView: some View {
        VStack {
            HStack{
                Text("People")
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            PeopleListView(isSelectable: true)
        }
    }
    
    
    var header: some View {
        VStack(spacing: 0){
            Spacer().frame(height: ScreenSize.safeTop())
            HStack{
                backButton
                Spacer()
                Text(viewModel.getTitle()).font(.system(size: 17)).bold().foregroundColor(Color.black)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 2)
                Spacer()
                if !viewModel.pubTitleString.isEmpty || !viewModel.pubAmountString.isEmpty || viewModel.pubSelectedCategory != nil || !viewModel.pubDescriptionString.isEmpty || viewModel.pubSelectedDate.toStringDate() != Date().toStringDate(){
                    clearButton
                }else{
                    Spacer().frame(width: 35)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 60+ScreenSize.safeTop())
        .background(Color.DarkBlue.opacity(0.7))
        .shadow(radius: 5)
        
    }
    
    var backButton: some View{
        Button(action: {
            homeViewModel.pubShowCreationView = false
            viewModel.clearFormData()
        }, label: {
            VStack{
                Image(systemName: "chevron.backward")
                    .renderingMode(.template)
                    .foregroundColor(Color.black)
                    .bold()
            }
            .frame(width: 35, height: 35, alignment: .center)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 2)
        })
    }
    
    var clearButton: some View{
        Button(action: {
            viewModel.clearFormData()
        }, label: {
            VStack{
                Image(systemName: "trash.fill")
                    .renderingMode(.template)
                    .foregroundColor(Color.black)
                    .bold()
            }
            .frame(width: 35, height: 35, alignment: .center)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 2)
        })
    }
    
    var saveButton: some View{
        Button(action: {
            let validInput = viewModel.checkValidInputs()
            if validInput.isEmpty {
                if viewModel.pubIsUpdatingTransaction {
                    guard let id = viewModel.pubTransactionId else {return}
                    creationManager.updateTransaction(transactionId: id, titleValue: viewModel.pubTitleString, amountValue: viewModel.pubAmountString, categoryValue: viewModel.pubSelectedCategory?.id ?? 0, descriptionValue: viewModel.pubDescriptionString, transactionTypeValue: viewModel.pubCurrentType.rawValue, currencyTypeValue: currencyPickerModel.pubSelectedCurrencyForTransaction.id, peopleIncluded: viewModel.pubSelectedPeopleID, createdDateValue: viewModel.pubSelectedDate.ISO8601Format(), updatedDateValue: Date().ISO8601Format(), completionHandler: { title, message in
                        if title == "Success" {
                            viewModel.clearFormData()
                            sliderMessageManager.pubSliderTitle = title
                            sliderMessageManager.pubSliderMessage = message
                            transactionsManager.getTransactionsList()
                            transactionsViewModel.loadSectionData(data: transactionsViewModel.allTransactions)
                            withAnimation {
                                sliderMessageManager.pubShowSliderMessageView = true
                                homeViewModel.pubShowCreationView = false
                            }
                        } else {
                            sliderMessageManager.pubSliderTitle = title
                            sliderMessageManager.pubSliderMessage = message
                            sliderMessageManager.pubShowSliderMessageView = true
                        }
                    })
                } else {
                    creationManager.addTransaction(titleValue: viewModel.pubTitleString, amountValue: viewModel.pubAmountString, categoryValue: viewModel.pubSelectedCategory?.id ?? 0, descriptionValue: viewModel.pubDescriptionString, transactionTypeValue: viewModel.pubCurrentType.rawValue, currencyTypeValue: currencyPickerModel.pubSelectedCurrencyForTransaction.id, peopleIncluded: viewModel.pubSelectedPeopleID, createdDateValue: viewModel.pubSelectedDate.ISO8601Format(), updatedDateValue: Date().ISO8601Format(), completionHandler: { title, message in
                        if title == "Success" {
                            viewModel.clearFormData()
                            sliderMessageManager.pubSliderTitle = title
                            sliderMessageManager.pubSliderMessage = message
                            transactionsManager.getTransactionsList()
                            withAnimation {
                                sliderMessageManager.pubShowSliderMessageView = true
                                homeViewModel.pubShowCreationView = false
                            }
                        } else {
                            sliderMessageManager.pubSliderTitle = title
                            sliderMessageManager.pubSliderMessage = message
                            sliderMessageManager.pubShowSliderMessageView = true
                        }
                    })
                }
            } else {
                sliderMessageManager.pubSliderTitle = "Failed"
                sliderMessageManager.pubSliderMessage = validInput
                withAnimation {
                    sliderMessageManager.pubShowSliderMessageView = true
                }
            }
        }, label: {
            HStack(spacing: 10){
                Spacer()
                Text(viewModel.pubIsUpdatingTransaction ? "Update" : "Save")
                    .bold()
                    .foregroundColor(Color.white)
                Image(systemName: "checkmark")
                    .renderingMode(.template)
                    .foregroundColor(Color.white)
                    .bold()
                Spacer()
            }
            .frame(height: 50, alignment: .center)
            .background(Color.DarkBlue.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 2)
        })
        .padding(.horizontal)
    }
}
