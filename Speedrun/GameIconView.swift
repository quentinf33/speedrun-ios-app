//
//  GameIconView.swift
//  Speedrun
//
//  Created by Quentin Fortage on 28/04/2024.
//

import SwiftUI

// Cette vue sera responsable de l'affichage de l'icône du jeu.
struct GameIconView: View {
    var imageUrl: String?  // URL de l'icône du jeu.

    var body: some View {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
        } else {
            Image(systemName: "gamecontroller")  // Icône placeholder si aucune image n'est disponible.
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
        }
    }
}

#Preview {
    GameIconView()
}
