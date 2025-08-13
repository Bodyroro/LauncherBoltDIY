//
//  ActionButton.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import SwiftUI

// ActionButton est un composant réutilisable pour les boutons d'action.
struct ActionButton: View {
    
    var title: String
    var icon: String
    var color: Color
    var isDisabled: Bool = false
    var action: () -> Void
    
    @State private var isPressed: Bool = false
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        Button(action: {
            if !isDisabled {
                action()
            }
        }) {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.title)
                    .frame(height: 25)
                Text(title)
                    .font(.footnote)
                    .fontWeight(.medium)
            }
            .padding(15)
            .frame(maxWidth: .infinity, minHeight: 80)
        }
        .background(color.opacity(isDisabled ? 0.5 : 1))
        .foregroundColor(.white)
        .cornerRadius(12)
        .shadow(color: color.opacity(0.3), radius: isPressed ? 2 : 5, x: 0, y: isPressed ? 1 : 3)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .buttonStyle(PlainButtonStyle())
        .pressAction {
            if !isDisabled {
                self.isPressed = true
            }
        } onRelease: {
            if !isDisabled {
                self.isPressed = false
            }
        }
        .disabled(isDisabled)
    }
}

// Extension pour détecter les événements de pression et de relâchement.
struct PressAction: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    @GestureState private var isPressed: Bool = false
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { value, state, transaction in
                        state = true
                    }
                    .onChanged { value in
                        if !isPressed {
                            onPress()
                        }
                    }
                    .onEnded { value in
                        onRelease()
                    }
            )
    }
}

extension View {
    func pressAction(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        self.modifier(PressAction(onPress: onPress, onRelease: onRelease))
    }
}
