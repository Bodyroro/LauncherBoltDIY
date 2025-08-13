//
//  MainButtonGrid.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import SwiftUI

struct MainButtonGrid: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 20)], spacing: 20) {
            
            // Bouton pour installer le projet
            ActionButton(
                title: Localizable.installButton,
                icon: "square.and.arrow.down.fill",
                color: Color.blue,
                isDisabled: viewModel.isProjectInstalled || viewModel.isProcessing,
                action: viewModel.setupBoltDIY
            )
            
            // Boutons qui ne s'affichent que si le projet est installé
            if viewModel.isProjectInstalled {
                // Bouton pour lancer le serveur
                ActionButton(
                    title: Localizable.launchButton,
                    icon: "play.circle.fill",
                    color: Color.green,
                    isDisabled: viewModel.serverProcess != nil || viewModel.isProcessing,
                    action: viewModel.launchBoltDIY
                )
                
                // Bouton pour arrêter le serveur
                ActionButton(
                    title: Localizable.stopButton,
                    icon: "stop.circle.fill",
                    color: Color.red,
                    isDisabled: viewModel.serverProcess == nil || viewModel.isProcessing,
                    action: viewModel.stopBoltDIY
                )
                
                // Bouton pour mettre à jour le projet
                ActionButton(
                    title: Localizable.updateButton,
                    icon: "arrow.clockwise.circle.fill",
                    color: Color.purple,
                    isDisabled: !viewModel.isUpdateAvailable || viewModel.isProcessing,
                    action: viewModel.updateProject
                )
                
                // Bouton pour supprimer le projet
                ActionButton(
                    title: Localizable.deleteButton,
                    icon: "trash.fill",
                    color: Color.orange,
                    isDisabled: !viewModel.isProjectInstalled || viewModel.isProcessing,
                    action: viewModel.deleteProject
                )
                
                // Bouton pour ouvrir l'interface web
                ActionButton(
                    title: Localizable.openWebButton,
                    icon: "safari.fill",
                    color: Color.accentColor,
                    isDisabled: viewModel.serverProcess == nil || viewModel.isProcessing,
                    action: viewModel.openBoltDIYWebInterface
                )
            }
        }
        .environmentObject(viewModel)
    }
}
