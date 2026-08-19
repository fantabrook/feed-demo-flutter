// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the notification list and polls the unread count every 20s.

@ProviderFor(NotificationsNotifier)
final notificationsProvider = NotificationsNotifierProvider._();

/// Loads the notification list and polls the unread count every 20s.
final class NotificationsNotifierProvider
    extends $AsyncNotifierProvider<NotificationsNotifier, NotificationsState> {
  /// Loads the notification list and polls the unread count every 20s.
  NotificationsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsNotifierHash();

  @$internal
  @override
  NotificationsNotifier create() => NotificationsNotifier();
}

String _$notificationsNotifierHash() =>
    r'5bfaf33c889e11157868f52dba1bd733b0cb4e59';

/// Loads the notification list and polls the unread count every 20s.

abstract class _$NotificationsNotifier
    extends $AsyncNotifier<NotificationsState> {
  FutureOr<NotificationsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<NotificationsState>, NotificationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NotificationsState>, NotificationsState>,
              AsyncValue<NotificationsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
