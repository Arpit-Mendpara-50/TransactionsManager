//
//  PersonTransactionsList.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-02.
//

import SwiftUI

struct PersonTransactionsList: View {
    
    @ObservedObject var viewModel = PersonTransactionsViewModel.shared
    @ObservedObject var transactionsViewModel = TransactionsViewModel.shared
    @State var selectedMonth: String = ""
    @State var selectedYear: Int = 0
    
    var body: some View {
        let person = viewModel.pubSelectedPerson ?? PeopleViewModel.shared.pubPeopleData[0]
        return VStack {
            header
            VStack {
                HStack {
                    if let image = ImagePickerManager.shared.loadImageFromDocumentsDirectory(imageName: person.imagePath) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading){
                        Text(person.personName).font(.system(size: 22)).bold().foregroundColor(Color.black)
                        Text("$\(person.amount)").font(.system(size: 16)).bold().foregroundColor(Color.gray)
                    }
                    Spacer()
                }
                .padding(.leading)
                Line(padding: 0)
//                HStack{
//                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                    Text("\(selectedMonth), \(selectedYear)")
//                    Spacer()
//                    MonthYearPicker(selectedMonth: $selectedMonth, selectedYear: $selectedYear)
//                }
                listView
            }
        }
        .ignoresSafeArea(.all)
        .background(Color.white)
    }
    
    var header: some View{
        VStack(spacing: 0){
            Spacer().frame(height: ScreenSize.safeTop())
            HStack{
                backButton
                Spacer()
                HStack {
                    Text("Transactions").font(.system(size: 17)).bold().foregroundColor(Color.black)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 2)
                Spacer()
                Spacer().frame(width: 35)
            }
            .padding(.horizontal)
        }
        .frame(height: 60+ScreenSize.safeTop())
        .background(Color.gray)
        .shadow(radius: 5)
        
    }
    
    var backButton: some View{
        Button(action: {
            viewModel.pubSelectedPerson = nil
            viewModel.pubShowPersonTransactionsList = false
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
    
    var listView: some View {
        VStack{
            if !viewModel.pubIsLoading {
                if !transactionsViewModel.pubTransactionsSectionData.isEmpty {
                    ScrollView{
                        ForEach(0..<transactionsViewModel.pubTransactionsSectionData.count) { index in
                            TransactionSectionView(dateText: transactionsViewModel.pubTransactionsSectionData[index].date, transactionData: transactionsViewModel.pubTransactionsSectionData[index].data)
                        }
                    }
                } else {
                    Text("No data found")
                    Spacer()
                }
            } else {
                Text("Loading...")
                Spacer()
            }
        }
    }
}

#Preview {
    PersonTransactionsList()
}
