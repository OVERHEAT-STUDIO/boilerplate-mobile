# CLAUDE.md — Boilerplate Flutter Overheat Studio

> Instructions pour les assistants IA travaillant sur ce projet.

## Architecture

Voir [ARCHITECTURE.md](./ARCHITECTURE.md) pour la documentation complète.

## Stack

- **State management** : Riverpod (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`)
- **Routing** : GoRouter (`go_router`)
- **Réseau** : Dio (`dio`)
- **Modèles** : Freezed (`@freezed` + `json_serializable`)
- **Stockage** : `flutter_secure_storage` + `hive_ce`
- **Thème** : `adaptive_theme` + `ColorsAbstract`
- **i18n** : Package local `i18n/` via `intl_utils` (fichiers `.arb`)
- **Responsive** : `.w` / `.h` extensions avec breakpoint tablette 600dp

## Commandes fréquentes

```bash
# Générer les fichiers Riverpod + Freezed
dart run build_runner build --delete-conflicting-outputs

# Générer l'i18n
cd i18n && dart run intl_utils:generate && cd ..

# Watcher (génération continue)
dart run build_runner watch --delete-conflicting-outputs
```

## Règles strictes

1. **Zéro singleton statique** sauf `ColorsLight`/`ColorsDark` — toute dépendance via Provider Riverpod
2. **`ref.read` dans les méthodes, `ref.watch` dans `build()`**
3. **`keepAlive: true`** uniquement pour storage, dio, auth, router
4. **Les pages ne contiennent PAS de logique métier** → déléguer aux controllers
5. **Toujours catch les erreurs API** → `AsyncData` avec `errorMessage`, jamais `AsyncError`
6. **Les fichiers `*.g.dart`, `*.freezed.dart` sont committés** (ne pas les ignorer)
7. **Après tout renommage de méthode/enum**, grep systématique sur tout le codebase

## Styles

- Fichiers : `snake_case.dart`
- Classes : `PascalCase`
- Providers : `camelCase` + `Provider`
- Couleurs : `<catégorie><Variante><Intensité>` (ex: `backgroundDefaultDefault`)

## Accès au thème

```dart
context.colors              // → ColorsAbstract
context.textStyles          // → AppTextStyles
context.textStyles.base_b.withColor(context.colors.textDefaultDefault)
context.colors.backgroundDefaultDefault.applyOpacity(0.5)  // core/extensions/color_extensions.dart
```

## Responsive

```dart
24.w  // largeur adaptative (référence: mobile 430px, tablet 1366px)
48.h  // hauteur adaptative (référence: mobile 932px, tablet 1024px)
```

## i18n

```dart
// Avec BuildContext
final t = I18n.of(context);
t.retry
t.welcomeUser('Thomas')

// Sans BuildContext (controller)
final t = I18n.current;
t.errorApiGenericError
```

## Nouvelle feature

1. Créer `lib/features/<feature>/` avec la structure `data/`, `presentation/`
2. Déclarer le repository, le controller, les states
3. Ajouter les routes dans `app_router.dart`
4. Ajouter les clés i18n dans `i18n/lib/src/l10n/intl_fr.arb` et `intl_en.arb`
5. Générer : `dart run build_runner build --delete-conflicting-outputs`