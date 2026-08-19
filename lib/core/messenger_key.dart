import 'package:flutter/material.dart';

/// Used to surface foreground push messages as a SnackBar from outside
/// the widget tree. Kept in its own file (no other imports) so both
/// `core/app.dart` and the notifications feature's push notifier can
/// depend on it without an import cycle.
final rootMessengerKey = GlobalKey<ScaffoldMessengerState>();
