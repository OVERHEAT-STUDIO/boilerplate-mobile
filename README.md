# Boilerplate Flutter — Overheat Studio

> Template officiel pour toutes les applications Flutter d'Overheat Studio.
> Architecture **feature-first**, **Riverpod**, **GoRouter**, **Freezed**, **Dio**, **i18n**, thème adaptatif et responsive.

> **État** : projet validé avec Flutter 3.47.0 (stable) — `flutter pub get`,
> `dart run build_runner build`, `flutter analyze` (0 erreur) et
> `flutter test` passent tous. Les dossiers `android/` et `ios/` sont générés
> et committés ; les polices Nunito et JetBrains Mono incluses dans
> `assets/fonts/` sont sous licence OFL (voir les fichiers `*-OFL.txt` à
> côté). La police "Newake" n'est pas fournie (licence non libre) — ajoutez
> le `.ttf` de votre projet si besoin.

---

## ✨ Stack

| Catégorie | Technologie |
|---|---|
| **State management & DI** | `flutter_riverpod` + `riverpod_annotation` + `riverpod_generator` |
| **Routing** | `go_router` |
| **Réseau** | `dio` |
| **Modèles** | `freezed` + `json_serializable` |
| **Stockage sécurisé** | `flutter_secure_storage` |
| **Cache local** | `hive_ce` + `hive_ce_flutter` |
| **Thème adaptatif** | `adaptive_theme` |
| **i18n** | Package local `i18n/` (intl_utils, .arb) |
| **Icônes** | `lucide_icons_flutter` |
| **Responsive** | `.w` / `.h` scaling avec breakpoint tablette 600dp |

---

## 🚀 Démarrage rapide

```bash
# Renomme l'identifiant d'app (Android + iOS) et le nom affiché, puis
# génère l'i18n et les fichiers Riverpod/Freezed.
./scripts/setup.sh "com.example.myapp" "MyApp"
```

`scripts/setup.sh` ne renomme **pas** le `name:` de `pubspec.yaml` (le nom du
package Dart, utilisé dans tous les imports `package:my_app/...`) : le
changer implique de réécrire les imports dans tout `lib/` et `test/`, ce qui
dépasse le cadre d'un renommage d'identité d'app. Voir les commentaires en
tête du script pour le détail.

Équivalent manuel, si vous préférez ne pas renommer l'identifiant :

```bash
# Générer les fichiers i18n
cd i18n && dart run intl_utils:generate && cd ..

# Générer les fichiers Riverpod / Freezed
dart run build_runner build --delete-conflicting-outputs
```

```bash
# Lancer
flutter run --dart-define=API_APP_TOKEN=xxx
```

> **Important** : Les fichiers `*.g.dart`, `*.freezed.dart` et `i18n/lib/src/generated/` sont committés dans Git.

---

## 📁 Structure

```
my_app/
├── i18n/                       # Package local d'internationalisation
│   ├── lib/src/l10n/           #   Sources .arb (à éditer)
│   ├── lib/src/generated/      #   Généré (ne pas éditer)
│   └── lib/i18n.dart           #   Export public
├── lib/
│   ├── main.dart               # Bootstrap (init services, détection tablette…)
│   ├── app.dart                # Widget racine (MaterialApp.router + AdaptiveTheme)
│   ├── app_router.dart         # GoRouter global (Riverpod provider keepAlive)
│   ├── core/                   # Modules transverses
│   │   ├── api/                #   Dio, ApiException, ApiResponse
│   │   ├── config/             #   Flags, constantes app
│   │   ├── constants/          #   Breakpoints
│   │   ├── errors/             #   ApiErrorMapper, ErrorsManager
│   │   ├── extensions/         #   ColorExtensions (Color.applyOpacity)
│   │   ├── local_storage/      #   LocalStorageManager (secure storage)
│   │   ├── localization/       #   AppLocalizationNotifier
│   │   ├── navigation/         #   Route observer
│   │   ├── notifications/      #   Notification service (template)
│   │   ├── platform/           #   Platform helpers
│   │   ├── theme/              #   AppTheme, ColorsAbstract, AppTextStyles
│   │   ├── utils/              #   Responsive, HapticManager, Date, LaunchURL
│   │   └── widgets/            #   Composants UI réutilisables
│   └── features/               # Features métier (feature-first)
│       ├── auth/               #   Exemple complet
│       ├── home/               #   Exemple page d'accueil
│       ├── settings/           #   Exemple réglages
│       ├── user/               #   Template
│       └── …/
├── assets/
│   ├── fonts/
│   └── images/
├── .github/workflows/          # CI : build Android + bump version + i18n check
├── ARCHITECTURE.md             # Documentation architecture complète
├── CLAUDE.md                   # Instructions IA (Claude Code / Hermes)
└── CONTRIBUTING.md             # Règles de contribution
```

### Organisation d'une feature

```
lib/features/<feature>/
├── data/
│   ├── models/                 # Freezed + JsonSerializable
│   └── repositories/           # Appels API + mock_*_repository.dart
├── domain/                     # Règles métier pures (optionnel)
└── presentation/
    ├── controllers/            # Riverpod Notifiers + states
    ├── logic/                  # Calculs purs (optionnel)
    ├── pages/                  # *.dart → *_mobile.dart / *_tablet.dart
    ├── services/               # Services propres à la feature
    ├── utils/
    └── widgets/
```

---

## 🧱 Règles absolues

| Règle | Description |
|---|---|
| **DI** | Zéro singleton statique — toute dépendance via un Provider Riverpod |
| **ref** | `ref.read` dans les méthodes, `ref.watch` dans `build()` |
| **keepAlive** | `keepAlive: true` uniquement pour les ressources globales (storage, dio, auth, router) |
| **Pages** | Pas de logique métier dans les pages — déléguer aux controllers |
| **Erreurs** | Toujours en `AsyncData` avec `errorMessage`, jamais en `AsyncError` sauf blocage total |
| **Widgets** | Pas de `build` > ~80 lignes — décomposer |
| **Fichiers** | `snake_case` pour les fichiers, `PascalCase` pour les classes |
| **Générés** | Committer `*.g.dart`, `*.freezed.dart` — masqués dans les PRs via `.gitattributes` |

---

## 🎨 Palette de couleurs

Toutes les couleurs suivent la convention `<catégorie><Variante><Intensité>` :

- **catégorie** : background / text / icon / border
- **Variante** : Default / Primary / Secondary / Error / Warning / Info / Tertiary
- **Intensité** : Default / Secondary / Tertiary / Transparent

Accès : `context.colors.backgroundDefaultDefault`

---

## 📖 Documentation

- **[ARCHITECTURE.md](./ARCHITECTURE.md)** — Guide de référence complet
- **[CLAUDE.md](./CLAUDE.md)** — Instructions pour les assistants IA
- **[CONTRIBUTING.md](./CONTRIBUTING.md)** — Règles de contribution

---

## 🐙 Workflows GitHub

| Workflow | Déclencheur | Description |
|---|---|---|
| `android.yml` | `workflow_dispatch` ou après bump-version | Build AAB + upload Play Store (internal track) |
| `bump-version.yml` | Push sur `main` | Incrémente le build number |
| `check-i18n.yml` | PR | Vérifie que les fichiers .arb sont synchronisés |

---

<p align="center">Overheat Studio — 2026</p>