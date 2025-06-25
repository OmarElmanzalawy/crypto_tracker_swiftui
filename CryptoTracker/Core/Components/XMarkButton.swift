//
//  XMarkButton.swift
//  CryptoTracker
//
//  Created by MAC on 19/06/2025.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
    }
    }
}

#Preview {
    XMarkButton()
}
