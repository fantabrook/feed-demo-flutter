# สเปก: ปรับโครงสร้างโปรเจกต์ feed-demo-flutter ให้ตรงกับ CLAUDE.md

## 1. ภาพรวม (Overview)

โค้ดปัจจุบันของ `feed-demo-flutter` ใช้สถาปัตยกรรมที่ต่างจากที่ระบุไว้ใน `CLAUDE.md` โดยสิ้นเชิง:

- ใช้ `package:provider` (ChangeNotifier) แทน Riverpod
- ใช้ `package:http` แทน Dio
- โมเดลเป็น plain Dart class แทน Freezed + JsonSerializable
- ไม่มี router เลย — ใช้ widget-swap (`_RootGate`) แทน GoRouter
- ไฟล์ทั้งหมดอยู่แบบแบน (`lib/models/`, `lib/providers/`, `lib/screens/`, `lib/services/`, `lib/widgets/`) ไม่ได้จัดแบบ feature-first

สเปกนี้วางแผนการ **migrate เต็มรูปแบบ** ให้สอดคล้องกับ `CLAUDE.md`: เปลี่ยน state management เป็น Riverpod (`@riverpod` codegen, `AsyncNotifier`), เปลี่ยนโมเดลเป็น Freezed, เปลี่ยน HTTP client เป็น Dio พร้อม interceptor ใน `lib/core/network/`, เพิ่ม GoRouter ใน `lib/core/router/`, และจัดไฟล์ใหม่ตามรูปแบบ feature-first ที่ `CLAUDE.md` กำหนด

**หมายเหตุ:** สเปกนี้ครอบคลุมเฉพาะการวางแผน — งาน implementation จริง (ย้าย/เขียนไฟล์ ~20 ไฟล์ใหม่, เพิ่ม package, รัน build_runner) เป็นงานแยกต่างหากที่ทำหลังสเปกนี้ผ่านการรีวิว

## 2. สถานะปัจจุบัน (Current State)

**pubspec.yaml:** `provider ^6.1.2`, `http ^1.2.0`, `http_parser`, `mime`, `shared_preferences`, `image_picker`, `intl`, `firebase_core`, `firebase_messaging` — ไม่มี riverpod/freezed/dio/go_router/build_runner เลย ไม่มี `build.yaml` ไม่มีไฟล์ generated ใดๆ

**lib/ ปัจจุบัน (20 ไฟล์):**
- `main.dart` — Firebase init, `MultiProvider` ที่ root, `_RootGate` สลับหน้าจอตาม `AuthProvider.status`
- `models/{user,post,notification}.dart` — plain class ทั้งหมด (`AppUser`, `Post`, `AppNotification`, `NotificationPost`)
- `providers/{auth_provider,theme_provider,post_list_provider,feed_provider,profile_provider,notifications_provider}.dart` — ทั้งหมดเป็น `ChangeNotifier`
- `services/api_client.dart` — ห่อ `package:http`, มี `AuthResult`/`LikeResult` DTO และ `resolveImageUrl()` ฝังอยู่ในคลาสเดียว
- `services/push_service.dart` — ห่อ `firebase_messaging`
- `screens/{sign_in,sign_up,home_shell,feed,profile,notifications}_screen.dart`
- `widgets/{post_card,compose_post_sheet,edit_post_sheet}.dart`

## 3. โครงสร้างเป้าหมาย (Target Folder Tree)

```
lib/
├── main.dart                          # bootstrap เท่านั้น (Firebase init + runApp(ProviderScope(...)))
├── core/
│   ├── network/
│   │   ├── dio_client.dart            # Dio instance + baseUrl resolution (@riverpod)
│   │   ├── auth_interceptor.dart      # แทรก Bearer token
│   │   ├── error_interceptor.dart     # แปลง DioException -> ApiException
│   │   ├── api_exception.dart
│   │   └── image_url_resolver.dart    # แทนที่ ApiClient.resolveImageUrl()
│   ├── router/
│   │   ├── app_router.dart            # GoRouter config (@riverpod), redirect ตาม auth state
│   │   ├── route_names.dart
│   │   └── home_shell.dart            # StatefulShellRoute.indexedStack shell
│   ├── theme/
│   │   ├── theme_notifier.dart        # @riverpod AsyncNotifier<ThemeMode>
│   │   └── theme_notifier.g.dart
│   └── app.dart                       # FeedDemoApp (MaterialApp.router), scaffoldMessengerKey
├── shared/
│   ├── models/
│   │   └── app_user.dart (+ .freezed.dart, .g.dart)
│   ├── widgets/
│   │   ├── post_card.dart
│   │   └── edit_post_sheet.dart
│   └── providers/
│       └── post_list_notifier.dart    # ฟังก์ชันกลาง like/edit/delete ที่ feed+profile เรียกใช้ร่วมกัน
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── models/auth_result.dart (+generated)
    │   │   └── repositories/{auth_repository,auth_repository_impl}.dart
    │   ├── presentation/
    │   │   ├── screens/{sign_in_screen,sign_up_screen}.dart
    │   │   └── providers/auth_notifier.dart (+.g.dart)
    │   └── auth.dart                  # barrel export
    ├── feed/
    │   ├── data/
    │   │   ├── models/{post,like_result}.dart (+generated)
    │   │   └── repositories/{post_repository,post_repository_impl,feed_repository,feed_repository_impl}.dart
    │   ├── presentation/
    │   │   ├── screens/feed_screen.dart
    │   │   ├── widgets/compose_post_sheet.dart
    │   │   └── providers/feed_notifier.dart (+.g.dart)
    │   └── feed.dart
    ├── profile/
    │   ├── data/repositories/{profile_repository,profile_repository_impl}.dart
    │   ├── presentation/
    │   │   ├── screens/profile_screen.dart
    │   │   └── providers/profile_notifier.dart (+.g.dart)
    │   └── profile.dart
    └── notifications/
        ├── data/
        │   ├── models/{app_notification,notification_post}.dart (+generated)
        │   └── repositories/{notifications_repository,notifications_repository_impl,push_repository,push_repository_impl}.dart
        ├── presentation/
        │   ├── screens/notifications_screen.dart
        │   └── providers/{notifications_notifier,push_notifier}.dart (+.g.dart)
        └── notifications.dart
```

## 4. ตารางย้ายไฟล์ (File Migration Map)

| ไฟล์เดิม | ปลายทางใหม่ | การเปลี่ยนแปลงเชิงโครงสร้าง |
|---|---|---|
| `models/user.dart` | `shared/models/app_user.dart` | plain class → Freezed (ใช้ร่วมกันหลาย feature) |
| `models/post.dart` | `features/feed/data/models/post.dart` | plain class → Freezed; ตัด `isMine` getter ที่ไม่ถูกใช้งานออก |
| `models/notification.dart` | แยกเป็น `features/notifications/data/models/{app_notification,notification_post}.dart` | 2 class ในไฟล์เดียว → แยกไฟล์ละ 1 class (Freezed) |
| `providers/auth_provider.dart` | `features/auth/presentation/providers/auth_notifier.dart` + `features/auth/data/repositories/auth_repository_impl.dart` | ChangeNotifier → `@riverpod AsyncNotifier<AppUser?>`; session restore ย้ายเข้า `build()` |
| `providers/theme_provider.dart` | `core/theme/theme_notifier.dart` | ChangeNotifier → `@riverpod AsyncNotifier<ThemeMode>` (อยู่ที่ core เพราะเป็น app-wide UI state) |
| `providers/post_list_provider.dart` | `shared/providers/post_list_notifier.dart` | abstract ChangeNotifier → ฟังก์ชันกลาง (ไม่ใช่ class inheritance เพราะชนกับ `@riverpod` codegen) |
| `providers/feed_provider.dart` | `features/feed/presentation/providers/feed_notifier.dart` | → `@riverpod AsyncNotifier<PostListState>` เรียกฟังก์ชันกลางจาก shared |
| `providers/profile_provider.dart` | `features/profile/presentation/providers/profile_notifier.dart` | เช่นเดียวกับ feed |
| `providers/notifications_provider.dart` | `features/notifications/presentation/providers/notifications_notifier.dart` | `Timer.periodic` ย้ายเข้า `build()` + ยกเลิกผ่าน `ref.onDispose()` |
| `services/api_client.dart` | แยกเป็น `core/network/*` (Dio client/interceptor/exception/image resolver) + repository ของแต่ละ feature | God-object → Dio infra กลาง + repository เฉพาะ feature |
| `services/push_service.dart` | `features/notifications/data/repositories/push_repository.dart` + `push_notifier.dart` | data access (FCM token) แยกจาก side effect (แสดง SnackBar) |
| `screens/sign_in_screen.dart`, `sign_up_screen.dart` | `features/auth/presentation/screens/` | ConsumerWidget, นำทางผ่าน GoRouter แทน Navigator.push |
| `screens/home_shell.dart` | `core/router/home_shell.dart` | IndexedStack+setState → `StatefulShellRoute.indexedStack` |
| `screens/feed_screen.dart` | `features/feed/presentation/screens/` | ConsumerWidget |
| `screens/profile_screen.dart` | `features/profile/presentation/screens/` | ConsumerWidget |
| `screens/notifications_screen.dart` | `features/notifications/presentation/screens/` | ConsumerWidget |
| `widgets/post_card.dart` | `shared/widgets/post_card.dart` | ไม่เปลี่ยนพฤติกรรม แค่ import path |
| `widgets/compose_post_sheet.dart` | `features/feed/presentation/widgets/` | อ่าน `feedNotifierProvider` ผ่าน `ref` แทน `context.read` |
| `widgets/edit_post_sheet.dart` | `shared/widgets/edit_post_sheet.dart` | callback-based เดิม ไม่เปลี่ยนพฤติกรรม |
| `main.dart` | แยกเป็น `main.dart` (bootstrap) + `core/app.dart` (MaterialApp.router) | ตัด `_RootGate`/`_PushInitGate` ออก แทนด้วย GoRouter redirect |

## 5. การเปลี่ยนแปลง package (pubspec.yaml)

**เพิ่ม (dependencies):** `flutter_riverpod`, `riverpod_annotation`, `dio`, `go_router`, `freezed_annotation`, `json_annotation`

**เพิ่ม (dev_dependencies):** `build_runner`, `riverpod_generator`, `freezed`, `json_serializable`

**เอาออก:** `provider`, `http`

**คงไว้ (ยืนยันแล้วว่ายังจำเป็น):** `http_parser` (Dio's `MultipartFile.contentType` ยังใช้ `MediaType` type นี้), `mime` (`lookupMimeType()` ตรวจ content-type จาก byte header ซึ่ง Dio ไม่มีให้ในตัว) — ส่วน `shared_preferences`, `image_picker`, `intl`, `firebase_core`, `firebase_messaging`, `cupertino_icons` ไม่ได้รับผลกระทบ

หลังย้ายไฟล์เสร็จต้องรัน `dart run build_runner build --delete-conflicting-outputs` เพื่อ generate ไฟล์ `.freezed.dart`/`.g.dart` ทั้งหมด

## 6. แนวทาง migrate Riverpod

- **Shared post-list logic** (like/edit/delete ที่ feed กับ profile ใช้ร่วมกัน): ใช้ฟังก์ชันกลางใน `shared/providers/post_list_notifier.dart` ที่รับ `(state, repository)` แล้วคืน state ใหม่ แทนการทำ class inheritance ระหว่าง `@riverpod` class (เพราะ generated `_$XxxNotifier` เป็น single-inheritance ชนกับ base class ที่ใช้ร่วมกันไม่ได้)
- **NotificationsNotifier polling:** สร้าง `Timer.periodic` ใน `build()` แล้วยกเลิกผ่าน `ref.onDispose(timer.cancel)` — ค่าเริ่มต้นใช้ lazy/ไม่ `keepAlive` (โพลจะทำงานเฉพาะตอนมีใคร watch provider อยู่)
- **ThemeNotifier:** อ่าน persisted value ใน `build()`, เขียนผ่าน `setMode()`
- **AuthNotifier:** โมเดล state เป็น `AsyncValue<AppUser?>` (loading = unknown, `AsyncData(null)` = signed out, `AsyncData(user)` = signed in) แทนการสร้าง Freezed union ใหม่ เพื่อลด boilerplate — session restore ย้ายเข้า `build()`

## 7. แนวทาง migrate Dio / Repository

`core/network/` เก็บ Dio instance (`dioProvider`), auth interceptor (แทรก Bearer token จาก auth session storage), error interceptor (แปลง `DioException` → `ApiException`), และ `resolveImageUrl` helper

แต่ละ feature มี repository ของตัวเองใต้ `data/repositories/` (abstract + `_impl`) รับ `Dio` ผ่าน `ref.watch(dioProvider)`:
- `auth`: sign in/up, session persistence
- `feed`: fetch feed, create post (multipart ผ่าน Dio `FormData`)
- `feed/post_repository.dart`: like/edit/delete ที่ profile ก็เรียกใช้ร่วม
- `profile`: fetch my posts, delegate like/edit/delete ไปที่ `PostRepository`
- `notifications`: fetch/mark-read + push token register/unregister (FCM)

Notifier ห้ามเรียก Dio ตรงๆ ต้องผ่าน repository เท่านั้น (ตามกฎ "ไม่มี API call ตรงใน notifier" ใน CLAUDE.md)

## 8. Routing (GoRouter)

| Route name | Path | หน้าจอ |
|---|---|---|
| `signIn` | `/sign-in` | SignInScreen |
| `signUp` | `/sign-up` | SignUpScreen |
| `feed` | `/feed` | FeedScreen (shell branch) |
| `profile` | `/profile` | ProfileScreen (shell branch) |
| `notifications` | `/notifications` | NotificationsScreen (shell branch) |

3 แท็บหลักเป็น branch ของ `StatefulShellRoute.indexedStack` (แต่ละแท็บมี navigation stack ของตัวเอง — ดีกว่า `IndexedStack` เดิม) `app_router.dart` มี `redirect` ที่ดู `authNotifierProvider`: signed-out → `/sign-in`, signed-in แล้วอยู่หน้า sign-in/up → `/feed` การ trigger ให้ redirect ทำงานใหม่เมื่อ auth state เปลี่ยน ใช้ `refreshListenable` bridge (ไม่ให้ rebuild `GoRouter` ใหม่ทั้งตัวทุกครั้งที่ auth เปลี่ยน เพราะจะเสีย navigation state)

## 9. PushService

ย้ายไปเป็น `features/notifications/data/repositories/push_repository.dart` (FCM token register/refresh/unregister ผ่าน Dio) ส่วน side effect "แสดง SnackBar ตอนมี foreground message" แยกไปอยู่ที่ `push_notifier.dart` (presentation layer) — `scaffoldMessengerKey` ยังคงเป็น global key ที่ประกาศใน `core/app.dart`

## 10. ลำดับการทำงาน (Implementation Sequencing)

1. อัปเดต `pubspec.yaml`, รัน `flutter pub get`
2. สร้าง `lib/core/network/` (ยังไม่มีใครเรียกใช้ ทดสอบ compile ได้อิสระ)
3. สร้าง `shared/models/app_user.dart` — โมเดล Freezed ตัวแรก รัน build_runner เพื่อพิสูจน์ codegen pipeline
4. ทำ `features/auth/` ให้ครบ (model → repository → notifier → screens)
5. ทำ `features/feed/` ให้ครบ พร้อมย้าย `PostCard`/`EditPostSheet` เข้า `shared/widgets/`
6. ทำ `features/profile/` — ยืนยันว่า shared post-list logic ใช้ซ้ำกับ feature ที่สองได้จริง
7. ทำ `features/notifications/`
8. ทำ `core/theme/`
9. ทำ `core/router/` (ต้องรอทุก feature compile ได้ก่อน เพราะ router import ทุกหน้าจอ)
10. รีไรต์ `core/app.dart` + `main.dart`, ลบไฟล์เก่าทั้งหมด (`lib/providers/`, `lib/services/`, `lib/screens/`, `lib/widgets/`, `lib/models/`)
11. รัน `flutter analyze`, รัน build_runner รอบสุดท้าย, grep หา import เก่าที่ตกค้าง, เขียน barrel export (`feature.dart`) ของแต่ละ feature เป็นขั้นตอนสุดท้าย

## 11. ความเสี่ยง / คำถามเปิด (Risks / Open Questions)

- **Shared post-list logic:** แนวทางฟังก์ชันกลางยังทำให้ `FeedNotifier`/`ProfileNotifier` ต้องมี wrapper method ของตัวเองเรียกฟังก์ชันกลางอีกที (มี boilerplate เหลืออยู่บ้าง) — พิจารณาแล้วว่าดีกว่าทางเลือกอื่น (เช่น `.family` provider) เพราะ Feed มี state พิเศษ (`isPosting`) ที่ Profile ไม่มี
- **AuthState เป็น `AsyncValue<AppUser?>`:** ทำให้ boilerplate น้อยลงแต่ explicit น้อยกว่า enum 3 ค่าเดิม (unknown/signedOut/signedIn) — ยอมรับ tradeoff นี้
- **Notifications polling scope:** ค่าเริ่มต้นใช้ lazy (ไม่ keepAlive) ต่างจากพฤติกรรมเดิมที่ polling ทำงานตลอดตั้งแต่ล็อกอินจนกว่าจะ sign out — ถ้าต้องการพฤติกรรมเดิมต้องเปลี่ยนเป็น `@Riverpod(keepAlive: true)`
- **`Post.isMine` getter:** ยืนยันว่าเป็น dead code ปัจจุบัน จะไม่พอร์ตต่อในเวอร์ชัน Freezed
- **GoRouter reactivity:** ต้อง spike/พิสูจน์แนวทาง `refreshListenable` bridge ให้ทำงานกับ Riverpod `AsyncNotifier` ได้จริงก่อนเริ่มขั้นตอนที่ 9

## 12. เกณฑ์ยอมรับ (Acceptance Criteria)

- โครงสร้าง `lib/` ตรงกับผังในหัวข้อ 3 ทุกไฟล์ ไม่มีไฟล์หลงเหลือใน `lib/models/`, `lib/providers/`, `lib/screens/`, `lib/services/`, `lib/widgets/` (ลบโฟลเดอร์เดิมทั้งหมด)
- `pubspec.yaml` มี riverpod/freezed/dio/go_router/build_runner ครบ และไม่มี `provider`/`http` หลงเหลือ
- แต่ละ feature มี barrel export `feature.dart` ตามรูปแบบ CLAUDE.md
- `flutter analyze` ผ่านโดยไม่มี error
- แอปยังทำงานได้ครบทุกฟีเจอร์เดิม: sign in/up, feed CRUD+like, profile, notifications+badge, push notification, theme toggle, sign out
