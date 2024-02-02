//
//  PeopleListView.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2024-01-31.
//

import SwiftUI

struct PeopleListView: View {
    var isSelectable: Bool
    @ObservedObject var peopleViewModel = PeopleViewModel.shared
    @ObservedObject var peopleManager = PeopleManager.shared
    @ObservedObject var sliderMessageManager = SliderMessageManager.shared
    @ObservedObject var personTransactionsViewModel = PersonTransactionsViewModel.shared
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    if !peopleViewModel.pubIsPeopleLoading {
                        ForEach(0..<peopleViewModel.pubPeopleData.count) { index in
                            PeopleView(id: peopleViewModel.pubPeopleData[index].id, title: peopleViewModel.pubPeopleData[index].personName, image: peopleViewModel.pubPeopleData[index].imagePath, amount: peopleViewModel.pubPeopleData[index].amount, color: Color.white, isAdd: false, isSelectable: isSelectable, onTap: {
                                if !isSelectable {
                                    personTransactionsViewModel.openPeronTransactionListView(person: peopleViewModel.pubPeopleData[index])
                                }
                            })
                        }
                    }
                    //MARK:  Default add button
                    PeopleView(id: 0, title: "Add new member", image: "", amount: "", color: Color.gray, isAdd: true, isSelectable: false) {
                        withAnimation {
                            peopleViewModel.pubShowPeopleCreationView.toggle()
                        }
                    }
                    
                }
                .padding(.horizontal, 5)
            }
            .frame(height: 130)
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
}

#Preview {
    PeopleListView(isSelectable: false)
}
