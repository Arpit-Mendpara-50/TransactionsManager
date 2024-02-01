//
//  IntTransactionsListView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-26.
//

import SwiftUI

struct IntTransactionsListView: View {

    @Binding var isShowView: Bool
    
    @ObservedObject var creationManager = CreationManager.shared
    @ObservedObject var viewModel = TransactionsViewModel.shared
    
    var body: some View {
        VStack{
            header
            VStack{
                    if !viewModel.pubIntTransactionsSectionData.isEmpty {
                        ScrollView{
                            ForEach(0..<viewModel.pubIntTransactionsSectionData.count) { index in
                                IntTransactionSectionView(dateText: viewModel.pubIntTransactionsSectionData[index].date, transactionData: viewModel.pubIntTransactionsSectionData[index].data)
                            }
                        }
                    } else {
                        Spacer()
                        Text("No data found")
                        Spacer()
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.white)
    }
    
    var header: some View{
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
            isShowView = false
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

