//
//  ContentView.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import SwiftUI
import AppKit

// ContentView est la vue principale de l'application.
// Elle observe les changements du ViewModel pour mettre à jour l'interface.
struct ContentView: View {

    // Le ViewModel est un objet observé qui gère toute la logique de l'application.
    @StateObject private var viewModel = ViewModel()
    @AppStorage("themePreference") private var themePreference: ThemePreference = .system

    // États pour contrôler l'affichage des fenêtres modales.
    @State private var showingSettings = false
    @State private var showingReadme = false
    @State private var showingChangelog = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {

                // Entête de l'application
                HStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                    Text(Localizable.appTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                .padding(.top)

                // Contenu principal
                VStack(alignment: .leading, spacing: 15) {

                    // Section des actions et des commits
                    HStack(alignment: .top, spacing: 15) {

                        // Carte des boutons d'action
                        AppCardView {
                            MainButtonGrid(viewModel: viewModel)
                        }
                        .frame(maxWidth: .infinity)

                        // Carte des informations de commit
                        AppCardView(title: "Commit") {
                            ProjectInfoView(viewModel: viewModel)
                        }
                        .fixedSize(horizontal: true, vertical: false)
                    }

                    // Carte de la console
                    AppCardView(title: Localizable.consoleTitle) {
                        ConsoleView(log: $viewModel.consoleLog)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // Pied de page
                CreditsView(
                    showingSettings: $showingSettings,
                    showingReadme: $showingReadme,
                    showingChangelog: $showingChangelog
                )
                .padding(.bottom)
            }
            .frame(minWidth: 700, minHeight: 600)
            .padding(20)
            .background(Color(.controlBackgroundColor))
            .onAppear {
                viewModel.updateProjectState()
                viewModel.updateCommitInfo()
            }
            .sheet(isPresented: $showingSettings) { SettingsView(themePreference: $themePreference) }
            .sheet(isPresented: $showingReadme) { ReadmeView() }
            .sheet(isPresented: $showingChangelog) { ChangelogView() }
            .preferredColorScheme(themePreference.colorScheme)

            if viewModel.isProcessing {
                ProgressOverlayView()
            }
        }
    }
}

// Prévisualisation de la vue dans Xcode.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Vue pour afficher les informations de commit.
struct ProjectInfoView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(Localizable.localCommitLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(viewModel.formatCommit(viewModel.localCommit))
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.bold)
                if viewModel.isCheckingCommits {
                    ProgressView()
                        .scaleEffect(0.5)
                }
            }
            HStack {
                Text(Localizable.remoteCommitLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(viewModel.formatCommit(viewModel.remoteCommit))
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.bold)
                if viewModel.isCheckingCommits {
                    ProgressView()
                        .scaleEffect(0.5)
                }
            }
        }
    }
}

// Composants pour les boutons du pied de page.
struct CreditsView: View {
    @Binding var showingSettings: Bool
    @Binding var showingReadme: Bool
    @Binding var showingChangelog: Bool
    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 10) {
            // Lien GitHub amélioré
            Link(destination: URL(string: "https://github.com/stackblitz-labs/bolt.diy")!) {
                HStack(spacing: 5) {
                    Image(systemName: "g.circle.fill")
                    Text("GitHub Bolt DIY")
                        .fontWeight(.bold)
                }
                .padding(8)
                .background(isHovering ? Color.secondary.opacity(0.2) : Color.secondary.opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
            .onHover { hover in
                isHovering = hover
            }
            .scaleEffect(isHovering ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isHovering)

            Spacer()
            
            SettingsButton(showingSettings: $showingSettings)
            ReadmeButton(showingReadme: $showingReadme)
            ChangelogButton(showingChangelog: $showingChangelog)
        }
    }
}

struct SettingsButton: View {
    @Binding var showingSettings: Bool

    var body: some View {
        Button(action: { showingSettings = true }) {
            Label(Localizable.settingsTitle, systemImage: "gearshape.fill")
        }
        .buttonStyle(.plain)
    }
}

struct ReadmeButton: View {
    @Binding var showingReadme: Bool

    var body: some View {
        Button(action: { showingReadme = true }) {
            Label(Localizable.readmeTitle, systemImage: "book.fill")
        }
        .buttonStyle(.plain)
    }
}

struct ChangelogButton: View {
    @Binding var showingChangelog: Bool

    var body: some View {
        Button(action: { showingChangelog = true }) {
            Label(Localizable.changelogTitle, systemImage: "list.bullet.rectangle.fill")
        }
        .buttonStyle(.plain)
    }
}

struct ProgressOverlayView: View {
    var body: some View {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
            .overlay(
                ProgressView(Localizable.processing)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(12)
            )
    }
}
