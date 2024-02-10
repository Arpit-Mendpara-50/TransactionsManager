//
//  PeopleCreationView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-22.
//

import SwiftUI

struct PeopleCreationView: View {
    
    @ObservedObject var imagePickerManager = ImagePickerManager.shared
    @ObservedObject var model = PeopleViewModel.shared
    @ObservedObject var peopleManager = PeopleManager.shared
    @ObservedObject var sliderMessageManager = SliderMessageManager.shared
    @ObservedObject var helper = Helper.shared
    
    var body: some View {
        VStack(spacing: 0){
            Spacer().frame(height: 20)
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
                        withAnimation {
                            model.pubShowPeopleCreationView = false
                        }
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
                    TextField("", text: $model.personName, onEditingChanged: { changed in
                        if changed {
                            helper.setupKeyboardObserving()
                        }
                    })
                        .frame(height: 50)
                        .padding(.leading, 10)
                }
                .frame(height: 50)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .padding(.horizontal)
                
                Button(action: {
                    let validInput = model.checkValidInputs()
                    if let selectedImage = imagePickerManager.selectedImage, validInput.isEmpty {
                        imagePickerManager.saveImageToDocumentsDirectory(image: selectedImage)
                        if let selectedImageName = imagePickerManager.selectedImageName {
                            peopleManager.addPerson(nameValue: model.personName, imageValue: selectedImageName, amountValue: "0.0", createdDateValue: Date().ISO8601Format(), updatedDateValue: Date().ISO8601Format(), completionHandler: { title, message in
                                peopleManager.getPeopleList()
                                model.pubShowPeopleCreationView = false
                                sliderMessageManager.pubSliderTitle = title
                                sliderMessageManager.pubSliderMessage = message
                                withAnimation {
                                    sliderMessageManager.pubShowSliderMessageView = true
                                }
                                if title == "Success" {
                                    model.clearPeopleForms()
                                }
                                model.pubLastUpdated = Date().timeIntervalSince1970
                            })
                        }
                    } else {
                        sliderMessageManager.pubSliderTitle = "Failed"
                        sliderMessageManager.pubSliderMessage = validInput
                        withAnimation {
                            sliderMessageManager.pubShowSliderMessageView = true
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
                    .background(Color.DarkBlue)
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
