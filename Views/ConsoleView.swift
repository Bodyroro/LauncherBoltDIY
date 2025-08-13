//
//  ConsoleView.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import SwiftUI
import AppKit

// Vue pour la console de l'application.
// Elle gère l'affichage du log et le défilement automatique.
struct ConsoleView: View {
    @Binding var log: String
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                Text(AttributedString(AnsiCodeParser.parseAnsiCodes(from: log)))
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .id("consoleContent")
            }
            .frame(minHeight: 150, maxHeight: 300)
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primary.opacity(0.2), lineWidth: 1)
            )
            .onChange(of: log) {
                withAnimation {
                    proxy.scrollTo("consoleContent", anchor: .bottom)
                }
            }
        }
    }
}
