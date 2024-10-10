//
//  CardsViewModel.swift
//  CreditCards
//
//  Created by Marcos Manzo.
//

import SwiftUI

struct AddCardView: View {
        
    @Environment(\.managedObjectContext) private var context

    @StateObject var cards : CardsViewModel
    let types = ["VISA", "MASTER CARD", "AMERICAN EXPRESS"]
    @State private var error = false
    @State private var msgError = "Algo salio mal.."
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                Text(cards.updateItem == nil ? "Add credit card" : "Edit credit card")
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()
                TextField("Name", text: $cards.name)
                    .textFieldStyle(.roundedBorder)
                TextField("Number", text: $cards.number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                TextField("Credit", text: $cards.credit)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                Picker("", selection: $cards.type) {
                    ForEach(types, id:\.self){
                        Text($0)
                    }
                }.pickerStyle(.segmented)
                    .accentColor(Color.white)
                    .background(RoundedRectangle(cornerRadius:4)
                            .fill(Color("colorThree")))
                    
                
                Button {
                    if cards.updateItem == nil {
                        cards.saveCard(context: context) { done in
                            if done {
                                cards.addCardView.toggle()
                            }else {
                                error.toggle()
                            }
                        }
                    }else {
                        cards.editCard(context: context) { done in
                            if done {
                                cards.addCardView.toggle()
                            }else {
                                error.toggle()
                            }
                        }
                    }
                } label: {
                    Text(cards.updateItem == nil ? "Save card" : "Edit card")
                        .font(.title3)
                        .foregroundColor(.black)
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                Spacer()
                
            }.padding(.all)
                .alert(msgError, isPresented: $error) {
                    Button("Aceptar", role: .cancel){}
                }
        }.onDisappear{
            cards.name = ""
            cards.type = ""
            cards.credit = ""
            cards.number = ""
            cards.updateItem = nil
        }
    }
}

