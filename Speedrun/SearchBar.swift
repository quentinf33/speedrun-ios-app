//
//  SearchBar.swift
//  Speedrun
//
//  Created by Quentin Fortage on 28/04/2024.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        TextField("Search games", text: $searchText)
            .autocapitalization(.none)  // Désactiver la capitalisation automatique
            .disableAutocorrection(true)  // Désactiver la correction automatique
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .overlay(
                // Ajout d'un bouton pour effacer le texte à droite du TextField
                HStack {
                    Spacer()
                    if !searchText.isEmpty {
                        Button(action: {
                            self.searchText = ""  // Efface le texte du champ de recherche
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(15)
                        }
                        .padding(.trailing, 8)
                    }
                }
            )
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var searchText = "Sample text"  // Texte initial pour la prévisualisation

    static var previews: some View {
        SearchBar(searchText: $searchText)
            .previewLayout(.sizeThatFits)  // Utilise .sizeThatFits pour mieux adapter au contenu
            .padding()  // Ajout de padding pour mieux visualiser dans la prévisualisation
    }
}
