//
//  MomoView.swift
//  Lux (iOS)
//
//  Created by Jay on 09/01/2021.
//

import SwiftUI

struct MomoView: View {
    
    @StateObject var ctrl = Controller()
    @State private var networks = Config.networks
    @State private var selectedNetwork = Config.networks[0]
    @State private var phoneNumber = ""
   
    
    private var isValid: Bool {
        return phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).count >= 10
    }
    
    var body: some View {
        NavigationView {
            GeometryReader{
                geo in
                Form{
                    Section(header: Text("Details")) {
                        HStack {
                            Text("Phone Number")
                            Spacer(minLength: 22)
                            Divider()
                            Spacer()
                            TextField("Phone Number", text: $phoneNumber)
                                .keyboardType(.numberPad)
                        }
                        
                        Picker("Network", selection: $selectedNetwork) {
                            ForEach(networks, id: \.self) { network in
                                Text(network)
                            }
                        }
                    }
                    
                    Section(header: Text("Log")) {
                        ScrollView {
                            if ctrl.isProcessing {
                                LProgress()
                            }else {
                                TextEditor(text: $ctrl.log)
                                    .font(.subheadline)
                                    .frame(height: geo.size.height/3, alignment: .leading)
                            }
                        }
                    }
                    
                }
                .onTapGesture {
                    ctrl.endEditing()
                }
            }
            .navigationTitle(
                Text("MoMo")
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                // end editing
                ctrl.endEditing()
                DispatchQueue.main.async{
                    ctrl.verifyMomo(network: selectedNetwork, phone: phoneNumber)
                }
            }, label: {
                Image(systemName: "magnifyingglass.circle")
            })
            .disabled((!isValid) || ctrl.isProcessing)
            )
        }
    }
}

struct MomoView_Previews: PreviewProvider {
    static var previews: some View {
        MomoView()
    }
}
