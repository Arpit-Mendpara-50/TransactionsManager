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
                .background(Color.TextColor)
                .padding(.leading, padding)
    }
}

struct VLine: View {
    var body: some View{
            VStack{
                Spacer()
            }.frame(width: 1)
            .background(Color.TextColor)
    }
}
