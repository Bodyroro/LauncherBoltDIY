//
//  SettingsView.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import SwiftUI

// Enum pour gérer la préférence de thème
enum ThemePreference: String, CaseIterable, Identifiable {
    case system, light, dark
    
    var id: String { self.rawValue }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var displayName: String {
        switch self {
        case .system: return "Système"
        case .light: return "Clair"
        case .dark: return "Sombre"
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var themePreference: ThemePreference
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(Localizable.settingsTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Form {
                Section(header: Text("Apparence")) {
                    Picker("Thème de l'application", selection: $themePreference) {
                        ForEach(ThemePreference.allCases) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                }
                
                Section(header: Text("À propos")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                    Text(Localizable.footer)
                        .foregroundColor(.secondary)
                }
            }
            .formStyle(.grouped)
            .padding()
            
            Button("Fermer") {
                dismiss()
            }
            .padding(.bottom)
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}
