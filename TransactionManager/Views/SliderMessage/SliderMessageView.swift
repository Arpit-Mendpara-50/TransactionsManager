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
    
    var body: some View {
        VStack{
            VStack(spacing: 0){
                Spacer().frame(height: ScreenSize.safeTop())
                HStack(spacing: 5){
                    Spacer()
                    Image(systemName: title == "Success" ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                        .frame(width: 25, height: 25)
                    Text(message)
                        .padding()
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                    Spacer().frame(width: 20, height: 20)
                    Spacer()
                }
                .padding(.bottom, 5)
                .padding(.horizontal, 10)
            }
            .frame(maxHeight: ScreenSize.safeTop() + 60)
            .background(title == "Success" ? Color.green : Color.red)
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 5)
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                withAnimation {
                    SliderMessageManager.shared.pubShowSliderMessageView = false
                }
            })
        }
        .onTapGesture {
            withAnimation {
                SliderMessageManager.shared.pubShowSliderMessageView = false
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    SliderMessageView(title: "Success", message: "Message")
}
