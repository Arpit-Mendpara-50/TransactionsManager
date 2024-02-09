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
    @ObservedObject var creationViewModel = CreationViewModel.shared
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    ForEach(0..<peopleViewModel.pubPeopleData.count, id: \.self) { index in
                        PeopleView(id: peopleViewModel.pubPeopleData[index].id, title: peopleViewModel.pubPeopleData[index].personName, image: peopleViewModel.pubPeopleData[index].imagePath, amount: peopleViewModel.extractPersonAmount(amountString: peopleViewModel.pubPeopleData[index].amount), color: Color.white, isAdd: false, isSelectable: isSelectable, onTap: {
                            let id = peopleViewModel.pubPeopleData[index].id
                            if !isSelectable {
                                personTransactionsViewModel.openPeronTransactionListView(person: peopleViewModel.pubPeopleData[index])
                            } else {
                                if creationViewModel.pubSelectedPeopleID.contains(id) {
                                    creationViewModel.pubSelectedPeopleID = creationViewModel.pubSelectedPeopleID.filter({$0 != id})
                                } else {
                                    creationViewModel.pubSelectedPeopleID.append(id)
                                }
                            }
                        })
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
