//
//  CardsViewModel.swift
//  CreditCards
//
//  Created by Marcos Manzo.
//

import SwiftUI

struct PurchaseView: View {
    
    var card : Cards
    @State private var addPurchase = false
    @Environment(\.managedObjectContext) private var context
    @State private var total : Int16 = 0
    @State private var resto : Int16 = 0
    
    @StateObject var purchase = PurchasesViewModel()
    
    var purchases : FetchRequest<Purchases>
    init(card : Cards){
        self.card = card
        purchases = FetchRequest<Purchases>(entity: Purchases.entity(), sortDescriptors:[NSSortDescriptor(key: "date", ascending: true)], predicate: NSPredicate(format: "idCard == %@", card.id! as CVarArg)  )
    }
    
    var body: some View {
        VStack{
            List{
                ForEach(purchases.wrappedValue){ item in
                    Grid(alignment: .leading){
                        GridRow{
                            Text(item.name ?? "")
                            Spacer()
                            Text("$\(item.price)")
                                .foregroundColor(.gray)
                        }
                        Text(item.date?.formatted(.dateTime.day().month().year()) ?? "")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }.onDelete { IndexSet in
                    let delete = purchases.wrappedValue[IndexSet.first!]
                    purchase.deletePurchase(item: delete, context: context)
                    
                    total = purchases.wrappedValue.reduce(0, {$0 + $1.price })
                    resto = card.credit - total
                }
            }
            Grid{
                GridRow{
                    Text("Credit: $\(card.credit)")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .bold()
                    Text("Total: $\(total)")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .bold()
                    Text("Rest: $\(resto)")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .bold()
                }
            }
        }
        .navigationTitle(card.name ?? "")
        .toolbar{
            Button {
                addPurchase.toggle()
            } label: {
                Image(systemName: "plus.app")
            }.navigationDestination(isPresented: $addPurchase) {
                AddPurchaseView(card: card)
            }.onAppear{
                total = purchases.wrappedValue.reduce(0, {$0 + $1.price })
                resto = card.credit - total
            }

        }
    }
}
