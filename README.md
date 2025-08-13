<p align="center">
  <a href="#français">🇫🇷 Français</a> | <a href="#english">🇺🇸 English</a>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/cff6f1e3-350e-4764-9048-603748ed420e" alt="1" width="49%" />
  <img src="https://github.com/user-attachments/assets/cec5d204-6abd-4420-8c0a-c4ef68bdb01a" alt="2" width="49%" />
</p>

---

# <a id="français"></a>🚀 Lanceur Bolt DIY

Ce lanceur vous permet de gérer facilement votre projet Bolt DIY. C'est l'outil idéal pour démarrer, mettre à jour et gérer votre environnement de développement de manière intuitive, le tout depuis une interface native macOS.

---

### **Fonctionnalités Clés**

Le lanceur simplifie la gestion de votre projet avec une série d'actions claires et concises.

* **Installation** : Lancez l'installation en un clic. Le lanceur clone automatiquement le dépôt GitHub de Bolt DIY et installe toutes les dépendances nécessaires pour que vous puissiez commencer à utiliser le projet immédiatement.
* **Lancer / Arrêter** : Démarrez ou arrêtez votre projet Bolt DIY en un seul clic, sans avoir à manipuler la ligne de commande.
* **Mise à jour** : Maintenez votre projet à jour avec la dernière version du dépôt distant pour bénéficier des nouvelles fonctionnalités et des correctifs.
* **Suppression** : Supprimez le dossier du projet de manière rapide et sécurisée. Une confirmation est requise pour éviter toute suppression accidentelle.
* **Interface Web** : Accédez directement à votre projet Bolt DIY en local dans votre navigateur par défaut, sans avoir à taper l'URL manuellement.

---

### **Prérequis et Installation**

Pour utiliser ce lanceur, vous devez installer quelques dépendances. Une fois cela fait, vous pourrez facilement configurer le projet via Xcode.

#### **Prérequis**

* **Git**
    * **Description** : Un système de contrôle de version indispensable pour cloner le dépôt du projet.
    * **Installation** :
        * [Télécharger sur le site officiel](https://git-scm.com/downloads)
        * Installer via Homebrew (sur macOS) :
            ```bash
            brew install git
            ```
* **pnpm**
    * **Description** : Un gestionnaire de paquets JavaScript rapide et efficace. Il est utilisé par le projet Bolt DIY pour installer ses dépendances.
    * **Installation** :
        * Assurez-vous d'avoir [Node.js](#nodejs) installé au préalable.
        * Installer pnpm via npm :
            ```bash
            npm install -g pnpm
            ```
        * [Instructions complètes sur le site officiel](https://pnpm.io/installation)
* **Node.js**
    * **Description** : L'environnement d'exécution JavaScript requis par pnpm et votre projet Bolt DIY.
    * **Installation** :
        * [Télécharger sur le site officiel](https://nodejs.org/en/download)
        * Installer via nvm (recommandé pour gérer plusieurs versions de Node.js) :
            ```bash
            nvm install --lts
            ```
            (Si vous n'avez pas nvm, vous pouvez l'installer avec `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash`)

#### **Guide d'Installation via Xcode**

Si vous ne possédez que les fichiers Swift et que vous souhaitez recréer le projet de lanceur depuis zéro, suivez ces étapes détaillées :

1.  **Créer un nouveau projet Xcode**
    * Ouvrez **Xcode**.
    * Allez dans le menu **File > New > Project...**.
    * Dans la fenêtre de sélection, choisissez l'onglet **macOS** et l'option **App**, puis cliquez sur **Next**.
    * Nommez votre projet (par exemple, "BoltDIYLauncher"), assurez-vous que le langage est **Swift**, et choisissez l'emplacement de sauvegarde.

2.  **Ajouter les fichiers Swift**
    * Dans le **Project Navigator** (la barre latérale gauche), faites un clic droit sur le dossier de votre projet.
    * Sélectionnez **Add Files to "[Nom de votre projet]"...**.
    * Sélectionnez et ajoutez tous les fichiers `.swift` que vous avez. Assurez-vous que l'option "Copy items if needed" est cochée.

3.  **Ajouter la dépendance MarkdownUI**
    * Sélectionnez le nom de votre projet dans le **Project Navigator**.
    * Naviguez vers l'onglet **Package Dependencies**.
    * Cliquez sur le bouton **+** pour ajouter un nouveau paquet Swift.
    * Dans la barre de recherche en haut à droite, ajoutez l'URL du dépôt GitHub de MarkdownUI : `https://github.com/gonzalezreal/MarkdownUI`.
    * Choisissez les options par défaut et confirmez l'ajout du paquet en cliquant sur "Add Package".

---

### **Feuille de Route**

Voici les futures améliorations prévues pour le projet.

* **Multilingue** : Ajout de la prise en charge d'autres langues pour une utilisation internationale.
* **Installation Intégrée** : Intégration de liens de téléchargement directs pour Git, pnpm et Node.js depuis l'application.
* **Tutoriels** : Intégration de guides d'utilisation (Clé API, LLM en local, etc.) directement dans l'application.
* **Écran de Bienvenue** : Ajout d'un écran de bienvenue pour une configuration initiale facile (choix de la langue, du navigateur, etc.).

---

### **Changelog - V1.0.0**

* _13/08/2025_
* **Sélecteur de thème** : Ajout d'un sélecteur de thème permettant de choisir entre le mode clair, sombre ou le thème du système.
* **Indicateurs de progression** : Ajout d'indicateurs visuels pour les tâches longues (installation, mise à jour) afin de mieux suivre leur avancement.
* **Indicateurs de statut** : Mise en place d'indicateurs de statut pour les commits (local/distant) et un état de chargement.
* **Bouton d'interface web** : Ajout d'un bouton pour ouvrir l'interface web de Bolt DIY avec une option pour sélectionner le navigateur de votre choix.
* **Page de paramètres** : Création d'une page de paramètres pour configurer les chemins d'accès et d'autres préférences. Un bouton a été ajouté pour restaurer les paramètres par défaut.
* **Page de crédits** : Ajout d'une page de crédits avec un lien vers le dépôt GitHub du projet.

---

### **Contribution**

Ce projet est **libre et open-source**. Votre aide est la bienvenue ! N'hésitez pas à proposer des améliorations, des corrections de bugs ou des suggestions de nouvelles fonctionnalités. Vous pouvez le faire en ouvrant une *issue* ou en soumettant une *pull request* sur le dépôt GitHub.

---

### **Crédits**

* **Créateur du Lanceur** : Bodyroro
* **Projet Bolt DIY** : [stackblitz-labs/bolt.diy](https://github.com/stackblitz-labs/bolt.diy)

---

# <a id="english"></a>🇺🇸 **English Version**

### **Key Features**

This launcher simplifies project management with a series of clear and concise options.

* **Installation** : Launch the installation with a single click. The launcher automatically clones the Bolt DIY GitHub repository and installs all the necessary dependencies so you can start using the project right away.
* **Start / Stop** : Start or stop your Bolt DIY project with a single click, without needing to use the command line.
* **Update** : Keep your project up to date with the latest version from the remote repository to benefit from new features and bug fixes.
* **Deletion** : Quickly and safely delete the project folder. Confirmation is required to prevent accidental deletion.
* **Web Interface** : Directly access your local Bolt DIY project in your default browser, without having to manually type the URL.

---

### **Prerequisites & Installation**

To use this launcher, you must first install a few dependencies. Once this is done, you can configure the project via Xcode.

#### **Prerequisites**

* **Git**
    * **Description** : An essential version control system for cloning the project repository.
    * **Installation** :
        * [Download from the official website](https://git-scm.com/downloads)
        * Install via Homebrew (on macOS) :
            ```bash
            brew install git
            ```
* **pnpm**
    * **Description** : A fast and efficient JavaScript package manager. It is used by the Bolt DIY project to install its dependencies.
    * **Installation** :
        * Make sure you have [Node.js](#nodejs) installed first.
        * Install pnpm via npm :
            ```bash
            npm install -g pnpm
            ```
        * [Full instructions on the official website](https://pnpm.io/installation)
* **Node.js**
    * **Description** : The JavaScript runtime environment required by pnpm and your Bolt DIY project.
    * **Installation** :
        * [Download from the official website](https://nodejs.org/en/download)
        * Install via nvm (recommended for managing multiple Node.js versions) :
            ```bash
            nvm install --lts
            ```
            (If you don't have nvm, you can install it with `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash`)

#### **Installation Guide via Xcode**

If you only have the Swift files and want to recreate the launcher project from scratch, follow these detailed steps :

1.  **Create a new Xcode project**
    * Open **Xcode**.
    * Go to the menu **File > New > Project...**.
    * In the selection window, choose the **macOS** tab and the **App** option, then click **Next**.
    * Name your project (e.g., "BoltDIYLauncher"), make sure the language is **Swift**, and choose the save location.

2.  **Add the Swift files**
    * In the **Project Navigator** (the left sidebar), right-click on your project's folder.
    * Select **Add Files to "[Your Project Name]"...**.
    * Select and add all the `.swift` files you have. Make sure the "Copy items if needed" option is checked.

3.  **Add the MarkdownUI dependency**
    * Select your project's name in the **Project Navigator**.
    * Navigate to the **Package Dependencies** tab.
    * Click the **+** button to add a new Swift package.
    * In the search bar at the top right, add the GitHub repository URL for MarkdownUI : `https://github.com/gonzalezreal/MarkdownUI`.
    * Choose the default options and confirm by clicking "Add Package".

---

### **Roadmap**

Here are the future improvements planned for the project.

* **Multilingual Support** : Adding support for other languages for international use.
* **Integrated Installation** : Integrating direct download links for Git, pnpm, and Node.js from within the application.
* **Tutorials** : Integrating usage guides (API Key, local LLM, etc.) directly into the application.
* **Welcome Screen** : Adding a welcome screen for easy initial configuration (language choice, browser selection, etc.).

---

### **Changelog - V1.0.0**

* _08/13/2025_
* **Theme selector** : Added a theme selector allowing users to choose between light mode, dark mode, or the system theme.
* **Progress indicators** : Added visual indicators for long tasks (installation, updates) to better track their progress.
* **Status indicators** : Implemented status indicators for commits (local/remote) and a loading state.
* **Web interface button** : Added a button to open the Bolt DIY web interface with an option to select your preferred browser.
* **Settings page** : Created a settings page to configure executable paths and other preferences. A button has been added to restore default settings.
* **Credits page** : Added a credits page with a link to the project's GitHub repository.

---

### **Contribution**

This project is **free and open-source**. I welcome any suggestions, bug fixes, or new feature additions. Feel free to open an issue or submit a pull request!

---

### **Credits**

* **Launcher Creator** : Bodyroro
* **Bolt DIY Project** : [stackblitz-labs/bolt.diy](https://github.com/stackblitz-labs/bolt.diy)

---
