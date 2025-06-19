//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by MAC on 19/06/2025.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: Coin? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        
    NavigationStack {
            ScrollView {
                VStack {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    if  selectedCoin != nil{
                        VStack(spacing: 20){
                            HStack{
                                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                                Spacer()
                                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                            }
                            Divider()
                            HStack{
                                Text("Amount holding:")
                                Spacer()
                                TextField("Ex: 1.4", text: $quantityText)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.decimalPad)
                            }
                            Divider()
                            HStack{
                                Text("Current value:")
                                Spacer()
                                Text("")
                            }
                            Divider()
                        }
                        .animation(.none)
                    }
                }
            }
                .navigationTitle("Edit Portfolio")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        XMarkButton()
                }
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark")
                                .opacity(showCheckmark ? 1 : 0)
                            Button(action: {
                                guard let coin = selectedCoin else{return}
                                
                                //save to portfolio
                                
                                //show checkmark
                                withAnimation(.easeIn) {
                                    showCheckmark = true
                                    selectedCoin = nil
                                    vm.searchText = ""
                                }
                                
                                //hide keyboard
                                UIApplication.shared.endEditing()
                                
                                // hide checkmark after delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                    withAnimation(.easeOut) {
                                        showCheckmark = false
                                    }
                                }
                            }, label: {
                                Text("Save")
                                
                            })
                            .opacity((selectedCoin != nil && (selectedCoin?.currentHoldings ?? 0) != Double(quantityText)) ? 1.0 : 0)
                            .animation(.none, value: selectedCoin != nil)
                        }
                        
                        
                }
            }
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
}

#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}

extension PortfolioView{
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack(spacing: 10){
                ForEach(vm.allCoins){coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture(perform: {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ?  Color.theme.green : Color.clear,lineWidth: 1)
                        )
                }
            }
            .padding(.vertical,20)
            .padding(.leading)
        }
    }
}

 
