//
//  StatisticView.swift
//  CryptoTracker
//
//  Created by MAC on 18/06/2025.
//

import SwiftUI

struct StatisticView: View {
    let stat: Statistic
    var body: some View {
        VStack(alignment: .leading,spacing: 4){
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            if let percentageChange = stat.percentageChange{
                HStack(spacing: 4) {
                    Image(systemName: "triangle.fill")
                        .font(.caption2)
                        .rotationEffect(Angle(degrees: stat.percentageChange ?? 0 >= 0 ? 0 : 180))
                    Text(stat.percentageChange?.asPercentString() ?? "")
                        .font(.caption)
                        .bold()
                }
                .foregroundStyle(stat.percentageChange ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
            }
            
        }
    }
}

#Preview {
    StatisticView(stat: Statistic.testStatisitc)
}
