//
//  MultiCurrencyView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-02-05.
//

import SwiftUI

struct MultiCurrencyView: View {
    var flags: [String]
    var body: some View {
        VStack {
            HStack(spacing: 0){
                ForEach(0..<flags.count, id: \.self){ index in
                    Image(flags[index])
                        .resizable()
                        .frame(width: 30, height: 30)
                        .offset(x: -CGFloat((index*15)))
                        .shadow(radius: 2)
                }
            }
        }
    }
}

#Preview {
    MultiCurrencyView(flags: [])
}
