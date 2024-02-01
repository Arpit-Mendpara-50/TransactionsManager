//
//  SliderMessageView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-30.
//

import SwiftUI

struct SliderMessageView: View {
    var title: String
    var message: String
    var closeAction: (() -> Void)? = nil
    var body: some View {
        VStack{
            VStack(spacing: 10){
                Spacer().frame(height: ScreenSize.safeTop())
                HStack {
                    Spacer()
                    Text(message)
                        .padding()
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }
            }
            .background(title == "Success" ? Color.green : Color.red)
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 5)
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                withAnimation {
                    closeAction?()
                }
            })
        }
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    SliderMessageView(title: "Success", message: "{Person} is added to People")
}
