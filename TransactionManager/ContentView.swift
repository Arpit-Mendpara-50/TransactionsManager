//
//  ContentView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-01-06.
//

import SwiftUI

struct ContentView: View {
    @State var showView = false
    @State var categoryData: [CategoryModel] = []
    @ObservedObject var categoryManager = CategoryManager.shared
    var body: some View {
        ZStack{
            VStack {
                Button("Open View", action: {
                    withAnimation {
                        showView.toggle()
                    }
                })
                .padding(10)
                .foregroundColor(Color.white)
                .font(.system(size: 15, weight: .bold))
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            .padding()
            if showView{
                CategoryPickerView(data: self.categoryData, closeAction: {
                    withAnimation {
                        showView.toggle()
                    }
                }).offset(y: 200)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
