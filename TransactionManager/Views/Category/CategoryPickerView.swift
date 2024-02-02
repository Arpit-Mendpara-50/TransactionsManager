//
//  PickerView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-01-07.
//

import SwiftUI

struct CategoryPickerView: View {
    var data: [CategoryModel] = []
    var closeAction: (() -> Void)? = nil
    var onCategorySelected: ((CategoryModel) -> Void)? = nil
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                VStack{
                    HStack{
                        Spacer()
                        VStack{
                            Image(systemName: "xmark")
                                .bold()
                                .frame(width: 20, height: 20)
                            Spacer().frame(height: 10)
                        }
                        .frame(width: 20, height: 30)
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            closeAction?()
                        }
                        Spacer().frame(width: 20)
                        
                    }
                }
                .offset(y: 10)
                .zIndex(1)
                VStack{
                    ScrollView {
                        Spacer().frame(height: 10)
                        LazyVGrid(columns: columns){
                            ForEach(data){ item in
                                CategoryView(width: (ScreenSize.width()-40)/3, height: ((ScreenSize.width()-40)/3)+30, data: item)
                                    .onTapGesture {
                                        onCategorySelected?(item)
                                    }
                            }
                        }
                        Spacer().frame(height: 270)
                    }.padding(.horizontal, 10)
                        .padding(.top, 10)
                }
                .frame(width: ScreenSize.width())
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .background(Color.PrimaryColor)
                .shadow(radius: 3)
                .zIndex(2)
                
            }
            VStack{
                Spacer()
                Button("Select", action: {
                    
                })
                .padding(.all)
                .frame(width: ScreenSize.width() - 60, height: 50)
                .foregroundColor(Color.white)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(radius: 5)
            }.zIndex(3)
        }
        .frame(width: ScreenSize.width())
        .background(Color.white)
    }
    
    
}

struct CategoryView: View{
    let width: CGFloat
    let height: CGFloat
    let data: CategoryModel
    
    var body: some View{
        VStack{
            Image(data.icon)
                .renderingMode(.template)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.white)
            Spacer().frame(height: 20)
            Text(data.title)
                .font(.system(size: 15).bold())
                .foregroundColor(Color.white)
            Spacer().frame(height: 10)
        }.frame(width: width, height: height)
            .background(Color(UIColor(named: data.color) ?? UIColor.black))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
    }
}

struct CategoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPickerView()
    }
}
