//
//  CategoryManager.swift
//  TransactionManager
//
//  Created by Arpit Mendpara on 2023-04-19.
//

import Foundation
import SQLite

class CategoryManager: ObservableObject {
    
    public static var shared: CategoryManager = {
        let mgr = CategoryManager()
        return mgr
    }()
    
    private var databaseManager = DatabaseManager.shared
    
    private var db: Connection?
    private var categories: Table?
    
    private var id: Expression<Int64>!
    private var icon: Expression<String>!
    private var title: Expression<String>!
    private var color: Expression<String>!
    private var priority: Expression<Int>!
    private var type: Expression<Int>!
    
    let data: [CategoryDataModel] = [
        .init(id: "0", name: "Food", imageName: "ic_food", color: "Orange", priority: 1, type: 0),
        .init(id: "1", name: "Clothes", imageName: "ic_clothes", color: "DarkGreen", priority: 2, type: 0),
        .init(id: "2", name: "Drug + Meds", imageName: "ic_pill", color: "GrayTint", priority: 3, type: 0),
        .init(id: "3", name: "Grocery", imageName: "ic_grocery", color: "DarkBlue", priority: 5, type: 0),
        .init(id: "4", name: "Gas", imageName: "ic_gas", color: "LightBlue", priority: 6, type: 0),
        .init(id: "5", name: "Shopping", imageName: "ic_shopping", color: "LightYellow", priority: 4, type: 0),
        .init(id: "6", name: "Dine-In", imageName: "ic_dineIn", color: "BlueTint", priority: 7, type: 0),
        .init(id: "7", name: "Rent", imageName: "ic_rent", color: "DarkBlue", priority: 10, type: 0),
        .init(id: "8", name: "Bills", imageName: "ic_bills", color: "LightYellow", priority: 9, type: 0),
        .init(id: "9", name: "Electronics", imageName: "ic_electronics", color: "DarkYellow", priority: 8, type: 0),
        .init(id: "10", name: "Other", imageName: "ic_other", color: "Pink", priority: 12, type: 2),
        .init(id: "11", name: "Salary", imageName: "ic_salary", color: "Orange", priority: 1, type: 1),
        .init(id: "12", name: "Bonus", imageName: "ic_bonus", color: "DarkGreen", priority: 2, type: 1),
        .init(id: "13", name: "Tax", imageName: "ic_tax", color: "GrayTint", priority: 11, type: 2)
        
    ]
    
    init(){
        do{
            db = databaseManager.createDBInstance()
            
            categories = Table("categories")
            
            id = Expression<Int64>("id")
            icon = Expression<String>("icon")
            title = Expression<String>("title")
            color = Expression<String>("color")
            priority = Expression<Int>("priority")
            type = Expression<Int>("type")
            
            if !UserDefaults.standard.bool(forKey: "is_categoryTable_created"){
                if let db = db, let categories = categories{
                    try db.run(categories.create(block: { table in
                        table.column(id, primaryKey: true)
                        table.column(icon)
                        table.column(title)
                        table.column(color)
                        table.column(priority)
                        table.column(type)
                    }))
                    
                    prepareCategory()
                    UserDefaults.standard.set(true, forKey: "is_categoryTable_created")
                }
            }
            
        }catch{
            print(error.localizedDescription)
        }
        
        
    }
    
    public func prepareCategory(){
        for item in data {
            self.addCategory(iconValue: item.imageName, nameValue: item.name, colorValue: item.color, priorityValue: item.priority, typeValue: item.type)
        }
    }
    
    public func addCategory(iconValue: String, nameValue: String, colorValue: String, priorityValue: Int, typeValue: Int){
        if let db = db, let categories = categories{
            do{
                try db.run(categories.insert(icon <- iconValue, title <- nameValue, color <- colorValue, priority <- priorityValue, type <- typeValue))
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    public func getCategories() -> [CategoryModel]{
        var categoriesArray: [CategoryModel] = []
        if let db = db, var categories = categories{
            categories = categories.order(id.asc)
            do{
                for category in try db.prepare(categories){
                    let categoryData: CategoryModel = CategoryModel()
                    
                    categoryData.id = category[id]
                    categoryData.icon = category[icon]
                    categoryData.title = category[title]
                    categoryData.color = category[color]
                    categoryData.priority = category[priority]
                    categoryData.type = category[type]
                    
                    categoriesArray.append(categoryData)
                }
            } catch{
                print(error.localizedDescription)
            }
            
            return categoriesArray
        }else{
            return []
        }
    }
    
    public func getCategory(idValue: Int64) -> CategoryModel{
        let categoryData: CategoryModel = CategoryModel()
        if let db = db, let categories = categories{
            do{
                let category: AnySequence<Row> = try db.prepare(categories.filter(id == idValue))
                
                try category.forEach({ rowValue in
                    
                    categoryData.id = try rowValue.get(id)
                    categoryData.icon = try rowValue.get(icon)
                    categoryData.title = try rowValue.get(title)
                    categoryData.color = try rowValue.get(color)
                    categoryData.priority = try rowValue.get(priority)
                    categoryData.type = try rowValue.get(type)
                    
                })
            }catch{
                print(error.localizedDescription)
            }
            
            return categoryData
        }else{
            return categoryData
        }
    }
    
    public func updateCategory(idValue: Int64, iconValue: String, titleValue: String, colorValue: String, priorityValue: Int, typeValue: Int){
        if let db = db, let categories = categories{
            do{
                let category: Table = categories.filter(id == idValue)
                
                try db.run(category.update(icon <- iconValue, title <- titleValue, color <- colorValue, priority <- priorityValue, type <- typeValue))
            }catch{
                print(error.localizedDescription)
            }
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
}
