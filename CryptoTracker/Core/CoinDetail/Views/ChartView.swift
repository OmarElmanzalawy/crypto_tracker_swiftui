//
//  ChartView.swift
//  CryptoTracker
//
//  Created by MAC on 03/07/2025.
//

import SwiftUI

struct ChartView: View {
    let data: [Double]
    let maxY: Double
    let minY: Double
    let lineColor: Color
    let startingDate: Date
    let endingDate: Date
    @State private var animationProgress: CGFloat = 0
    
    init(coin: Coin){
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        lineColor = data.last! >= data.first! ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckgoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(
                    VStack{
                        Divider()
                        Spacer()
                        Divider()
                        Spacer()
                        Divider()
                    }
                )
                .overlay(alignment: .leading) {
                    VStack{
                        Text(maxY.formattedWithAbbreviations())
                        Spacer()
                        Text(((maxY - minY) / 2).formattedWithAbbreviations())
                        Spacer()
                        Text(minY.formattedWithAbbreviations())
                        
                    }
                    .padding(.horizontal,4)
                }
            HStack{
                Text(startingDate.asShortDateString())
                Spacer()
                Text(endingDate.asShortDateString())
            }
            .padding(.horizontal,4)
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                withAnimation(.linear(duration: 2.0)) {
                    animationProgress = 1
                }
            }
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
    }
}

#Preview {
    ChartView(coin: Coin.testCoin)
}

extension ChartView{
    private var chartView: some View{
        GeometryReader{geometry in
            Path{path in
                for index in data.indices{
                    
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat(data[index] - minY) / yAxis)  * geometry.size.height
                    
                    if index == 0{
                        path.move(to: CGPoint(x: xPosition , y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: animationProgress)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2,lineCap: .round,lineJoin: .round))
            .drawingGroup() // tells swiftUI to render everything before applying shadow so that shadow bug doesn't appear
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
}
