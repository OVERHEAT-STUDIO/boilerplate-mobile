# Architecture Flutter — Boilerplate Overheat Studio

> Ce document est la source de vérité pour l'architecture de toutes les applications Flutter d'Overheat Studio.
> Il couvre le core complet : structure, packages, patterns, thème, responsive et i18n.

---

## Table des matières

1. [Philosophie](#1-philosophie)
2. [Stack technique](#2-stack-technique)
3. [Structure du projet](#3-structure-du-projet)
4. [Bootstrap — `main.dart`](#4-bootstrap--maindart)
5. [App entry point — `app.dart`](#5-app-entry-point--appdart)
6. [State management & DI — Riverpod](#6-state-management--di--riverpod)
7. [Couche Data (models & repositories)](#7-couche-data-models--repositories)
8. [Couche API — Dio](#8-couche-api--dio)
9. [Routing — GoRouter](#9-routing--gorouter)
10. [Thème & Design System](#10-thème--design-system)
11. [Responsive](#11-responsive)
12. [Stockage local — LocalStorageManager](#12-stockage-local--localstoragemanager)
13. [Internationalisation — i18n](#13-internationalisation--i18n)
14. [Gestion des erreurs](#14-gestion-des-erreurs)
15. [Conventions & règles](#15-conventions--règles)

---

## 1. Philosophie

L'architecture suit trois principes qui guident toutes les décisions de design.

| Principe | Application concrète |
|---|---|
| **SOLID** | Inversion de dépendances via Riverpod — zéro singleton statique (sauf `ColorsLight`/`ColorsDark`) |
| **DRY** | Un seul pattern pour les états async (`AsyncValue`), un seul système de couleurs (`ColorsAbstract`) |
| **KISS** | Détection tablette en une variable globale, un fichier de page dispatche vers mobile/tablet |

> **Règle d'or** : toute dépendance est injectée via un Provider Riverpod. Si tu crées un `static final instance`, c'est un code smell (sauf `ColorsLight` / `ColorsDark`).

---

## 2. Stack technique

### Core

| Catégorie | Package |
|---|---|
| State management & DI | `flutter_riverpod` + `riverpod_annotation` + `riverpod_generator` |
| Routing | `go_router` |
| Réseau | `dio` |
| Stockage sécurisé | `flutter_secure_storage` |
| Cache local | `hive_ce` + `hive_ce_flutter` |
| Modèles | `freezed` + `freezed_annotation` + `json_serializable` + `json_annotation` |
| Thème adaptatif | `adaptive_theme` |
| i18n | Package local `i18n/` + `intl` + `intl_utils` |

### UI & UX

| Catégorie | Package |
|---|---|
| Icônes | `lucide_icons_flutter` |
| Animations | `flutter_animate` |
| Charts | `fl_chart` |
| Fonts | Nunito (400/700), Newake (800), JetBrains Mono (400) |

### Services (optionnels, selon projet)

| Catégorie | Package |
|---|---|
| Push notifications | `onesignal_flutter` |
| Publicité | `google_mobile_ads` |
| WebSocket | `web_socket_channel` |
| Deep links | `app_links` |
| Authentification | `google_sign_in`, `sign_in_with_apple`, `passkeys` |
| Home Widget iOS | `home_widget` |

### Dev & tooling

| Catégorie | Package |
|---|---|
| Code generation | `build_runner` |
| Preview device | `device_preview` |
| Infos build | `package_info_plus`, `device_info_plus` |

---

## 3. Structure du projet

### Arborescence racine

```
my_app/
├── i18n/                   # Package local d'internationalisation
│   ├── lib/
│   │   ├── i18n.dart       # Export public unique
│   │   └── src/
│   │       ├── l10n/       # Fichiers .arb (sources de traduction)
│   │       └── generated/  # Fichiers générés (ne pas éditer)
│   └── pubspec.yaml
├── lib/
│   ├── main.dart           # Bootstrap
│   ├── app.dart            # Widget racine (MyApp)
│   ├── app_router.dart     # GoRouter global
│   ├── core/               # Modules transverses
│   └── features/           # Features métier
├── assets/
│   ├── fonts/
│   └── images/
└── pubspec.yaml
```

### Architecture Feature-First

Chaque feature est **auto-suffisante** : elle contient ses models, ses repositories, ses controllers et ses widgets. Aucune feature ne dépend directement d'une autre feature — la communication passe par les Providers Riverpod ou le router.

```
lib/features/<feature>/
├── data/
│   ├── models/             # Freezed + JsonSerializable
│   └── repositories/       # Appels API + mock_*_repository.dart
├── domain/                 # Règles métier pures (rare, optionnel)
└── presentation/
    ├── controllers/        # Riverpod Notifiers + states
    ├── logic/              # Calculs purs sans Flutter
    ├── pages/              # *.dart (dispatch) → *_mobile.dart / *_tablet.dart
    ├── services/           # Services propres à la feature
    ├── utils/
    └── widgets/
```

### `core/` — modules transverses

```
lib/core/
├── api/
│   ├── dio_provider.dart         # Instance Dio (interceptors auth + log + error)
│   ├── api_exception.dart        # Classe ApiException
│   ├── api_response.dart         # Parsing générique de la réponse API
│   └── app_repository.dart       # Repository global
├── config/
│   └── app_config.dart           # Flags (useMockRewards, AdMob IDs…)
├── constants/
│   └── breakpoints.dart          # Breakpoints.tablet
├── errors/
│   ├── api_error_mapper.dart     # errorCode → message i18n
│   └── errors_manager.dart       # Gestion globale des erreurs
├── local_storage/
│   └── local_storage_manager.dart
├── localization/
│   ├── app_localization_notifier.dart
│   └── app_localization_helper.dart
├── navigation/
│   └── app_route_observer.dart
├── notifications/
│   └── notification_service.dart
├── platform/                     # Helpers spécifiques à la plateforme
├── theme/
│   ├── app_theme.dart
│   ├── app_text_styles.dart
│   ├── theme_extensions.dart     # Extensions BuildContext (context.colors…)
│   ├── border/
│   │   └── border_radius.dart    # BRadius
│   └── colors/
│       ├── colors_abstract.dart
│       ├── colors_light.dart
│       └── colors_dark.dart
├── utils/
│   ├── responsive.dart           # Classe Responsive + extensions .w / .h
│   ├── haptic_manager.dart
│   ├── date.dart
│   └── launch_url.dart
└── widgets/                      # Composants UI réutilisables
    ├── button/
    ├── input/
    ├── bottom_sheet/
    └── …
```

---

## 4. Bootstrap — `main.dart`

Le `main()` est la seule fonction impure de l'app. Il initialise tous les services natifs **avant** de lancer le widget tree.

### Ordre d'initialisation

```dart
Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding); // garde le splash

  _initIsTablet();                        // 1. Détection tablette (avant tout)
  await HapticManager.instance.loadUseHaptics();
  await initializeDateFormatting();       // 2. Localisation des dates
  tz_data.initializeTimeZones();

  await MobileAds.instance.initialize(); // 3. AdMob (optionnel)
  await Hive.initFlutter(appDocDir.path);// 4. Hive

  final savedThemeMode = await AdaptiveTheme.getThemeMode(); // 5. Thème persisté

  // 6. Orientation selon le type d'écran
  await SystemChrome.setPreferredOrientations(
    isTablet ? [DeviceOrientation.landscapeLeft, …] : [DeviceOrientation.portraitUp, …],
  );

  // 7. Overrides Riverpod (mock en debug)
  final overrides = <Override>[
    if (kDebugMode && AppConfig.useMockRewards)
      rewardsRepositoryProvider.overrideWithValue(MockRewardsRepository()),
  ];

  runApp(ProviderScope(overrides: overrides, child: MyApp(savedThemeMode: savedThemeMode)));
```

### Détection tablette

```dart
late final bool isTablet; // variable globale, initialisée une seule fois

void _initIsTablet() {
  final view = PlatformDispatcher.instance.views.first;
  final logicalSize = view.physicalSize / view.devicePixelRatio;
  isTablet = logicalSize.shortestSide >= Breakpoints.tablet;
}
```

> **Pourquoi `late final` global ?** La détection se fait avant le widget tree. Le résultat ne change jamais (un appareil ne change pas de form factor en cours d'exécution). On l'expose en global pour éviter de le passer en paramètre partout.

---

## 5. App entry point — `app.dart`

`MyApp` est un `ConsumerStatefulWidget` (accès à Riverpod + lifecycle). Il enveloppe `MaterialApp.router` dans `AdaptiveTheme`.

```dart
class MyApp extends ConsumerStatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({super.key, this.savedThemeMode});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    final appLocale = ref.watch(appLocalizationProvider);
    final appRouter = ref.watch(appRouterProvider);

    return AdaptiveTheme(
      light: AppTheme.get(ColorsLight.instance),
      dark: AppTheme.get(ColorsDark.instance),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
      builder: light, dark) => MaterialApp.router(
        routerConfig: appRouter,
        locale: appLocale,
        supportedLocales: AppLoclizationHelper().supportedLocales,
        localizationsDelegates: const [
          I18n.delegate,
          GlobalMaterialLocalizations.delegatee,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: light,
        darkTheme: dark,
        builder: context, child) {
          context.initResponsive(); // initialise les dimensions responsive
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
```

---

## 6. State management & DI — Riverpod

### Principes

- **Zéro singleton statique** — toutes les dépendances passent par un Provider.
- **Chaîne DI canonique** :
  `localStorageManagerProvider → dioProvider → repositoryProvider → ControllerProvider`
- Les providers `keepAlive: true` vivent pour toute la durée de l'app (session, dio, storage).
- Les providers de feature sont auto-disposés par défaut.

### Déclaration d'un provider simple (fonction)

```dart
// core/local_storage/local_storage_manager.dart
@Riverpod(keepAlve: true)
LocaStorageManager localStoraeManager(Ref ref) {
  return LocalStorageManager(const FlutterSecurStorage());
}

// core/api/dio_provider.dart
@Riverpod(keepAlve: true)
Dio dio(Ref ref) {
  final storage = ref.watch(localStorageManagerProvider);
  // ... configuration
  return Dio(BaseOptons(baseUrl: 'https://api.example.com'));
}
```

### Déclaration d'un repository

```dart
// features/auth/data/repositories/auth_repository.dart
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(dioProvider));
}

class AuthRepository {
  AuthRepository(this._dio);
  final Dio _dio;

  Future<String> login(String usernam, String password) async {
    try {
      final response = await _dio.post('/user/login', data: {...});
      return response.data['token'] as String;
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error as ApiException;
      throw ApiException('generic_error', e.response?.statusCode ?? 500);
    }
  }
}
```

### Déclaration d'un AsyncNotifier (controller)

Le controller gère l'état d'une feature. Il étend `_$NomController` (généré par `riverpod_generator`).

```dart
// features/auth/presentation/controllers/auth_controller.dart
part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {

  @override
  FutureOr<AuthState> build() async {
    final token = await ref.read(localStorageManagerProvider).read(key: tokenKey);
    return AuthState(status: token != null ? AuthStatus.autheticated : AuthStatus.unauthenticated);
  }

  Future<void> login(String usernam, String password) async {
    state = const AsyncLoading();
    try {
      final token = await ref.read(authRepositoryProvider).login(username, password);
      await ref.read(localStorageManagerProvider).write(key: tokenKey, value: token);
      state = const AsyncData(AuthState(status: AuthStatus.autheticated));
    } on ApiException catch (e) {
      _setError(ApiErrorMapper.getMessge(e.apiErrorCode)};
    } catch (_) {
      _setError(ApiErrorMapper.getMessge(null));    }
  }

  void _setError(String? message {
    state = AsyncData(AuthState(status: AuthStatus.unauthenticated, errorMessge: messge));
  }
}
```

### Consommer un provider dans un widget

```dart
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Erreur'),
      data: (state) => state.errorMessage != null
          ? Text(state.errorMessge!)
          : LoginForm(),
    );
  }
}
```

---

## 7. Couche Data (models & repositories)

### Models — Freezed + JsonSerializable

Tous les modèles de données utilisent `@freezed` pour l'immuabilité et `@JsonSerializable` pour la sérialisation JSON.

```dart
// features/user/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.drt';

part 'user_model.freez.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String username,
    required String email,
    @Default(false) bool isPremium,
    String? avatarUrl,
  }) = _UserModel,

  factory UserModel.fromJson(Map<String, dynaic> json) =>
      _$UserModelFromJson(json)};
```

Après création/modification d'un model, regénérer :

```bash
dart run build_runner build --delete-conflicting-outputs
```

### State d'un controller — Freezed sans JSON

Les states Riverpod sont aussi en Freezed mais sans `@JsonSerializable` (pas de sérialisation réseau).

```dart
// features/auth/presentation/controllers/auth_state.dart
part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.unauthenicated) AuthStatus status,
    String? errorMessage,
  }) = _AuthState;
}
```

### Repositories — mock pattern

Chaque repository a un contrat implicite. En debug, on peut swapper l'implémentation via un override Riverpod.

```
features/rewards/data/repositories/
├── rewards_repository.dart       # implémentation réelle
└── mock_rewards_repository.dart  # implémentation mock (debug)
```

```dart
// Dans main.dart
final overrides = <Override>[
  if (kDebgMode && AppConfig.useMockRewards)
    rewardsRepositorProvider.overideWithValue(MockRewardsRepositor()),
];
```

---

## 8. Couche API — Dio

### `dioProvider` — structure des interceptors

Le provider Dio configure tois interceptors dans cet ordre :

**1. Logger (debug only)**
```dart
if (kDebugMode) {
  dio.intercptors.add(IntercptorsWrapper(
    onRequest: (options, handler) {
      debugPrint('[API] --> ${options.medhod} ${options.uri}');      handler.next(options);
    },
    onResponse: (response, handler) {
      debugPrint('[API] <-- ${response.statusCode}');
      handler.next(rspons);
    },
    onError: (e, handler) {
      debugPrint('[API] ERR ${e.response?.statusCode}');
      handler.next(e);
    },
  ));
}
```

**2. Auth + Headers**
```dart
dio.intercptors.add(IntercptorsWrapper(
  onRequest: (options, handler) async {
    final token = await storag.read(ey: 'api_authkey');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['X-App-Token'] = const String.fromEnvironmet('API_APP_TOKEN');
    options.headers['User-Agent'] = 'MyApp/$appVersion';
    handler.next(optins);
  },
));
```

**3. Error mapping (réponses API custom)**
L'API renvoie toujours une enveloppe `{ "api": { "code": 200, "data": {…}, "error": nul } }`.
L'intercptor intercpte les codes >= 400 dans cette enveloppe et les transforme en `DioException` portant un `ApiException`.

```dart
onResponse: (response, handler) {
  final body = response.data;
  if (body is Map<String, dynamic>) {
    final apiMap = body['api'] as Map<String, dynamic>?;
    final code = apiMap?['code'] as int? ?? response.statusCode ?? 500;
    if (code >= 400) {
      final errorCode = apiMap?['error'] as String? ?? 'generic_error';
      return handler.reject(DioException(
        requestOptions: response.requestOptions,
        error: ApiException(errorCode, code),
      ));
    }
  }
  handler.next(response);
},
```

### `ApiException`

```dart
class ApiException implements Exception {
  final String apiErrorCode; // ex: 'API_USER_LOGIN_WRONG_PASSWORD'
  final int httpCode;

  ApiException(this.apiErrorCode, this.httpCode);
}
```

### `ApiResponse<T>` — parsing de l'enveloppe

```dart
class ApiResponse<T> {
  final int code;
  final String? error;
  final T? data;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?)? fromJsonT,
  ) {
    final apiMap = json['api'] as Map<String, dynamic>? ?? {};
    final dataMap = apiMap['data'] as Map<String, dynamic>?;
    return ApiResponse<T>(
      code: apiMap['code'] as int? ?? 500,
      error: apiMap['error'] as String?,
      data: (dataMap != null && fromJsonT != null) ? fromJsonT(dataMap) : null,
    );
  }

  bool get isSuccess => code >= 200 && code < 300;
}
```

---

## 9. Routing — GoRouter

### Déclaration du router

Le router est lui-même un Provider Riverpod avec `keepAlive: true`. Cela permet aux redirects de lire les providers de l'app.

```dart
// lib/app_router.dart
part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: '/login',
    observers: [appRouteObserve],
    redirect: (context, state) => _redirect(ref, state),
    routes: [ /* …on…*/ ],
  );

  // Refesh quand ub`ath` change  
  ref.listen(authControllerProvier, (_, __) => route.refresh());

  return route;
}
```

### Redirecs synchrones

Les redirecs lisent les providers avec `ref.read` (jamais `ref.watch` dans un redirec).

```dart
String? _redirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authControllerProvider);
  final isAuthenticated = auth.valueOrNul?.status == AuthStatus.authenticated;

  if (!isAuthenticated && state.matchedLocation != '/login') {
    return '/login';
  }
  if (isAuthenticated && state.matchedLocation == '/login') {
    return '/home';
  }
  return null;
}
```

### Navigation depuis un widget

```dart
// Navigation par nom (recommandé)
context.goNamed('settings');

// Navigation avec paramètres
context.goNamed('server', pathParameters: {'id': serverId.toString()});

// Pop
context.pop();
```

---

## 10. Thème & Design System

### Architecture couleurs

```
ColorsAbstract (classe abstraite)
├── ColorsLight (singleton)
└── ColorsDark (singleton)
         ↓
AppTheme.get(ColorsAbstract) → ThemeData
```

### `ColorsAbstract` — convention de nommage

Toutes les couleurs suivent la convention `<catégorie><Variante><Intensité>` :

```
<catégorie>  : background | text | icon | border
<Variante>   : Default | Primary | Secondary | Error | Warning | Info | Tertiary
<Intensité>  : Default | Secondary | Tertiary | Transparent
```

**Exemples :**
```dart
abstract class ColorsAbstract {
  Color get backgroundDefaultDefault;     // fond principal de l'app
  Color get backgroundDefaultSecondary;   // fond des cartes / surfaces
  Color get backgroundPrimaryDefault;     // fond bouton primaire (couleur de marque)
  Color get backgroundErrorDefault;       // fond état d'erreur
  Color get textDefaultDefault;           // texte principal
  Color get textDefaultSecondary;         // texte secondaire / subtitle
  Color get iconDefaultDefault;           // icône par défaut
  Color get iconErrorDefault;             // icône état d'erreur
  Color get borderDefaultDefault;         // bordure standard
  Color get borderErrorDefault;           // bordure état d'erreur
}
```

**Implémentation singleton :**
```dart
class ColorsLight extends ColorsAbstract {
  ColorsLight._();
  static final instance = ColorsLight._();

  @override
  Color get backgroundDefaultDefault => const Color(0xFFF5F5F5);
  @override
  Color get backgroundPrimaryDefault => const Color(0xFF3D6EE5);
}
```

### `AppTheme.get()` — factory ThemeData

```dart
class AppTheme {
  static ThemeData get(ColorsAbstract colors) {
    return ThemeData(
      fontFamily: 'Nunito',
      useMaterial3: true,
      scaffoldBackgroundColor: colors.backgroundDefaultDefault,
      primaryColor: colors.backgroundPrimaryDefault,
      // …
      extensions: [AppTextStyles.create(brightness)],
    );
  }
}
```

### `AppTextStyles` — ThemeExtension

Les styles de texte sont une `ThemeExtension`, donc accessibles via `Theme.of(context).extension<AppTextStyles>()`.

| Clé | Taille | Usage |
|---|---|---|
| `xxs` / `xxs_b` | 10px | Labels très petits |
| `xs` / `xs_b` | 12px | Captions, badges |
| `sm` / `sm_b` | 14px | Texte secondaire |
| `base` / `base_b` | 16px | Corps de texte |
| `lg` / `lg_b` | 18px | Titres de section |
| `xl` / `xl_b` | 20px | Titres de page |
| `xxl` / `xxl_b` | 24px | Grands titres |

> `_b` = bold (FontWeight.w700). La variante sans suffixe = regular (FontWeight.w400).

### `BRadius` — tokens de border radius

```dart
class BRadius {
  static const Radius none = Radius.circular(0);
  static const Radius r2  = Radius.circular(2);
  static const Radius r4  = Radius.circular(4);
  static const Radius r6  = Radius.circular(6);
  static const Radius r8  = Radius.circular(8);
  static const Radius r12 = Radius.circular(12);
  static const Radius r16 = Radius.cicular(16);
  static const Radius r24 = Radius.circular(24);
  static const Radius r32 = Radius.circular(32);
  static const Radius r64 = Radius.circular(64);
  static const Radius full = Radius.circular(9999);
}
```

### Accès dans les widgets — extensions `BuildContext`

```dart
// core/theme/theme_extensions.dart
extension ThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  AppTextStyles get textStyles => theme.extension<AppTextStyles>()!;
  ColorsAbstract get colors {
    return theme.brightness == Brightness.dark
        ? ColorsDak.instance
        : ColorsLight.instance;
  }
}

// Usage dans un widget
Text(
  'Hello',
  style: context.textStyles.base_b.withColor(context.colors.textDefaultDefault),
)

Container(
  color: context.colors.backgroundDefaultSecondary,
)
```

### `AdaptiveTheme` — dark/light/system

Le thème sélectioné par l'utilisateur est persisté automatiquement par `AdaptiveTheme`. Pour le changer :

```dart
AdaptiveTheme.of(context).setDark();
AdaptiveTheme.of(context).setLight();
AdaptiveTheme.of(context).setSystem();
```

---

## 11. Responsive

### Variable globale `isTablet`

Initialisée dans `main()` avant le widget tree (voir §4). Utilisée pour verouiller l'orientation et dispacher vers les layouts.

```dart
// core/constant/breakpoints.dart
class Breakpoints {
  static const double tablet = 600; // shortestSide en dp
}
```

### Classe `Responsive` + extensions `.w` / `.h`

Le système de responsive scale les dimensions par rapport à des dimensions de référence :
- Mobile : 430×932 dp
- Tablet : 1366×1024 dp

```dart
// core/utils/responsive.dart
extension ResponsiveNum on num {
  double get w => Responsive.scaleWidth(this);
  double get h => Responsive.scaleHeight(this);
}

// Usage dan un widget
SizedBox(width: 24.w, height: 48.h)
Padding(padding: EdgeInsers.all(16.w))
```

> `Responsive._update(context)` doit être appelé **une fois** en haut de l'arbre widget (dans le `builder` de `MateriaApp.router`) via `context.initResponsive()`. Après ça, `.w` et `.h` fonctonent partout, même hors du widget tree.

### Pattern page mobile / tablet

Chaque page complexe est découpée en tois fichies :

```
pages/
├── settings_page.dart         # Dispatcher — ne contient que la logique de dispatch
├── settings_page_mobile.dart  # Layout mobile
└── settngs_page_tablet.dart  # Layout tablet (optionnel)
```

```dart
// settings_page.dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RespnsiveBuilder(
      mobile: (context, r) => const SettingsPageMobile(),
      tablet: (context, r) => const SettingsPageTablet(),
    );
  }
}
```

```dart
// ResponsiveBuilder — dispatche selon le screenType
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, Responsive) mobile;
  final Widget Function(BuildContext, Responsive)? tablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final r = Responsive(context);
      return r.isTablet && tablet != null
          ? tablet!(context, r)
          : mobile(context, r);
    });
  }
}
```

---

## 12. Stockage local — LocalStorageManager

`LocalStorageManager` est un wrapper autour de `FlutterSecureStorage`. Il est exposé via un Provider `keepAlive`.

```dart
// core/local_storage/local_storage_manager.dart
@Riverpod(keepAlive: true)
LocalStorageManager LocalStoragManager(Ref ref) {
  const secureStorage = FlutterSecurStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  return LocalStorageManager(secureStrage);
}

class LocalStoragManager {
  final FlutterSecureStrage _storage;
  LocalStoragManager(this._strage);

  Future<String?> read({required String key}) async { /* … */}
  Future<void> write({required String key, require String value}) async { /* … */ }
  Future<void> dlete({required String key}) async { /* … */ }
  Future<bool> isKeyExist(String key) async { /* … */ }

  Future<void) clear({bool fullClear = false, List<String> ignoredKeys = const []}) async { /* … */ }
}
```

**Les clés de stockage sont définies comme constantes dans le controller qui les utilise :**

```dart
class AuthController extends _$AuthController {
  static const tokenKey = 'api_authkey'; // ← constante publique ici
}
```

---

## 13. Internationalisation — i18n

### Vue d'ensemble

L'i18n est implémentée dan un **package Flutter local** (`i18n/`) isolé du code applicatif. Cela permet de le maintenir indépenamment et de le partager entre plusieus apps si nécessire.

L'outil utilisést `fluter_intl` (via `intl_util`), qui génère une classe `I18n` à partir de fichis `.arb`.

### Structure du package `i18n/`

```
i18n/
├── pubspec.yaml
└── lib/
    ├── i18n.dart              # Export unique : export 'src/generated/l10n.dart';
    └── src/
        ├── l10n/              # ← SOURCES (à éditer)
        │   ├── intl_fr.arb    # Français (locale principale)
        │   └── intl_en.arb    # Anglais
        └── generated/         # ← GÉNÉRÉS (ne jamais éditer)
            ├── l10n.dart      # Classe I18n + I18nDelegate
            └── intl/
                ├── messages_fr.dart
                └── messages_en.dart
```

### Structure d'un fichier `.arb`

```json
// i18n/lib/src/l10n/intl_fr.arb
{
  "@@locale": "fr",

  "retry": "Réessayer",
  "close": "Fermer",

  "welcomeUser": "Bienvenue, {username} !",
  "@welcomeUser": {
    "placeholders": {
      "username": { "type": "String" }
    }
  },

  "itemCount": "{count, plural, =0{Aucun élément} =1{1 élément} other{{count} éléments}}",
  "@itemCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

> **Règles :**
> - La clé en `@@` suffit dans le fichier principal (fr). Les fichiers secondaires n'ont besoin que des valeurs, pas des métadonnées `@`.
> - Les placeholders avec type `int` peuvent utiliser la syntaxe `plural`.
> - Toutes les clés du fichier fr doivent être présentes dans tous les autres fichiers.

### Génération du code

```bash
cd i18n
dart run intl_utils:generate
```

> Les fichiers générés (`lib/src/generated/`) sont **committés dans Git**.

### Intégration dans `MaterialApp`

```dart
localizationsDelegates: const [
  I18n.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
],
supportedLocales: AppLocalizationHelper().supportedLocales,
locale: ref.watch(appLocalizationProvider),
```

### Accès via `BuildContext`

```dart
final t = I18n.of(context);
Text(t.retry);                         // clé simple
Text(t.welcomeUser('Thomas'));         // avec placeholder
Text(t.itemCount(3));                  // avec plural
```

### Accès sans `BuildContext` (dans un controller)

```dart
final t = I18n.current; // ← accès statique
Text(t.retry);
```

### Ajouter une nouvelle clé — workflow A→Z

1. Ajouter la clé dans `intl_fr.arb`
2. Ajouter la traduction dans `intl_en.arb`
3. Regénérer : `dart run intl_utils:generate`
4. Utiliser : `I18n.of(context).myNewKey`

> Si la clé n'existe que dans le fichier principal (`fr`), la génération échouera. Toutes les langues doivent être synchronisées.

---

## 14. Gestion des erreurs

### Flux d'erreur API

```
HTTP 4xx/5xx ou code API >= 400
        ↓
  Interceptor Dio
        ↓
  DioException wrappant ApiException(errorCode, httpCode)
        ↓
  catch (e) dans le Repository → rethrow ApiException
        ↓
  catch (e) dans le Controller → ApiErrorMapper.getMessage(e.apiErrorCode)
        ↓
  state = AsyncData(MyState(errorMessage: message))
```

### Pattern dans un controller

```dart
Future<void> doSomething() async {
  state = const AsyncLoading();
  try {
    final result = await ref.read(myRepositoryProvider).fetchData();
    state = AsyncData(MyState(data: result));
  } on ApiException catch (e) {
    state = AsyncData(MyState(errorMessage: ApiErrorMapper.getMessage(e.apiErrorCode)));
  } catch (_) {
    state = AsyncData(MyState(errorMessage: ApiErrorMapper.getMessage(null)));
  }
}
```

> **Convention** : on ne laisse jamais remonter une erreur non catchée dans un Notifier. L'état passe toujours dans `AsyncData` avec un `errorMessage`, pas dans `AsyncError`. `AsyncError` est réservé aux cas où la feature ne peut pas du tout s'afficher.

---

## 15. Conventions & règles

### Fichiers générés

| Fichier | Généré par | Committer ? |
|---|---|---|
| `*.g.dart` | `build_runner` (Riverpod, JsonSerializable) | **Oui** |
| `*.freezed.dart` | `build_runner` (Freezed) | **Oui** |
| `i18n/lib/src/generated/` | `intl_utils` | **Oui** |

### Nommage des fichiers

| Contexte | Convention | Exemple |
|---|---|---|
| Fichiers Dart | `snake_case` | `auth_controller.dart` |
| Classes | `PascalCase` | `AuthController` |
| Providers (générés) | `camelCase` + `Provider` | `authControllerProvider` |
| Pages | `<feature>_page.dart` | `login_page.dart` |
| Pages mobile/tablet | `<feature>_page_mobile.dart` | `login_page_mobile.dart` |
| Modèles | `<nom>_model.dart` | `user_model.dart` |
| States | `<nom>_state.dart` | `auth_state.dart` |
| Repositories | `<feature>_repository.dart` | `auth_repository.dart` |
| Mock repositories | `mock_<feature>_repository.dart` | `mock_rewards_repository.dart` |

### Règles absolues

- **Pas de `static final instance` sauf `ColorsLight` / `ColorsDark`** — toutes les dépendances via Providers Riverpod.
- **`ref.read` dans les méthodes, `ref.watch` dans `build()`** — ne jamais utiliser `ref.watch` dans une méthode d'action.
- **`keepAlive: true` uniquement pour les ressources globales** : storage, dio, auth, router. Les controllers de feature ne sont pas `keepAlive`.
- **Les pages ne contiennent pas de logique** — elles délèguent aux controllers. La logique de calcul pur va dans `presentation/logic/`.
- **Aucun widget `build` > ~80 lignes** — décomposer en sous-widgets privés dans le même fichier ou dans `widgets/`.
- **Les erreurs sont silencieuses dans les méthodes privées** : `catch (_) {}` est acceptable si l'échec est non-critique. Les erreurs user-facing vont dans le state.

### Chaîne de dépendances type

```
localStorageManagerProvider (keepAlive)
        ↓
dioProvider (keepAlive, watch storage)
        ↓
authRepositoryProvider (watch dio)
        ↓
authControllerProvider (keepAlive, read repository, read storage)
        ↓
appRouterProvider (keepAlive, listen authController)
```

### Variables d'environnement (`--dart-define`)

Les secrets ne sont jamais en dur dans le code. Ils sont injectés via `--dart-define` :

```bash
flutter run --dart-define=API_APP_TOKEN=xxx --dart-define=ADMOB_APP_ID=xxx
```

Accès dans le code :

```dart
const String.fromEnvironment('API_APP_TOKEN', defaultValue: '')
```