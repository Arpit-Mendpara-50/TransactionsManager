//
//  CreationView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-04-20.
//

import SwiftUI

struct CreationView: View {
    @Binding var isShowView: Bool
    @State var showCategoryView = false
    @State var showCalendarView = false
    @ObservedObject var categoryManager = CategoryManager.shared
    @ObservedObject var viewModel = CreationViewModel.shared
    @ObservedObject var creationManager = CreationManager.shared
    @ObservedObject var databaseManager = DatabaseManager.shared
    @ObservedObject var transactionsViewModel = TransactionsViewModel.shared
    @ObservedObject var transactionsManager = TransactionsManager.shared
    @ObservedObject var peopleViewModel = PeopleViewModel.shared
    @ObservedObject var peopleManager = PeopleManager.shared
    @ObservedObject var sliderMessageManager = SliderMessageManager.shared
    
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
            
//            if showPeopleCreationView {
//                BlurView()
//            }
            
//            if showPeopleCreationView {
//                VStack {
//                    Spacer()
//                    PeopleCreationView() { title, message, isShow in
//                        withAnimation {
//                            showPeopleCreationView.toggle()
//                            if isShow {
//                                sliderMessageManager.pubShowSliderMessageView = isShow
//                                sliderMessageManager.pubSliderTitle = title
//                                sliderMessageManager.pubSliderMessage = message
//                            }
//                        }
//                    }
//                }
//                .transition(.move(edge: .bottom))
//            }
            
            if sliderMessageManager.pubShowSliderMessageView {
                SliderMessageView(title: sliderMessageManager.pubSliderTitle, message: sliderMessageManager.pubSliderMessage) {
                    sliderMessageManager.pubShowSliderMessageView = false
                }
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
            TextField("Amount", text: $viewModel.pubAmountString)
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
        /*VStack {
            HStack{
                Text("People")
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    if !peopleViewModel.pubIsPeopleLoading {
                        ForEach(0..<peopleViewModel.pubPeopleData.count) { index in
                            PeopleView(id: peopleViewModel.pubPeopleData[index].id, title: peopleViewModel.pubPeopleData[index].personName, image: peopleViewModel.pubPeopleData[index].imagePath, amount: peopleViewModel.pubPeopleData[index].amount, color: Color.white, isAdd: false, isSelectable: true, onTap: {
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
            .padding(.horizontal)
        }
        .padding(.bottom)*/
        VStack {
            HStack{
                Text("People")
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            PeopleListView()
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
    
    var saveButton: some View{
        Button(action: {
            creationManager.addTransaction(titleValue: viewModel.pubTitleString, amountValue: viewModel.pubAmountString, categoryValue: viewModel.pubSelectedCategory?.id ?? 0, descriptionValue: viewModel.pubDescriptionString, transactionTypeValue: viewModel.pubCurrentType.rawValue, peopleIncluded: viewModel.pubSelectedPeopleID, createdDateValue: viewModel.pubSelectedDate.ISO8601Format(), updatedDateValue: Date().ISO8601Format(), completionHandler: { title, message in
                if title == "Success" {
                    peopleViewModel.pubLastUpdated = Date().timeIntervalSince1970
                    viewModel.clearFormData()
                    sliderMessageManager.pubSliderTitle = title
                    sliderMessageManager.pubSliderMessage = message
                    transactionsManager.getTransactionsList()
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
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 2)
        })
        .padding(.horizontal)
    }
}
