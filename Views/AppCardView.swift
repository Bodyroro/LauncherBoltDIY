//
//  AppCardView.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import SwiftUI

// Composant réutilisable pour une carte stylisée.
struct AppCardView<Content: View>: View {
    var title: String?
    var titleIcon: String?
    let content: Content
    
    init(title: String? = nil, titleIcon: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.titleIcon = titleIcon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let cardTitle = title {
                HStack(spacing: 10) {
                    if let icon = titleIcon {
                        Image(systemName: icon)
                            .foregroundColor(.accentColor)
                    }
                    Text(cardTitle)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                Divider()
            }
            content
        }
        .padding(20)
        .background(Color(.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
