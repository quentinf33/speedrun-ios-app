//
//  UserIconView.swift
//  Speedrun
//
//  Created by Quentin Fortage on 28/04/2024.
//

import SwiftUI

struct UserIconView: View {
    var imageUrl: String?
    var iconSize: CGFloat = 40
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(borderColor, lineWidth: 2)
                )
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(borderColor, lineWidth: 2)
                )
        }
    }

    var borderColor: Color {
        colorScheme == .dark ? .white : .black
    }
}

// Prévisualisation pour la vue UserIconView
struct UserIconView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserIconView(imageUrl: nil)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .padding()
            UserIconView(imageUrl: nil)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
