//
//  BlurView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-22.
//

import SwiftUI

struct BlurView: View {
    var opacity: Double = 0.7
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
            }
            Spacer()
        }
        .background(Color.black)
        .opacity(opacity)
    }
}

#Preview {
    BlurView()
}
