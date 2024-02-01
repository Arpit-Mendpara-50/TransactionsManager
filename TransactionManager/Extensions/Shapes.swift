//
//  Shapes.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-04-12.
//

import SwiftUI


struct Line: View {
    var padding: CGFloat
    var body: some View{
            HStack{
                Spacer()
            }.frame(height: 1)
                .background(Color.LightGray)
                .padding(.leading, padding)
    }
}
