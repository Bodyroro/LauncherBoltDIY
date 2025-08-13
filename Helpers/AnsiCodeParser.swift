//
//  AnsiCodeParser.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import Foundation
import AppKit

// La classe AnsiCodeParser contient la logique pour analyser les codes ANSI.
// Ceci permet de colorer les messages de la console.
class AnsiCodeParser {
    
    static func parseAnsiCodes(from string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        
        let regex = try! NSRegularExpression(pattern: "\\x1B\\[([0-9]{1,2})m")
        let fullRange = NSRange(location: 0, length: attributedString.length)
        
        // On récupère toutes les correspondances de codes ANSI
        let matches = regex.matches(in: attributedString.string, options: [], range: fullRange)
        
        // On parcourt les correspondances à l'envers pour ne pas fausser les index
        matches.reversed().forEach { match in
            guard match.numberOfRanges > 1, let codeRange = Range(match.range(at: 1), in: attributedString.string) else { return }
            let code = attributedString.string[codeRange]
            
            var color: NSColor? = nil
            switch code {
            case "31": color = .systemRed // Couleur rouge
            case "32": color = .systemGreen // Couleur verte
            case "33": color = .systemYellow // Couleur jaune
            case "34": color = .systemBlue // Couleur bleue
            case "0": color = .textColor // Couleur par défaut (blanc pour le dark mode)
            default: break
            }
            
            if let color = color {
                // On applique la couleur au texte qui suit le code ANSI
                let textRangeToColor = NSRange(location: match.range.location + match.range.length, length: attributedString.length - (match.range.location + match.range.length))
                attributedString.addAttributes([.foregroundColor: color], range: textRangeToColor)
            }
            
            // On supprime le code ANSI lui-même pour qu'il ne s'affiche pas
            attributedString.mutableString.deleteCharacters(in: match.range)
        }
        
        return attributedString
    }
}
