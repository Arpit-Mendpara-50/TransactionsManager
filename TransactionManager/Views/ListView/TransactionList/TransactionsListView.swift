//
//  TransactionsListView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-05-29.
//

import SwiftUI

struct TransactionsListView: View {

    @ObservedObject var creationManager = CreationManager.shared
    @ObservedObject var viewModel = TransactionsViewModel.shared
    
    var body: some View {
        VStack{
            header
            if !viewModel.pubIsTransactionsLoading {
                InlineFilterView()
                VStack{
                    if !viewModel.pubTransactionsSectionData.isEmpty {
                        ScrollView{
                            ForEach(0..<viewModel.pubTransactionsSectionData.count, id: \.self) { index in
                                TransactionSectionView(dateText: viewModel.pubTransactionsSectionData[index].date, transactionData: viewModel.pubTransactionsSectionData[index].data)
                            }
                        }
                    } else {
                        Spacer()
                        Image("ic_nodata")
                            .resizable()
                            .frame(width: 200, height: 200)
                        Text("No data found")
                            .font(.system(size: 25, weight: .bold))
                            .padding(.top)
                        Spacer()
                        Spacer().frame(height: 60+ScreenSize.safeTop())
                    }
                }
                Spacer()
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
        .edgesIgnoringSafeArea(.all)
        .background(Color.BackgroundColor)
    }
    
    var header: some View{
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
                Spacer().frame(width: 35)
            }
            .padding(.horizontal)
        }
        .frame(height: 60+ScreenSize.safeTop())
        .background(Color.DarkBlue)
        .shadow(radius: 5)
        
    }
    
    var backButton: some View{
        Button(action: {
            viewModel.pubShowListView = false
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
}
