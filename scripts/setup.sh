#!/bin/bash
# setup.sh — Configuration d'un nouveau projet à partir du boilerplate
# Usage: ./scripts/setup.sh "com.example.myapp" "MyApp"
#
# Renomme l'identifiant d'application (namespace Android + bundle iOS) et le
# nom affiché de l'app sur les deux plateformes, puis génère l'i18n et les
# fichiers Riverpod/Freezed.
#
# Ne touche PAS au `name:` de pubspec.yaml (le nom du package Dart, utilisé
# dans tous les imports `package:my_app/...`) : le renommer implique de
# réécrire les imports dans tout lib/ et test/, ce qui dépasse le cadre d'un
# renommage d'identité d'app. Si vous voulez vraiment renommer le package
# Dart, faites-le à part avec un outil dédié (ex: package `rename`) puis
# relancez `dart run build_runner build`.

set -e

cd "$(dirname "$0")/.."

NEW_APP_ID="${1:-}"
NEW_APP_NAME="${2:-}"

OLD_ANDROID_ID="com.overheatstudio.my_app"
OLD_IOS_ID="com.overheatstudio.myApp"
OLD_ANDROID_LABEL="my_app"
OLD_IOS_DISPLAY_NAME="My App"
OLD_IOS_BUNDLE_NAME="my_app"

if [ -n "$NEW_APP_ID" ]; then
  if ! [[ "$NEW_APP_ID" =~ ^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$ ]]; then
    echo "❌ Identifiant invalide : $NEW_APP_ID (attendu: format reverse-DNS, ex: com.example.myapp)"
    exit 1
  fi

  echo "📦 Renommage de l'identifiant d'application → $NEW_APP_ID"

  # --- Android : namespace + applicationId ---
  sed -i.bak "s/$OLD_ANDROID_ID/$NEW_APP_ID/g" android/app/build.gradle.kts
  rm -f android/app/build.gradle.kts.bak

  # --- Android : déplacer MainActivity.kt vers le nouveau package ---
  OLD_PKG_PATH=$(echo "$OLD_ANDROID_ID" | tr '.' '/')
  NEW_PKG_PATH=$(echo "$NEW_APP_ID" | tr '.' '/')
  OLD_MAIN_ACTIVITY="android/app/src/main/kotlin/$OLD_PKG_PATH/MainActivity.kt"
  NEW_MAIN_ACTIVITY="android/app/src/main/kotlin/$NEW_PKG_PATH/MainActivity.kt"
  if [ -f "$OLD_MAIN_ACTIVITY" ] && [ "$OLD_MAIN_ACTIVITY" != "$NEW_MAIN_ACTIVITY" ]; then
    mkdir -p "$(dirname "$NEW_MAIN_ACTIVITY")"
    sed "s/$OLD_ANDROID_ID/$NEW_APP_ID/" "$OLD_MAIN_ACTIVITY" > "$NEW_MAIN_ACTIVITY"
    rm "$OLD_MAIN_ACTIVITY"
    find "android/app/src/main/kotlin" -type d -empty -delete
  fi

  # --- iOS : bundle identifier (même identifiant que côté Android) ---
  sed -i.bak "s/$OLD_IOS_ID/$NEW_APP_ID/g" ios/Runner.xcodeproj/project.pbxproj
  rm -f ios/Runner.xcodeproj/project.pbxproj.bak

  # --- CI : packageName utilisé pour l'upload Play Store ---
  if [ -f .github/workflows/android.yml ]; then
    sed -i.bak "s/$OLD_ANDROID_ID/$NEW_APP_ID/g" .github/workflows/android.yml
    rm -f .github/workflows/android.yml.bak
  fi
fi

if [ -n "$NEW_APP_NAME" ]; then
  echo "🏷️  Renommage du nom affiché → $NEW_APP_NAME"

  # --- Android : android:label ---
  sed -i.bak "s/android:label=\"$OLD_ANDROID_LABEL\"/android:label=\"$NEW_APP_NAME\"/" \
    android/app/src/main/AndroidManifest.xml
  rm -f android/app/src/main/AndroidManifest.xml.bak

  # --- iOS : CFBundleDisplayName + CFBundleName ---
  sed -i.bak "s/<string>$OLD_IOS_DISPLAY_NAME<\/string>/<string>$NEW_APP_NAME<\/string>/;
              s/<string>$OLD_IOS_BUNDLE_NAME<\/string>/<string>$NEW_APP_NAME<\/string>/" \
    ios/Runner/Info.plist
  rm -f ios/Runner/Info.plist.bak
fi

if [ -z "$NEW_APP_ID" ] && [ -z "$NEW_APP_NAME" ]; then
  echo "ℹ️  Aucun identifiant/nom fourni — le renommage est ignoré (template laissé tel quel)."
fi

# 1. Générer i18n
echo "📦 Génération i18n..."
(cd i18n && dart run intl_utils:generate)

# 2. Générer les fichiers Riverpod / Freezed
echo "🏗️  Code generation..."
dart run build_runner build --delete-conflicting-outputs

# 3. Vérifier que tout compile
echo "✅ Vérification..."
dart analyze

echo ""
echo "🎉 Projet prêt !"
[ -n "$NEW_APP_ID" ] && echo "   Application ID : $NEW_APP_ID"
[ -n "$NEW_APP_NAME" ] && echo "   Nom            : $NEW_APP_NAME"
echo ""
echo "📱 Lancer : flutter run --dart-define=API_APP_TOKEN=xxx"
