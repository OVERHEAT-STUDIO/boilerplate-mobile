# Contributing — Boilerplate Flutter Overheat Studio

## Principes généraux

- **Feature-first** : chaque feature est isolée dans `lib/features/<feature>/`
- **Riverpod** : toute dépendance passe par un Provider — pas de singleton
- **Freezed** : tous les modèles et states utilisent `@freezed`
- **Tests** : les controllers et repositories doivent être testables (mock des dépendances)

## Workflow Git

```bash
# Créer une branche
git checkout -b feature/ma-feature

# Commit
git commit -m "feat: ajout de ma feature"
# Types : feat, fix, refactor, chore, docs, test

# PR
gh pr create --title "feat: ma feature" --body "Description"
```

Les branches `main` sont protégées — toujours passer par une PR.

## Convention de commits

| Type | Usage |
|---|---|
| `feat` | Nouvelle fonctionnalité |
| `fix` | Correction de bug |
| `refactor` | Refacto sans changement fonctionnel |
| `chore` | Tâche technique (deps, config) |
| `docs` | Documentation |
| `test` | Tests |

## Ajouter une feature

1. Créer la structure `lib/features/<feature>/data/` et `presentation/`
2. Déclarer les providers Riverpod
3. Ajouter les routes dans `app_router.dart`
4. Ajouter les clés i18n dans les fichiers `.arb`
5. Lancer `dart run build_runner build --delete-conflicting-outputs`
6. Tester

## Code generation

Toujours après avoir modifié :
- Un model Freezed → `dart run build_runner build`
- Un provider Riverpod → `dart run build_runner build`
- Les fichiers `.arb` → `cd i18n && dart run intl_utils:generate`

```bash
# Tout d'un coup
dart run build_runner build --delete-conflicting-outputs
cd i18n && dart run intl_utils:generate
```

## Review

- Vérifier que les providers sont bien typés
- Vérifier qu'il n'y a pas de `static final instance` (sauf couleurs)
- Vérifier que les erreurs API sont catchées et passent en `AsyncData(errorMessage: ...)`
- Vérifier que les clés i18n existent dans toutes les langues