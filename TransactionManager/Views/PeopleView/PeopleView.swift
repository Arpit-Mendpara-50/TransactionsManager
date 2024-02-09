//
//  PeopleView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-21.
//

import SwiftUI

struct PeopleView: View {
    @ObservedObject var creationViewModel = CreationViewModel.shared
    var id: Int64
    var title: String
    var image: String
    var amount: String
    var color: Color
    var isAdd: Bool
    var isSelectable: Bool
    var onTap: (()->Void)?
    var body: some View {
        Button(action: {
            onTap?()
//            if isSelectable {
//                if creationViewModel.pubSelectedPeopleID.contains(id) {
//                    creationViewModel.pubSelectedPeopleID = creationViewModel.pubSelectedPeopleID.filter({$0 != id})
//                } else {
//                    creationViewModel.pubSelectedPeopleID.append(id)
//                }
//                print("people ID: \(CreationViewModel.shared.pubSelectedPeopleID)")
//            }
        }, label: {
            VStack{
                if isAdd {
                    Spacer()
                    Image(systemName: "person.fill.badge.plus")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color.white)
                    Spacer().frame(height: 5)
                    Text(title)
                        .bold()
                        .lineLimit(2)
                        .frame(height: 55)
                        .foregroundStyle(Color.white)
                    Spacer()
                } else {
                    ZStack {
                        VStack {
                            Spacer()
                            if let image = ImagePickerManager.shared.loadImageFromDocumentsDirectory(imageName: image) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            Spacer().frame(height: 15)
                            Text(title)
                                .bold()
                            Text(Helper.shared.currencyCode+amount)
                                .bold()
                            Spacer()
                        }
                        if isSelectable && creationViewModel.pubSelectedPeopleID.contains(id){
                            VStack {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .renderingMode(.template)
                                            .bold()
                                            .frame(width: 15, height: 15)
                                            .foregroundStyle(Color.white)
                                            .offset(x: -5, y: 5)
                                    }
                                    .frame(width: 50, height: 50)
                                    .background(Color.green)
                                    .clipShape(Circle())
                                    .offset(x: 12, y: -12)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .foregroundStyle(Color.black)
            .frame(width: 130, height: 130)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
            .padding(.vertical, 10)
        })
    }
}
