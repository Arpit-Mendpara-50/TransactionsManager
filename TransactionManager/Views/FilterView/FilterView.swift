//
//  FilterView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-02.
//

import SwiftUI

struct FilterView: View {
    
    @ObservedObject var viewModel = FilterViewModel.shared
    @ObservedObject var personTransactionsViewModel = PersonTransactionsViewModel.shared
    @ObservedObject var transactionsViewModel = TransactionsViewModel.shared
    @ObservedObject var helper = Helper.shared
    @ObservedObject var currencyPickerModel = CurrencyPickerModel.shared
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    @State var showCategoryList = false
    @State var selectedCategory: CategoryModel?
    @State var selectedMonth: String = ""
    @State var selectedYear: String = ""
    @State var selectedRange: Double = 0.0
    
    var body: some View {
        VStack {
            header
            ScrollView {
                VStack(spacing: 0){
                    monthYearPickerView
                    sliderView
                    Group {
                        categoryView
                        if showCategoryList {
                            categoryListView
                        }
                    }.offset(y: -15)
                    saveButton
                        .padding(.top)
                    Spacer()
                    Spacer().frame(height: ScreenSize.safeBottom())
                }
                .padding(.horizontal)
            }
        }.ignoresSafeArea(.all)
            .background(Color.white)
            .onAppear(perform: {
                selectedMonth = viewModel.pubSelectedMonth
                selectedYear = viewModel.pubSelectedYear
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    withAnimation(.smooth, {
                        selectedRange = viewModel.pubSelectedRange
                        selectedCategory = viewModel.pubSelectedCategory
                    })
                    
                })
            })
    }
    
    var header: some View{
        VStack(spacing: 0){
            Spacer().frame(height: ScreenSize.safeTop())
            HStack{
                backButton
                Spacer()
                HStack {
                    Text("Filter").font(.system(size: 17)).bold().foregroundColor(Color.black)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2)
                Spacer()
                if viewModel.isShowClearButton(selectedMonth: selectedMonth, selectedYear: selectedYear, selectedCategory: selectedCategory, selectedRange: selectedRange){
                    clearButton
                } else {
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
            viewModel.pubShowFilterView = false
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
            let (month, year) = viewModel.currentMonthAndYear()
            withAnimation {
                selectedCategory = nil
                selectedRange = 0.0
                selectedMonth = month
                selectedYear = year
                viewModel.pubLastUpdated = Date().timeIntervalSince1970
            }
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
    
    var monthYearPickerView: some View {
        VStack {
            HStack {
                Text("Month and Year")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(.top)
            MonthYearPicker(selectedMonth: $selectedMonth, selectedYear: $selectedYear)
        }
    }
    
    var categoryView: some View {
        VStack{
            HStack {
                Text("Categories")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(.top, 20)
            if let category = selectedCategory {
                HStack {
                    Button(action: {
                        withAnimation {
                            showCategoryList.toggle()
                        }
                    }, label: {
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
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                    })
                    Button(action: {
                        withAnimation {
                            selectedCategory = nil
                        }
                    }, label: {
                        VStack {
                            Image(systemName: "trash.fill")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 20, height: 20)
                        }.foregroundColor(Color.white)
                            .frame(height: 80)
                            .padding(.horizontal)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.leading, 10)
                    })
                    
                    Spacer()
                }
            } else {
                HStack {
                    Button(action: {
                        withAnimation {
                            showCategoryList.toggle()
                        }
                    }, label: {
                        HStack(spacing: 20){
                            Image(systemName: "plus")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.leading)
                            
                            Text("Select Category").bold()
                                .frame(width: 75)
                                .lineLimit(2)
                            Spacer().frame(width: 10)
                        }
                        .foregroundColor(Color.black)
                        .frame(height: 80)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                    })
                    Spacer()
                }
            }
        }
    }
    
    var categoryListView: some View {
        VStack{
            ScrollView {
                Spacer().frame(height: 10)
                LazyVGrid(columns: columns){
                    ForEach(CategoryManager.shared.getCategories()){ item in
                        CategoryView(width: (ScreenSize.width()-40)/3, height: ((ScreenSize.width()-40)/3)+30, data: item)
                            .onTapGesture {
                                withAnimation {
                                    selectedCategory = item
                                    showCategoryList.toggle()
                                    viewModel.pubLastUpdated = Date().timeIntervalSince1970
                                }
                            }
                    }
                }
            }
        }
    }
    
    var sliderView: some View {
        VStack(spacing: 0){
            HStack {
                Text("Amount Range: \(Int(selectedRange))")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(.top, 20)
            Slider(value: $selectedRange, in: 0...viewModel.getUpperRangeForSlider(), step: 20)
                .padding(.bottom, 10)
            HStack{
                VStack(alignment: .leading){
                    Image(systemName: "arrowtriangle.up.fill")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color.black)
                    Text("\(helper.currencyCode)0")
                        .font(.system(size: 15, weight: .bold))
                }
                Spacer()
                VStack(alignment: .trailing){
                    Image(systemName: "arrowtriangle.up.fill")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color.black)
                    Text("\(helper.currencyCode)\(Int(viewModel.getUpperRangeForSlider()))")
                        .font(.system(size: 15, weight: .bold))
                }
            }
            .offset(y: -15)
        }
    }
    
    var saveButton: some View {
        Button(action: {
            viewModel.pubSelectedCategory = selectedCategory
            viewModel.pubSelectedMonth = selectedMonth
            viewModel.pubSelectedYear = selectedYear
            viewModel.pubSelectedRange = selectedRange
            if transactionsViewModel.pubShowListView {
                transactionsViewModel.filterTransactionsData()
            }
            if transactionsViewModel.pubShowIntListView {
            }
            if personTransactionsViewModel.pubShowPersonTransactionsList {
                personTransactionsViewModel.filterPersonData()
            }
            viewModel.pubShowFilterView = false
        }, label: {
            HStack {
                Spacer()
                Text("SAVE")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .padding()
            .background(Color.DarkBlue.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
        })
    }
}

#Preview {
    FilterView()
}

