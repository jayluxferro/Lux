//
//  EnerSmartView.swift
//  Lux (iOS)
//
//  Created by Jay on 09/01/2021.
//

import SwiftUI
import Ecg

struct EnerSmartView: View {
    private let ctrl = Controller()
    @State private var meterNumber = Config.meterNumber
    @State private var networks = Config.networks
    @State private var selectedNetwork = Config.networks[0]
    @State private var amount = Config.amount
    @State private var phoneNumber = Config.phoneNumber
    @State private var voucher = Config.voucher
    @State private var log = Config.log
    @State private var isProcessing = Config.isProcessing
    
    private var isValid: Bool {
        return meterNumber.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8 &&
            Int(amount.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 > 0 &&
            phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).count == 10
    }
    
    var body: some View {
        NavigationView {
            GeometryReader{
                geo in
                Form{
                    Section(header: Text("Details")) {
                        HStack {
                            Text("Meter Number")
                                .font(.none)
                            Spacer(minLength: 24)
                            Divider()
                            Spacer()
                            TextField("Meter Number", text: $meterNumber)
                                .keyboardType(.numberPad)
                        }
                        
                        Picker("Network", selection: $selectedNetwork) {
                            ForEach(networks, id: \.self) { network in
                                Text(network)
                            }
                        }
                        
                        HStack {
                            Text("Amount (GHC)")
                            Spacer(minLength: 23)
                            Divider()
                            Spacer()
                            TextField("Amount (GHC)", text: $amount)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Text("Phone Number")
                            Spacer(minLength: 22)
                            Divider()
                            Spacer()
                            TextField("Phone Number", text: $phoneNumber)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack{
                            Text("Voucher Number")
                            Divider()
                            Spacer()
                            TextField("Voucher", text: $voucher)
                                .keyboardType(.numberPad)
                        }
                    }
                    
                    Section(header: Text("Log")) {
                        ScrollView {
                            if isProcessing {
                                LProgress()
                            }else {
                                TextEditor(text: $log)
                                    .disabled(true)
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
                Text("EnerSmart"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                // check current balance
                ctrl.endEditing()
                DispatchQueue.main.async{
                    self.isProcessing.toggle()
                    self.log = ""
                    let params = EcgGetParams(meterNumber, phoneNumber, selectedNetwork, voucher, amount)
                    self.log += EcgInitGetMeterBalance(params)
                    
                    self.isProcessing.toggle()

                }
            }, label: {
                Image(systemName: "timelapse")
            })
            .disabled((!isValid) || isProcessing)
            , trailing: Button(action: {
                // make payment
                ctrl.endEditing()
                DispatchQueue.main.async{
                    self.isProcessing.toggle()
                    self.log = ""
                    let params = EcgGetParams(meterNumber, phoneNumber, selectedNetwork, voucher, amount)
                    self.log += EcgInitMakePayment(params)
                    self.isProcessing.toggle()
                    
                }
            }, label: {
                Image(systemName: "creditcard")
            })
            .disabled((!isValid) || isProcessing))
            
        }
        
    }
}

struct EnerSmartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EnerSmartView()
                .previewDevice("iPhone 11 Pro")
        }
    }
}
