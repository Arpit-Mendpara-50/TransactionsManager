//
//  RowView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-04-12.
//

import SwiftUI

struct RowView: View {
    
    @State var isRowOpen = false
    var title: String
    var subtitle: String
    var isDirect: Bool
    var onShowList: (()->Void)?
    var onAdd: (()->Void)?
    
    var body: some View {
        HStack(spacing: 0){
            Button(action: {
                withAnimation {
                    if isDirect {
                        onShowList?()
                    } else {
                        isRowOpen.toggle()
                    }
                }
            }, label: {
                HStack{
                    if isRowOpen{
                        Image(systemName: "xmark")
                            .bold()
                            .foregroundColor(Color.white)
                            .frame(width: 20, height: 20)
                            .padding()
                    }else{
                        VStack{
                            HStack{
                                Text(title)
                                    .font(.system(size: 20).bold())
                                Spacer()
                            }
                            HStack{
                                Text(subtitle)
                                    .font(.system(size: 17).bold())
                                Spacer()
                            }
                        }
                        .foregroundColor(Color.white)
                        .padding(.leading)
                        Spacer()
                        
                    }
                }
                .frame(width: isRowOpen ? 50 : ScreenSize.width()-40, height: 100)
                .background(Color.LightRed)
            })
            Button(action: {
                withAnimation {
                    onShowList?()
                    //                    isRowOpen.toggle()
                }
            }, label: {
                HStack(spacing: 10){
                    Spacer()
                    if isRowOpen{
                        Image(systemName: "list.bullet.rectangle.portrait")
                            .renderingMode(.template)
                            .foregroundColor(Color.white)
                    }
                    Text("Show")
                        .foregroundColor(Color.white)
                        .font(.system(size: 17).bold())
                    Spacer()
                    
                    
                }
                .frame(width: isRowOpen ? (ScreenSize.width()-90)/2 : 0, height: 100)
                .background(Color.BlueTint)
            })
            Button(action: {
                withAnimation {
                    //                    isRowOpen.toggle()
                    onAdd?()
                }
            }, label: {
                HStack(spacing: 10){
                    Spacer()
                    if isRowOpen{
                        Image(systemName: "plus")
                            .renderingMode(.template)
                            .foregroundColor(Color.white)
                    }
                    
                    Text("Add")
                        .foregroundColor(Color.white)
                        .font(.system(size: 17).bold())
                    Spacer()
                    
                    
                }
                .frame(width: isRowOpen ? (ScreenSize.width()-90)/2 : 0, height: 100)
                .background(Color.LightGreen)
            })
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 2)
        .padding()
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(title: "", subtitle: "", isDirect: false)
    }
}
