//
//  GameView.swift
//  Speedrun
//
//  Created by Quentin Fortage on 27/04/2024.
//

import SwiftUI
import Foundation
import Combine

// Modèle pour le jeu
struct Game: Codable, Identifiable {
    var id: String
    var names: Name
    var assets: Assets?

    struct Name: Codable {
        var international: String
    }

    struct Assets: Codable {
        var coverSmall: Icon?
        
        enum CodingKeys: String, CodingKey {
            case coverSmall = "cover-small"
        }
    }

    struct Icon: Codable {
        var uri: String?
    }
}

// Modèle pour la réponse de l'API, incluant la pagination
struct GamesResponse: Codable {
    var data: [Game]
    var pagination: Pagination
}

struct Pagination: Codable {
    var offset: Int
    var max: Int
    var size: Int
    var links: [Link]
}

struct Link: Codable {
    var rel: String
    var uri: String
}

class GameViewModel: ObservableObject {
    @Published var games = [Game]()
    @Published var isLoading = false
    @Published var searchText = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Charge les jeux initiaux sans filtre.
        loadGames()
        
        $searchText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.searchGames(query: text)
            }
            .store(in: &cancellables)
    }

    func loadGames() {
        guard let url = URL(string: "https://www.speedrun.com/api/v1/games") else { return }
        isLoading = true
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let data = data, error == nil,
                      let decodedResponse = try? JSONDecoder().decode(GamesResponse.self, from: data) else {
                    return
                }
                self?.games = decodedResponse.data
            }
        }.resume()
    }

    func searchGames(query: String) {
        guard !query.isEmpty, let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            games = []
            return
        }

        let urlString = "https://www.speedrun.com/api/v1/games?name=\(encodedQuery)"
        guard let url = URL(string: urlString) else { return }

        isLoading = true
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(GamesResponse.self, from: data)
                        self?.games = decodedResponse.data
                    } catch {
                        print("Decoding error: \(error)")
                        self?.games = []
                    }
                } else if let error = error {
                    print("HTTP request failed: \(error)")
                    self?.games = []
                }
            }
        }.resume()
    }
}

import SwiftUI

struct GamesView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $viewModel.searchText)  // Utilisez SearchBar déjà créée.
                
                if viewModel.isLoading {
                    LoadingView()  // Réutilisez la vue de chargement existante.
                } else {
                    List(viewModel.games) { game in
                        GameRowView(game: game)
                    }
                }
            }
            .navigationTitle("Games")
        }
    }
}

// Ajout d'une extension au GameViewModel pour gérer le chargement des données si nécessaire
extension GameViewModel {
    func loadGamesIfNeeded() {
        if games.isEmpty && !isLoading {
            loadGames()
        }
    }
}

// Prévisualisation pour la vue GamesView
struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView(viewModel: GameViewModel())
    }
}
