//
//  ContentView.swift
//  Speedrun
//
//  Created by Quentin Fortage on 27/04/2024.
//

import SwiftUI

// Vue principale qui utilise GamesView
struct ContentView: View {
    var body: some View {
        TabView {
            GamesView(viewModel: GameViewModel())
                .tabItem {
                    Label("Games", systemImage: "gamecontroller.fill")
                }

            UsersView(viewModel: UserViewModel())
                .tabItem {
                    Label("Users", systemImage: "person.3.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
