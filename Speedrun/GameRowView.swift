//
//  GameRowView.swift
//  Speedrun
//
//  Created by Quentin Fortage on 28/04/2024.
//

import SwiftUI

// Cette vue sera responsable de l'affichage d'une ligne unique dans la liste.
import SwiftUI

struct GameRowView: View {
    var game: Game

    @Environment(\.colorScheme) var colorScheme  // Accès au thème actuel

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let imageUrl = game.assets?.coverSmall?.uri, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100, maxHeight: 100)
                            //.border(colorScheme == .dark ? Color.white : Color.black, width: 2)  // Bordure qui change avec le thème
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .frame(width: 100, height: 100)
                            //.border(colorScheme == .dark ? Color.white : Color.black, width: 2)
                    } else {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            //.border(colorScheme == .dark ? Color.white : Color.black, width: 2)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .border(colorScheme == .dark ? Color.white : Color.black, width: 2)
            }

            VStack(alignment: .leading) {
                Text(game.names.international)
                    .font(.headline)
            }
        }
    }
}

struct GameRowView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleGame = Game(id: "1", names: Game.Name(international: "Super Mario Odyssey"), assets: Game.Assets(coverSmall: Game.Icon(uri: "https://www.speedrun.com/images/cover-small.png")))
        
        GameRowView(game: sampleGame)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
