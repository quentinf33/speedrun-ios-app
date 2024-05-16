//
//  LoadingView.swift
//  Speedrun
//
//  Created by Quentin Fortage on 28/04/2024.
//

import SwiftUI

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
                .padding(2)
            Text("Chargement")
        }
        .padding()
        Spacer()
    }
}

#Preview {
    LoadingView()
}
