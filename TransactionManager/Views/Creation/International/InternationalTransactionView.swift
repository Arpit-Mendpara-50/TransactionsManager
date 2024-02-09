//
//  InternationalTransactionView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-26.
//

import SwiftUI

struct InternationalTransactionView: View {
    
    @ObservedObject var viewModel = InternationalCreationViewModel.shared
    @ObservedObject var manager = InternationalCreationManager.shared
    @ObservedObject var transactionsManager = TransactionsManager.shared
    @ObservedObject var sliderMessageManager = SliderMessageManager.shared
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    
    @Binding var isShowView: Bool
    @State var showCalendarView = false
    @State var showBaseCurrencyPicker = false
    @State var showConversionCurrencyPicker = false
    
    var body: some View {
        ZStack {
            VStack{
                header
                HStack{
                    Spacer()
                }
                ScrollView{
                    VStack{
                        titleView
                        baseAmountView
                        conversionAmountView
                        descriptionView
                        dateView
                        saveButton
                        Spacer().frame(height: ScreenSize.safeBottom())
                    }
                }
                Spacer()
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
    }
    
    var header: some View {
        VStack(spacing: 0){
            Spacer().frame(height: ScreenSize.safeTop())
            HStack{
                backButton
                Spacer()
                Text("International").font(.system(size: 17)).bold().foregroundColor(Color.black)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 2)
                Spacer()
//                if !viewModel.pubTitleString.isEmpty || !viewModel.pubAmountString.isEmpty || viewModel.pubSelectedCategory != nil || !viewModel.pubDescriptionString.isEmpty || viewModel.pubSelectedDate.toStringDate() != Date().toStringDate(){
//                    clearButton
//                }else{
//                    Spacer().frame(width: 35)
//                }
            }
            .padding(.horizontal)
        }
        .frame(height: 60+ScreenSize.safeTop())
        .background(Color.gray)
        .shadow(radius: 5)
        
    }
    
    var backButton: some View{
        Button(action: {
            isShowView = false
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
    
    var titleView: some View {
        VStack{
            HStack{
                Text("Transaction Title")
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
    
    var baseAmountView: some View {
        VStack{
            HStack{
                Text("Base Amount")
                    .bold()
                Spacer()
            }
            HStack {
                Button(action: {
                    showBaseCurrencyPicker.toggle()
                }, label: {
                    HStack {
                        VStack(spacing: 2){
                            Image(viewModel.pubSelectedBaseCurrency.icon)
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text(viewModel.pubSelectedBaseCurrency.name)
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
                TextField("Amount", text: $viewModel.pubBaseAmountString)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 2)
            }
            if showBaseCurrencyPicker {
                CurrencyPickerView(showSelectedView: false, selectedCurrency: viewModel.pubSelectedBaseCurrency) { currency in
                    viewModel.pubSelectedBaseCurrency = currency
                    showBaseCurrencyPicker.toggle()
                }
                .padding(.top, 10)
                Text("Your chosen primary currency is \(currencyPickerModel.pubSelectedCurrency.name). If you switch your current transaction currency, it won't appear in the list of current transactions. To view such transactions, please go to settings and update the currency type.")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.red)
            }
            Spacer().frame(height: showBaseCurrencyPicker ? 10 :30)
        }
        .padding(.horizontal)
    }
    
    var conversionAmountView: some View {
        VStack{
            HStack{
                Text("Conversion Amount")
                    .bold()
                Spacer()
            }
            HStack {
                Button(action: {
                    showConversionCurrencyPicker.toggle()
                }, label: {
                    HStack {
                        VStack(spacing: 2){
                            Image(viewModel.pubSelectedConversionCurrency.icon)
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text(viewModel.pubSelectedConversionCurrency.name)
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
                TextField("Amount", text: $viewModel.pubConversionAmountString)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 2)
            }
            if showConversionCurrencyPicker {
                CurrencyPickerView(showSelectedView: false, selectedCurrency: viewModel.pubSelectedConversionCurrency) { currency in
                    viewModel.pubSelectedConversionCurrency = currency
                    showConversionCurrencyPicker.toggle()
                }
                .padding(.top, 10)
                Text("Your chosen primary currency is \(currencyPickerModel.pubSelectedCurrency.name). If you switch your current transaction currency, it won't appear in the list of current transactions. To view such transactions, please go to settings and update the currency type.")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.red)
            }
            Spacer().frame(height: showConversionCurrencyPicker ? 10 :30)
        }
        .padding(.horizontal)
    }
    
    var descriptionView: some View {
        VStack{
            HStack{
                Text("Transaction Description")
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
                Text("Transaction Date")
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
    
    var saveButton: some View{
        Button(action: {
            manager.addIntTransaction(titleValue: viewModel.pubTitleString, baseAmountValue: viewModel.pubBaseAmountString, conversionAmountValue: viewModel.pubConversionAmountString, descriptionValue: viewModel.pubDescriptionString, baseCurrencyTypeValue: viewModel.pubSelectedBaseCurrency.id, conversionCurrencyTypeValue: viewModel.pubSelectedConversionCurrency.id, createdDateValue: viewModel.pubSelectedDate.ISO8601Format(), updatedDateValue: Date().ISO8601Format(), completionHandler: { title, message in
                    if title == "Success" {
                        viewModel.clearFormData()
                        sliderMessageManager.pubSliderTitle = title
                        sliderMessageManager.pubSliderMessage = message
                        transactionsManager.getInternationalTransactionsList()
                        withAnimation {
                            sliderMessageManager.pubShowSliderMessageView = true
                            isShowView = false
                        }
                    } else {
                        sliderMessageManager.pubSliderTitle = title
                        sliderMessageManager.pubSliderMessage = message
                        sliderMessageManager.pubShowSliderMessageView = true
                    }
            })
        }, label: {
            HStack(spacing: 10){
                Spacer()
                Text("Save")
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
