Helpers spécifiques à la plateforme (OS, écran, etc.)

- `SystemBottomInset` : corrige le bottom inset Android (nav bar gestuelle vs
  zone tappable custom du launcher). Nécessite le handler natif côté
  `MainActivity.kt` (`getTappableBottomInset`, déjà présent) ; no-op sur iOS.

À compléter selon les besoins du projet :
  - `KeyboardInset` : widget qui s'adapte au clavier
  - `PlatformUtils` : détection OS, version, etc.
