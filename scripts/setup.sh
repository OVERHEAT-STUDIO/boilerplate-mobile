#!/bin/bash
# setup.sh — Script de configuration du projet
# Usage: ./scripts/setup.sh "com.example.myapp" "MyApp"

set -e

APP_ID="${1:-com.overheatstudio.myapp}"
APP_NAME="${2:-MyApp}"

echo "🔧 Configuration du projet : $APP_NAME ($APP_ID)"

# 1. Générer i18n
echo "📦 Génération i18n..."
cd i18n && dart run intl_utils:generate && cd ..

# 2. Générer les fichiers Riverpod / Freezed
echo "🏗️  Code generation..."
dart run build_runner build --delete-conflicting-outputs

# 3. Vérifier que tout compile
echo "✅ Vérification..."
dart analyze

echo ""
echo "🎉 Projet prêt !"
echo "   Application ID : $APP_ID"
echo "   Nom           : $APP_NAME"
echo ""
echo "📱 Lancer : flutter run --dart-define=API_APP_TOKEN=xxx"