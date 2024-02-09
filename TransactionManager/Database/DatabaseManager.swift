//
//  DatabaseManager.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-04-19.
//

import Foundation
import SQLite


class DatabaseManager: ObservableObject {
    public static var shared: DatabaseManager = {
        let mgr = DatabaseManager()
        mgr.checkAndCreatePeopleTable()
        mgr.checkAndCreateTransactionsTable()
        mgr.checkAndCreateIntTransactionTable()
        return mgr
    }()
    
//    private var db: Connection!
    public var db: Connection?
    
    //MARK: Transactions table
    public var transactions: Table?
    public var transactionId: Expression<Int64>!
    public var transactionTitle: Expression<String>!
    public var transactionAmount: Expression<String>!
    public var transactionCategory: Expression<Int64>!
    public var transactionDescription: Expression<String>!
    public var transactionType: Expression<Int>!
    public var transactionCurrencyType: Expression<Int>!
    public var peopleIncluded: Expression<String>!
    public var transactionCreatedDate: Expression<String>!
    public var transactionUpdatedDate: Expression<String>!
    
    //MARK: People table
    public var people: Table?
    public var personId: Expression<Int64>!
    public var personName: Expression<String>!
    public var personImage: Expression<String>!
    public var personAmount: Expression<String>!
    public var personCreatedDate: Expression<String>!
    public var personUpdatedDate: Expression<String>!
    
    //MARK: International Transactions table
    public var internationalTransactions: Table?
    public var intTransactionId: Expression<Int64>!
    public var intTransactionTitle: Expression<String>!
    public var intTransactionBaseamount: Expression<String>!
    public var intTransactionConversionAmount: Expression<String>!
    public var intTransactionDescription: Expression<String>!
    public var intTransactionBaseCurrencyType: Expression<Int>!
    public var intTransactionConversionCurrencyType: Expression<Int>!
    public var intTransactionCreatedDate: Expression<String>!
    public var intTransactionUpdatedDate: Expression<String>!
    
    func createDBInstance() -> Connection?{
        do{
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            db = try Connection("\(path)/my_users.sqlite3")
            UserDefaults.standard.set(true, forKey: "is_db_created")
            return db
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    
    func checkAndCreateTransactionsTable(){
        
        do{
            db = self.createDBInstance()
            
            transactions = Table("transactions")
            
            transactionId = Expression<Int64>("transactionId")
            transactionTitle = Expression<String>("transactionTitle")
            transactionAmount = Expression<String>("transactionAmount")
            transactionCategory = Expression<Int64>("transactionCategory")
            transactionDescription = Expression<String>("transactionDescription")
            transactionType = Expression<Int>("transactionType")
            transactionCurrencyType = Expression<Int>("transactionCurrencyType")
            peopleIncluded = Expression<String>("peopleIncluded")
            transactionCreatedDate = Expression<String>("transactionCreatedDate")
            transactionUpdatedDate = Expression<String>("transactionUpdatedDate")
            
            if !UserDefaults.standard.bool(forKey: "is_transactionsTable_created"){
                if let db = db, let transactions = transactions{
                    try db.run(transactions.create(block: { table in
                        table.column(transactionId, primaryKey: true)
                        table.column(transactionTitle)
                        table.column(transactionAmount)
                        table.column(transactionCategory)
                        table.column(transactionDescription)
                        table.column(transactionType)
                        table.column(transactionCurrencyType)
                        table.column(peopleIncluded)
                        table.column(transactionCreatedDate)
                        table.column(transactionUpdatedDate)
                    }))
                    UserDefaults.standard.set(true, forKey: "is_transactionsTable_created")
                }
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func checkAndCreatePeopleTable(){
        
        do{
            db = self.createDBInstance()
            
            people = Table("people")
            
            personId = Expression<Int64>("personId")
            personName = Expression<String>("personName")
            personImage = Expression<String>("personImage")
            personAmount = Expression<String>("personAmount")
            personCreatedDate = Expression<String>("personCreatedDate")
            personUpdatedDate = Expression<String>("personUpdatedDate")
            
            if !UserDefaults.standard.bool(forKey: "is_peopleTable_created"){
                if let db = db, let transactions = people{
                    try db.run(transactions.create(block: { table in
                        table.column(personId, primaryKey: true)
                        table.column(personName)
                        table.column(personImage)
                        table.column(personAmount)
                        table.column(personCreatedDate)
                        table.column(personUpdatedDate)
                    }))
                    UserDefaults.standard.set(true, forKey: "is_peopleTable_created")
                }
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func checkAndCreateIntTransactionTable(){
        
        do{
            db = self.createDBInstance()
            
            internationalTransactions = Table("internationalTransactions")
            
            intTransactionId = Expression<Int64>("intTransactionId")
            intTransactionTitle = Expression<String>("intTransactionTitle")
            intTransactionBaseamount = Expression<String>("intTransactionBaseamount")
            intTransactionConversionAmount = Expression<String>("intTransactionConversionAmount")
            intTransactionDescription = Expression<String>("intTransactionDescription")
            intTransactionBaseCurrencyType = Expression<Int>("intTransactionBaseCurrencyType")
            intTransactionConversionCurrencyType = Expression<Int>("intTransactionConversionCurrencyType")
            intTransactionCreatedDate = Expression<String>("intTransactionCreatedDate")
            intTransactionUpdatedDate = Expression<String>("intTransactionUpdatedDate")
            
            if !UserDefaults.standard.bool(forKey: "is_internationalTransactionsTable_created"){
                if let db = db, let transactions = internationalTransactions{
                    try db.run(transactions.create(block: { table in
                        table.column(intTransactionId, primaryKey: true)
                        table.column(intTransactionTitle)
                        table.column(intTransactionBaseamount)
                        table.column(intTransactionConversionAmount)
                        table.column(intTransactionDescription)
                        table.column(intTransactionBaseCurrencyType)
                        table.column(intTransactionConversionCurrencyType)
                        table.column(intTransactionCreatedDate)
                        table.column(intTransactionUpdatedDate)
                    }))
                    UserDefaults.standard.set(true, forKey: "is_internationalTransactionsTable_created")
                }
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func deleteTransaction(idValue: Int64, completionHandler: @escaping (String, String) -> Void) {
            do{
                if let db = db, let transactions = transactions {
                    let transaction: Table = transactions.filter(transactionId == idValue)
                    try db.run(transaction.delete())
                    DispatchQueue.main.async {
                        completionHandler("Success", "Successfully deleted transaction")
                    }
                }
            }catch{
                print(error.localizedDescription)
                completionHandler("Failed", "Failed tp delete transaction")
            }
    }
}



/*class DatabaseManager{
    private var db: Connection!
    private var categories: Table!
    
    public var id: Expression<Int64>!
    public var icon: Expression<String>!
    public var title: Expression<String>!
    public var color: Expression<String>!
    
    init(){
        do{
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            
            db = try Connection("\(path)/my_users.sqlite3")
            
            categories = Table("categories")
            
            id = Expression<Int64>("id")
            icon = Expression<String>("icon")
            title = Expression<String>("title")
            color = Expression<String>("color")
            
            if !UserDefaults.standard.bool(forKey: "is_db_created"){
                try db.run(categories.create(block: { table in
                    table.column(id, primaryKey: true)
                    table.column(icon)
                    table.column(title)
                    table.column(color)
                }))
                
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    public func addCategory(iconValue: String, nameValue: String,  colorValue: String){
        do{
            try db.run(categories.insert(icon <- iconValue, title <- nameValue, color <- colorValue))
        }catch{
            print(error.localizedDescription)
        }
    }
    
    public func getCategories() -> [CategoryModel]{
        var categoriesArray: [CategoryModel] = []
        
        categories = categories.order(id.desc)
        
        do{
            for category in try db.prepare(categories){
                let categoryData: CategoryModel = CategoryModel()
                
                categoryData.id = category[id]
                categoryData.icon = category[icon]
                categoryData.title = category[title]
                categoryData.color = category[color]
                
                categoriesArray.append(categoryData)
            }
        } catch{
            print(error.localizedDescription)
        }
        
        return categoriesArray
    }
    
    public func getCategory(idValue: Int64) -> CategoryModel{
        let categoryData: CategoryModel = CategoryModel()
        do{
            let category: AnySequence<Row> = try db.prepare(categories.filter(id == idValue))
            
            try category.forEach({ rowValue in
                
                categoryData.id = try rowValue.get(id)
                categoryData.icon = try rowValue.get(icon)
                categoryData.title = try rowValue.get(title)
                categoryData.color = try rowValue.get(color)
                
            })
        }catch{
            print(error.localizedDescription)
        }
        
        return categoryData
    }
    
    public func updateCategory(idValue: Int64, iconValue: String, titleValue: String, colorValue: String){
        do{
            let category: Table = categories.filter(id == idValue)
            
            try db.run(category.update(icon <- iconValue, title <- titleValue, color <- colorValue))
        }catch{
            print(error.localizedDescription)
        }
    }
    
    public func deleteCategory(idValue: Int64){
//        do{
//            let category: Table = categories.filter(id == idValue)
//
//            try db.run(category.delete())
//        }catch{
//            print(error.localizedDescription)
//        }
    }
}*/
