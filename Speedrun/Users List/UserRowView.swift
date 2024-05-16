//
//  UserRowView.swift
//  Speedrun
//
//  Created by Quentin Fortage on 28/04/2024.
//

import SwiftUI

struct UserRowView: View {
    var user: User
    var iconSize: CGFloat = 40

    var body: some View {
        NavigationLink(destination: UserDetailView(user: user)) {
            HStack {
                UserIconView(imageUrl: user.assets?.image?.uri, iconSize: iconSize)
                VStack(alignment: .leading) {
                    Text(user.names.international)
                        .font(.system(size: 16))
                    
                    if let flag = user.countryFlag {
                        Text(flag)
                            .font(.system(size: 24))
                    }
                }
            }
        }
    }
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        // Création d'un exemple d'utilisateur pour la prévisualisation
        let sampleUser = User(
            id: "1",
            names: UserName(international: "John Doe"),
            weblink: "https://www.example.com",
            role: "user",
            location: UserLocation(
                country: UserCountry(
                    code: "US",
                    names: UserName(international: "United States")
                )
            ),
            icon: Icon(uri: "https://www.example.com/icon.png"),
            assets: UserAssets(
                icon: Icon(uri: "https://www.example.com/icon.png"),
                image: Icon(uri: "https://www.example.com/image.png")
            )
        )

        // Utilisation de l'exemple d'utilisateur dans UserRowView
        UserRowView(user: sampleUser)
    }
}
