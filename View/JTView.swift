//
//  JTView.swift
//  Lux (iOS)
//
//  Created by Jay on 13/04/2021.
//

import SwiftUI

struct JTView: View {
    @StateObject var ctrl = Controller()
    @State private var port = ""
    @State private var date = ""
    
    var body: some View {
        NavigationView {
            GeometryReader{
                geo in
                Form{
                    Section(header: Text("Details")) {
                        HStack {
                            Text("Port")
                            Spacer(minLength: 22)
                            Divider()
                            Spacer()
                            TextField("Port", text: $ctrl.port)
                                .disabled(true)
                        }
                        
                        HStack {
                            Text("Date")
                            Spacer(minLength: 18)
                            Divider()
                            Spacer()
                            TextField("Date", text: $ctrl.date)
                                .disabled(true)
                        }
                    }
                    
                    Section(header: Text("Log")) {
                        ScrollView {
                            if ctrl.isProcessing {
                                LProgress()
                            }else {
                                TextEditor(text: $ctrl.log)
                                    .disabled(true)
                                    .font(.subheadline)
                                    .frame(height: geo.size.height/2, alignment: .leading)
                            }
                        }
                    }
                    
                }
                .onTapGesture {
                    ctrl.endEditing()
                }
            }
            .navigationTitle(
                Text("iConnect")
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                // end editing
                ctrl.endEditing()
                DispatchQueue.main.async{
                    ctrl.iConnect()
                }
            }, label: {
                Image(systemName: "magnifyingglass.circle")
            })
            .disabled(ctrl.isProcessing)
            )
        }
    }
}

struct JTView_Previews: PreviewProvider {
    static var previews: some View {
        JTView()
    }
}
