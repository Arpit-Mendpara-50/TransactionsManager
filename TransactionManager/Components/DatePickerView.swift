//
//  DatePickerView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-05-31.
//

import SwiftUI

struct DatePickerView: View {
    @State private var selectedDate = Date()
    var closeAction: ((Date) -> Void)? = nil
    
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                VStack{
                    HStack{
                        Spacer()
                        VStack{
                            HStack{
                                Text("Select")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color.white)
                                Image("checkmark")
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(Color.white)
                                    .frame(width: 23, height: 23)
                            }
                            Spacer().frame(height: 10)
                        }
                        .frame(width: 80, height: 30)
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            closeAction?(selectedDate)
                        }
                        Spacer().frame(width: 20)
                        
                    }
                }
                .offset(y: 10)
                .zIndex(1)
                VStack{
                    VStack(spacing: 0){
                        DatePicker("Select a Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .padding()
//                            .onChange(of: selectedDate) { date in
//                                closeAction?(date)
//                            }
                        Spacer()
                    }
                    .background(Color.PrimaryColor)
                }
                .frame(width: ScreenSize.width())
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .background(Color.PrimaryColor)
                .shadow(radius: 3)
                .zIndex(2)
            }
        }
        .frame(width: ScreenSize.width())
        .background(Color.white)
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

extension Date {
    func toStringDate() -> String {
        var stringDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, YYYY" // dd MMMM, YYY - hh:mm a
        stringDate = dateFormatter.string(from: self)
        return stringDate
    }
}

extension String {
    func convertDateString() -> String {
        let dateFormats = ["yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ss"]
        let inputFormatter = DateFormatter()
        for format in dateFormats {
            inputFormatter.dateFormat = format
            if let date = inputFormatter.date(from: self) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "dd MMMM, YYYY"
                let formattedDate = outputFormatter.string(from: date)
                return formattedDate
            }
        }
        return "Unknown"
    }
    
    func convertDate() -> Date {
        let dateFormats = ["yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ss"]
        let inputFormatter = DateFormatter()
        for format in dateFormats {
            inputFormatter.dateFormat = format
            if let date = inputFormatter.date(from: self) {
                return date
            }
        }
        return Date()
    }
}
