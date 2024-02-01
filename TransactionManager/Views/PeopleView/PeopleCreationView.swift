//
//  PeopleCreationView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-22.
//

import SwiftUI

struct PeopleCreationView: View {
    
    var closeAction: ((String, String, Bool) -> Void)? = nil
    @ObservedObject var imagePickerManager = ImagePickerManager.shared
    @ObservedObject var model = PeopleViewModel.shared
    @ObservedObject var peopleManager = PeopleManager.shared
    
    var body: some View {
        VStack(spacing: 0){
            Spacer().frame(height: 20)
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        Image(systemName: "pencil.slash")
                            .frame(width: 20, height: 20)
                        Spacer().frame(height: 10)
                    }
                    .frame(width: 20, height: 30)
                    .foregroundColor(Color.white)
                    .padding(10)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        closeAction?("", "", false)
                    }
                    Spacer().frame(width: 20)
                    
                }
            }
            .offset(y: 10)
            .zIndex(1)
            VStack(spacing: 20){
                Button(action: {
                    imagePickerManager.isImagePickerPresented.toggle()
                }, label: {
                    VStack {
                        if let image = imagePickerManager.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                        } else {
                            Image(systemName: "person.fill.badge.plus")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(Color.black)
                                .offset(x: 5)
                        }
                    }
                    .frame(width: 120, height: 120)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                }).sheet(isPresented: $imagePickerManager.isImagePickerPresented, onDismiss: imagePickerManager.loadImage) {
                    ImagePicker(image: $imagePickerManager.selectedImage, imageName: $imagePickerManager.selectedImageName).ignoresSafeArea()
                }
                
                HStack {
                    TextField("", text: $model.personName)
                        .frame(height: 50)
                        .padding(.leading, 10)
                }
                .frame(height: 50)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .padding(.horizontal)
                
                Button(action: {
                    if let selectedImage = imagePickerManager.selectedImage {
                        imagePickerManager.saveImageToDocumentsDirectory(image: selectedImage)
                        if let selectedImageName = imagePickerManager.selectedImageName {
                            peopleManager.addPerson(nameValue: model.personName, imageValue: selectedImageName, amountValue: "0.0", createdDateValue: Date().ISO8601Format(), updatedDateValue: Date().ISO8601Format())
                            peopleManager.getPeopleList()
                            closeAction?("Success", "\(model.personName) is Added to People", true)
                            model.clearPeopleForms()
                        }
                    }
                }, label: {
                    HStack(spacing: 10){
                        Spacer()
                        Text("Save")
                            .bold()
                            .foregroundColor(Color.white)
                        Image(systemName: "checkmark")
                            .renderingMode(.template)
                            .foregroundColor(Color.white)
                            .bold()
                        Spacer()
                    }
                    .frame(height: 50, alignment: .center)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 3)
                    .padding(.horizontal)
                })
                Spacer().frame(height: 30)
            }
            .frame(height: 350)
            .background(Color.PrimaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3)
            .zIndex(2)
        }
    }
}