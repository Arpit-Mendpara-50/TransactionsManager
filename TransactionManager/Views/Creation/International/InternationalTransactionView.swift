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
    
    @Binding var isShowView: Bool
    @State var showCalendarView = false
    
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
            TextField("Amount", text: $viewModel.pubBaseAmountString)
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2)
            Spacer().frame(height: 30)
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
            TextField("Amount", text: $viewModel.pubConversionAmountString)
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2)
            Spacer().frame(height: 30)
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
            manager.addIntTransaction(titleValue: viewModel.pubTitleString, baseAmountValue: viewModel.pubBaseAmountString, conversionAmountValue: viewModel.pubConversionAmountString, descriptionValue: viewModel.pubDescriptionString, createdDateValue: viewModel.pubSelectedDate.ISO8601Format(), updatedDateValue: Date().ISO8601Format())
            viewModel.clearFormData()
            transactionsManager.getInternationalTransactionsList()
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
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 2)
        })
        .padding(.horizontal)
    }
}
