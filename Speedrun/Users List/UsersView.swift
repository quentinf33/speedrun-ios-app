//
//  UsersView.swift
//  Speedrun
//
//  Created by Quentin Fortage on 27/04/2024.
//

import SwiftUI
import Foundation
import Combine

// Définition de la structure User qui conforme aux protocoles Codable et Identifiable pour le décodage JSON et l'identification dans les vues SwiftUI.
struct User: Codable, Identifiable {
    var id: String
    var names: UserName
    var weblink: String
    var role: String
    var location: UserLocation?
    var countryFlag: String? {
        location?.country.code.uppercased().toFlagEmoji() // Calcul de l'emoji du drapeau à partir du code pays.
    }
    var icon: Icon?
    var assets: UserAssets? // Pour gérer les images associées à l'utilisateur.
}

// Structures pour les détails de localisation de l'utilisateur.
struct UserLocation: Codable {
    var country: UserCountry
}

struct UserCountry: Codable {
    var code: String  // Assurez-vous que ce soit un code pays ISO à deux lettres.
    var names: UserName
}

// Structure pour les noms d'utilisateur, prenant en charge international.
struct UserName: Codable {
    var international: String
}

// Structure pour les assets de l'utilisateur, incluant potentiellement des icones et images.
struct UserAssets: Codable {
    var icon: Icon?
    var image: Icon?
}

// Structure pour les icônes, contenant l'URI pour l'image.
struct Icon: Codable {
    var uri: String?
}

// Extension pour convertir le code pays en emoji de drapeau.
extension String {
    func toFlagEmoji() -> String {
        let components = self.components(separatedBy: "/")
        return components.compactMap { code in
            guard code.count == 2 else { return nil }
            let baseOffset = 127397  // Décalage pour les indicateurs régionaux.
            return code.uppercased().unicodeScalars.compactMap { scalar -> Character? in
                guard let regionalIndicator = UnicodeScalar(UInt32(scalar.value) + UInt32(baseOffset)) else { return nil }
                return Character(regionalIndicator)
            }.reduce("") { $0 + String($1) }  // Concaténation des caractères pour former l'emoji.
        }.joined()
    }
}

// Structure pour la réponse des utilisateurs venant de l'API.
struct UsersResponse: Codable {
    var data: [User]?
}

// ViewModel pour gérer la liste des utilisateurs.
class UserViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var isLoading = false
    @Published var searchText = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.searchUsersByName()
            })
            .store(in: &cancellables)
    }

    // Fonction pour rechercher des utilisateurs par nom.
    func searchUsersByName() {
        guard let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.speedrun.com/api/v1/users?name=\(encodedSearchText)") else {
            users = []
            return
        }
        isLoading = true
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(UsersResponse.self, from: data)
                        self?.users = decodedResponse.data ?? []
                    } catch {
                        print("Erreur de décodage : \(error)")
                    }
                } else if let error = error {
                    print("Erreur réseau : \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

// Vue principale pour afficher la liste des utilisateurs.
struct UsersView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Users", text: $viewModel.searchText)
                    .autocapitalization(.none)  // Désactive la capitalisation automatique
                    .disableAutocorrection(true)  // Désactive la correction automatique
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        // Ajout d'un bouton d'effacement à droite si searchText n'est pas vide
                        HStack {
                            Spacer()
                            if !viewModel.searchText.isEmpty {
                                Button(action: {
                                    self.viewModel.searchText = ""  // Efface le champ de recherche
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 8)
                            }
                        }
                    )
                    .padding()
                
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    List(viewModel.users, id: \.id) { user in
                        UserRowView(user: user)
                    }
                }
            }
            .navigationTitle("Users")
        }
    }
}

#Preview {
    UsersView(viewModel: UserViewModel())
}
