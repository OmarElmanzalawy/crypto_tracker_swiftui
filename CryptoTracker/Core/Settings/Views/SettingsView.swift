//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by MAC on 04/07/2025.
//

import SwiftUI

struct SettingsView: View {
    
    let linkedinUrl = URL(string: "https://www.linkedin.com/in/omar-elmanzalawy-4437151bb/")
    let githubUrl = URL(string: "https://github.com/OmarElmanzalawy")
    let portfolioUrl = URL(string: "https://manzalawydev.vercel.app")
    let coingeckoUrl = URL(string: "https://www.coingecko.com")
    
    var body: some View {
        List{
            developerInfoSection
            coinGeckoSection
        }
        .navigationTitle("Settings")
        .listStyle(.grouped)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                XMarkButton()
            }
        }
    }
        
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

extension SettingsView{
    private var developerInfoSection: some View{
        Section("Developer Info") {
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by Omar Elmanzalawy. It uses MVVM Architecture, Combine, and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Linkedin", destination: linkedinUrl!)
            Link("Github", destination: githubUrl!)
            Link("Portoflio Website", destination: portfolioUrl!)
        }
        .tint(.blue)
    }
    
    private var coinGeckoSection: some View{
        Section("Coin gecko") {
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The data used in this app comes from CoinGecko's API. CoinGecko is a cryptocurrency data provider that offers real-time market data, historical data, and other information about cryptocurrencies.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Coingecko Website", destination: linkedinUrl!)
        }
        .tint(.blue)
    }
}
