//
//  EntityModels.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-04-19.
//

import Foundation
import SwiftUI

class CategoryModel: Identifiable{
    public var id: Int64 = 0
    public var icon: String = ""
    public var title: String = ""
    public var color: String = ""
    public var priority: Int = 0
    public var type: Int = 0
}

struct CategoryDataModel: Identifiable {
    let id: String
    let name: String
    let imageName: String
    let color: String
    let priority: Int
    let type: Int // 0-expense, 1-income, 3-both
}

class TransactionsModel: Identifiable {
    public var id: Int64 = 0
    public var title: String = ""
    public var amount: String = ""
    public var category: CategoryModel?
    public var description: String = ""
    public var transactionType: Int = 0 // 0-expense, 1-income, 3-both
    public var peopleIncluded: String = ""
    public var createdDate: String = ""
    public var updatedDate: String = ""
}

struct TransactionSectionData: Identifiable {
    public var id: Int64 = 0
    public var date: String
    public var data: [TransactionsModel]
}

struct TransactionsDataModel: Identifiable {
    let id: String
    let title: String
    let amount: String
    let category: Int64
    let transactionType: Int // 0-expense, 1-income, 3-both
    let createdDate: String
    let updatedDate: String
}

class PeopleModel: Identifiable {
    public var id: Int64 = 0
    public var personName: String = ""
    public var imagePath: String = ""
    public var amount: String = ""
    public var createdDate: String = ""
    public var updatedDate: String = ""
}

class InternationalTransactionsModel: Identifiable {
    public var id: Int64 = 0
    public var title: String = ""
    public var baseAmount: String = ""
    public var conversionAmount: String = ""
    public var description: String = ""
    public var createdDate: String = ""
    public var updatedDate: String = ""
}

struct IntTransactionSectionData: Identifiable {
    public var id: Int64 = 0
    public var date: String
    public var data: [InternationalTransactionsModel]
}
