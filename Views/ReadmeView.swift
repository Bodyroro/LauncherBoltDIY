//
//  ReadmeView.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import SwiftUI
import MarkdownUI

// Vue pour afficher le contenu du fichier README.
struct ReadmeView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(Localizable.readmeTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(Localizable.closeButton) {
                    dismiss()
                }
            }
            Divider()
            
            ScrollView {
                Markdown(Localizable.readmeContent)
                    .padding()
            }
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
        .frame(minWidth: 800, minHeight: 700)
    }
}

struct ReadmeView_Previews: PreviewProvider {
    static var previews: some View {
        ReadmeView()
    }
}
