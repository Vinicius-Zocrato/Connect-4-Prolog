# Connect 4 - Prolog

Un jeu de Puissance 4 (Connect 4) développé en Prolog avec plusieurs intelligences artificielles.

## 🎮 Intelligences Artificielles Disponibles

Le projet implémente plusieurs types d'IA avec différents niveaux de complexité :

- **Random AI** (`randomAI.pl`) : Joue des coups aléatoires
- **Blocking/Winning AI** (`blockingWiningAI.pl`) : Bloque les victoires adverses et cherche à gagner
- **Minimax AI** (`minimaxAI.pl`) : Algorithme minimax basique
- **Minimax avec Alpha-Beta** (`minimaxAI_alphabeta.pl`) : Minimax optimisé avec élagage alpha-bêta
- **Minimax avec Scoring** (`minmaxAI_scoring.pl`) : Minimax avec fonction d'évaluation améliorée
- **Minimax Alpha-Beta Optimisé** (`minimaxAI_ab_opti.pl`) : Version optimisée combinant alpha-bêta et scoring

## 🚀 Lancer le Projet

### Prérequis
- SWI-Prolog installé sur votre système

### Exécution

```bash
swipl project/projet.pl
```

Ou utilisez la tâche VS Code configurée : **Run Project**

## 🧪 Lancer les Tests

```bash
swipl -s tests/tests.pl -g run_tests -t halt
```

Les tests couvrent les différentes fonctionnalités du jeu (détection de victoire, mouvements, etc.).

## 📁 Structure du Projet

```
project/
├── projet.pl              # Fichier principal
├── display.pl             # Affichage du plateau
├── win.pl                 # Détection de victoire
├── moves.pl               # Gestion des coups
├── handlePlayers.pl       # Gestion des joueurs
├── lists.pl               # Utilitaires pour listes
├── utils_minimax.pl       # Utilitaires minimax
└── [fichiers IA]          # Différentes IA

tests/
└── tests.pl               # Suite de tests
```
