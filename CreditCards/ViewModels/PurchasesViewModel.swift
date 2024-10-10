//
//  CardsViewModel.swift
//  CreditCards
//
//  Created by Marcos Manzo.
//

import Foundation
import CoreData

class PurchasesViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var price = ""
    
    func savePurchase(context: NSManagedObjectContext, card: Cards, completion: @escaping (_ done: Bool) -> Void ){
        let newPurchases = Purchases(context: context)
        newPurchases.id = UUID()
        newPurchases.idCard = card.id
        newPurchases.name = name
        newPurchases.price = Int16(price) ?? 0
        newPurchases.date = Date()
        
        card.mutableSetValue(forKey: "relationToPurchases").add(newPurchases)
        
        do{
            try context.save()
            print("guardo compra")
            completion(true)
        }catch let error as NSError {
            print("fallo la campra", error.localizedDescription)
            completion(false)
        }
        
    }
    
    func deletePurchase(item: Purchases, context: NSManagedObjectContext){
        context.delete(item)
        do{
            try context.save()
            print("elimino compra")
            
        }catch let error as NSError {
            print("fallo la eliminacion", error.localizedDescription)
           
        }
        
    }
    
    
}
