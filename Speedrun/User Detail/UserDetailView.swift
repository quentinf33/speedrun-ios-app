//
//  UserDetailsView.swift
//  Speedrun
//
//  Created by Quentin Fortage on 29/04/2024.
//

import SwiftUI

extension User {
    // Exemple de données pour la prévisualisation
    static var previewUser: User {
        User(
            id: "1",
            names: UserName(international: "John Doe"),
            weblink: "https://example.com",
            role: "Moderator",
            location: UserLocation(country: UserCountry(code: "US", names: UserName(international: "United States"))),
            icon: Icon(uri: "https://example.com/icon.png"),
            assets: UserAssets(icon: Icon(uri: "https://example.com/icon.png"), image: Icon(uri: "https://example.com/image.png"))
        )
    }
}

struct UserDetailView: View {
    var user: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let imageUrl = user.assets?.image?.uri, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill) // Ajustement du mode de remplissage de l'image
                             .frame(width: 200, height: 200)  // Taille fixe pour le cercle
                             .clipShape(Circle())  // Recadrage en forme de cercle
                             .overlay(Circle().stroke(Color.gray, lineWidth: 4))  // Bordure grise
                             .shadow(radius: 10)  // Optionnel: Ajouter une ombre pour un effet de profondeur
                    } placeholder: {
                        Color.gray.frame(width: 200, height: 200)
                                 .clipShape(Circle())
                                 .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                    }
                }
                
                if let location = user.location {
                    Text("\(location.country.names.international)")
                }
                
                Text("\(user.role)")
                    .foregroundColor(.secondary)
                
                
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(user.names.international)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDetailView(user: User.previewUser)
        }
    }
}
