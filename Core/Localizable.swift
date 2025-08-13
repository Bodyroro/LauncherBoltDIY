//
//  Localizable.swift
//  LauncherBoltDIY
//
//  Created by Bodyroro on 12/08/2025.
//  Copyright © 2025 Bodyroro. All rights reserved.
//

import Foundation

// Définitions des codes ANSI pour la console
// Ces codes permettent de colorer le texte dans la console.
enum ConsoleColor {
    static let green = "\u{001B}[32m"
    static let yellow = "\u{001B}[33m"
    static let red = "\u{001B}[31m"
    static let blue = "\u{001B}[34m"
    static let reset = "\u{001B}[0m"
}

// Struct pour stocker toutes les chaînes de caractères de l'application
struct Localizable {
    
    // MARK: - Titres et labels de l'interface
    static let appTitle = "Lanceur Bolt DIY"
    static let installButton = "Installer"
    static let launchButton = "Lancer"
    static let stopButton = "Stopper"
    static let updateButton = "Mettre à jour"
    static let deleteButton = "Supprimer"
    static let openWebButton = "Ouvrir Web"
    static let settingsButton = "⚙️ Paramètres"
    static let consoleTitle = "Console"
    static let localCommitLabel = "Version Installé:"
    static let remoteCommitLabel = "Version Github:"
    static let settingsTitle = "Réglages de l'application"
    static let gitPathLabel = "Chemin de Git:"
    static let nodePathLabel = "Chemin de Node:"
    static let pnpmPathLabel = "Chemin de PNPM:"
    static let projectFolderLabel = "Dossier parent du projet:"
    static let restoreButton = "Restaurer les réglages par défaut"
    static let closeButton = "Fermer"
    static let executablesSectionTitle = "Chemins des exécutables"
    static let projectSectionTitle = "Chemin du projet"
    static let creditsLink = "GitHub Bolt DIY"
    static let readmeLink = "README"
    static let changelogLink = "CHANGELOG"
    static let readmeTitle = "README.md"
    static let changelogTitle = "CHANGELOG.md"
    static let notAvailable = "N/A"
    static let error = "Erreur"
    static let footer = "Créé avec ❤️ par Bodyroro"
    static let processing = "Traitement en cours..."
    
    // MARK: - Messages de log de la console
    
    // Messages généraux
    static let generalLog = ConsoleColor.blue + "Log de l'application" + ConsoleColor.reset
    static let installLog = "\n--- Installation de Bolt DIY ---\n"
    static let launchLog = "\n--- Lancement du serveur de développement ---\n"
    static let updateLog = "\n--- Mise à jour du projet ---\n"
    static let deleteLog = "\n--- Suppression du projet ---\n"
    static let checkLog = "\n--- Vérification de l'état du projet ---\n"
    static let stopLog = "\n--- Arrêt du serveur ---\n"
    static let openWebLog = "\n--- Ouverture de l'interface web ---\n"
    static let executingCommandLog = "> Exécution de la commande: "
    static let commandFailedLog = ConsoleColor.red + "❌ Échec de la commande: " + ConsoleColor.reset
    
    // Installation et mise à jour
    static let cloningStarted = ConsoleColor.blue + "⏳ Clonage du dépôt Git..." + ConsoleColor.reset
    static let cloningSuccess = ConsoleColor.green + "✅ Clonage terminé avec succès." + ConsoleColor.reset
    static func cloningFailed(code: Int32) -> String { ConsoleColor.red + "❌ Échec du clonage. Code de sortie : \(code)" + ConsoleColor.reset }
    static let pnpmInstallStarted = ConsoleColor.blue + "⏳ Installation des dépendances avec pnpm..." + ConsoleColor.reset
    static let pnpmInstallSuccess = ConsoleColor.green + "✅ Installation terminée avec succès." + ConsoleColor.reset
    static func pnpmInstallFailed(code: Int32) -> String { ConsoleColor.red + "❌ Échec de l'installation des dépendances. Code de sortie : \(code)" + ConsoleColor.reset }
    static let updateStarted = ConsoleColor.blue + "⏳ Mise à jour de Bolt Diy..." + ConsoleColor.reset
    static let updateSuccess = ConsoleColor.green + "✅ Mise à jour terminée." + ConsoleColor.reset
    static func updateFailed(code: Int32) -> String { ConsoleColor.red + "❌ Échec de la mise à jour. Code de sortie : \(code)" + ConsoleColor.reset }
    
    // Statut du projet
    static let projectNotFound = "❌ Bolt Diy introuvable."
    static let projectExists = "⚠️ Bolt Diy existe déjà."
    static let upToDate = ConsoleColor.green + "✅ Bolt Diy est déjà à jour." + ConsoleColor.reset
    static let updateNeeded = "⚠️ Bolt Diy installé est obselete. Une mise à jour est nécessaire."
    static let dirtyRepoWarning = "⚠️ Des fichiers locaux ont été modifiés ou manquent. Une mise à jour est recommandée."
    
    // Serveur
    static let serverAlreadyRunning = "⚠️ Bolt Diy est déjà en cours d'exécution."
    static let serverStartSuccess = ConsoleColor.green + "✅ Bolt Diy démarré sur http://localhost:5173." + ConsoleColor.reset
    static let serverStartFailed = "❌ Bolt Diy n'a pas pu démarrer."
    static let serverStartLog = ConsoleColor.blue + "⏳ Démarrage de Bolt Diy..." + ConsoleColor.reset
    static let serverStopLog = ConsoleColor.blue + "⏳ Arrêt de Bolt Diy en cours..." + ConsoleColor.reset
    static let serverStopSuccess = ConsoleColor.green + "✅ Bolt Diy stoppé." + ConsoleColor.reset
    static let serverStopFailed = "⚠️ Bolt Diy n'est pas en cours d'exécution."
    static let processTerminated = "❌ Le processus de Bolt Diy s'est terminé."
    
    // Divers
    static func executableNotFound(path: String) -> String { "❌ Exécutable introuvable: \(path)" }
    static let deleteStarted = ConsoleColor.blue + "⏳ Suppression du projet en cours..." + ConsoleColor.reset
    static let deleteSuccess = ConsoleColor.green + "✅ Le projet a été supprimé." + ConsoleColor.reset
    static func deleteFailed(error: String) -> String { "❌ Échec de la suppression: \(error)" }
    static let webInterfaceOpen = "✅ Ouverture de l'interface web dans votre navigateur: "
    static let urlError = "❌ Erreur: URL invalide."
    
    // Nouveaux messages pour le choix du navigateur
    static let chromeRecommendation = "Chrome est fortement recommandé pour une bonne compatibilité avec Bolt DIY."
    static let openWebError = "❌ Échec de l'ouverture de l'URL."
    
    // MARK: - README et Changelog
     
     static let readmeContent = """
     # Bolt DIY Launcher

     Ce lanceur vous permet de gérer facilement votre projet Bolt DIY.

     ## Fonctionnalités

     - ** Installation ** : Clone le dépôt GitHub et installe les dépendances avec pnpm.
     - ** Lancer / Arrêter ** : Démarre ou arrête le serveur de développement.
     - ** Mise à jour ** : Met à jour votre projet avec la dernière version du dépôt distant.
     - ** Suppression ** : Supprime le dossier du projet.
     - ** Interface Web ** : Ouvre le site local dans votre navigateur par défaut.

     ## Configuration

     Vous pouvez configurer les chemins des exécutables (`git`, `pnpm`, `node`) ainsi que le dossier parent du projet via les paramètres de l'application (⚙️).
     """

     static let changelogContent = """
     ## CHANGELOG

     V1.0.0 -  _12/08/2025_
     - ** Ajout ** : Intégration d'un sélecteur de thème (Clair/Sombre/Système).
     - ** Ajout ** : Indicateurs de progression pour les tâches longues (installation, mise à jour).
     - ** Ajout ** : Indicateurs de statut des commits (local/distant) avec un état de chargement.
     - ** Ajout ** : Bouton pour ouvrir l'interface web, avec sélection du navigateur.
     - ** Ajout ** : Page de paramètres pour les chemins d'accès.
     - ** Ajout ** : Bouton pour restaurer les paramètres par défaut.
     - ** Ajout ** : Page de crédits avec lien vers le dépôt GitHub.
     
     ---
     
     """
}
