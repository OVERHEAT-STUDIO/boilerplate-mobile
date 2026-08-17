// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(code) => "Unknown error (${code})";

  static String m1(count) =>
      "${Intl.plural(count, zero: 'No items', one: '1 item', other: '${count} items')}";

  static String m2(username) => "Welcome, ${username}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
    "cancelLabel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "continueLabel": MessageLookupByLibrary.simpleMessage("Continue"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "errorApiForbidden": MessageLookupByLibrary.simpleMessage("Access denied"),
    "errorApiGenericError": MessageLookupByLibrary.simpleMessage(
      "An error occurred. Please try again.",
    ),
    "errorApiInvalidToken": MessageLookupByLibrary.simpleMessage(
      "Session expired. Please log in again.",
    ),
    "errorApiMissingRequiredFields": MessageLookupByLibrary.simpleMessage(
      "Required fields are missing.",
    ),
    "errorApiRateLimited": MessageLookupByLibrary.simpleMessage(
      "Too many requests. Please try again later.",
    ),
    "errorApiSuspendedUser": MessageLookupByLibrary.simpleMessage(
      "Your account has been suspended.",
    ),
    "errorApiUnknown": m0,
    "errorApiVpnDetected": MessageLookupByLibrary.simpleMessage(
      "Please disable your VPN to continue.",
    ),
    "errorNotFound": MessageLookupByLibrary.simpleMessage("Not found"),
    "errorOccurred": MessageLookupByLibrary.simpleMessage("An error occurred"),
    "feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "itemCount": m1,
    "loading": MessageLookupByLibrary.simpleMessage("Loading…"),
    "locale": MessageLookupByLibrary.simpleMessage("Language"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign in to your account",
    ),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Welcome"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "maintenance": MessageLookupByLibrary.simpleMessage("Maintenance"),
    "noAccount": MessageLookupByLibrary.simpleMessage("No account yet?"),
    "noResults": MessageLookupByLibrary.simpleMessage("No results"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "rating": MessageLookupByLibrary.simpleMessage("Rating"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "saveLabel": MessageLookupByLibrary.simpleMessage("Save"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "welcomeUser": m2,
  };
}
