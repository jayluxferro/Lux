//
//  EnerSmartView.swift
//  Lux (iOS)
//
//  Created by Jay on 09/01/2021.
//

import SwiftUI
import WebView

struct EnerSmartView: View {
    private let ctrl = Controller()
    @State private var meterNumber = Config.meterNumber
    @State private var networks = Config.networks
    @State private var selectedNetwork = Config.networks[0]
    @State private var amount = Config.amount
    @State private var phoneNumber = Config.phoneNumber
    @State private var voucher = Config.voucher
    @State private var log = Config.log
    @State private var pageLoaded = Config.pageLoaded
    
    private var isValid: Bool {
        return meterNumber.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8 &&
        Int(amount.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 > 0 &&
        phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).count == 10
    }
    
    @StateObject var webViewStore = WebViewStore()
    
    var body: some View {
        NavigationView {
            WebView(webView: webViewStore.webView)
                .navigationTitle(
                    Text("EnerSmart"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: HStack {
                    Button(action: reload) {
                        Image(systemName: "repeat.circle")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }
                })
        }.onAppear {
            if(!pageLoaded) {
                self.reload()
            }
        }
        
    }
    
    func reload(){
        self.webViewStore.webView.load(URLRequest(url: URL(string: Config.enersmartURL)!))
        self.pageLoaded = true
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
