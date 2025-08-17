# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

# Add the missing rules from R8 analysis
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.concurrent.GuardedBy

# Tink crypto library
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# Required for flutter_local_notifications
-dontwarn javax.annotation.**

# Additional missing classes
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.**
-dontwarn android.support.design.R

# Additional Flutter rules
-keep class com.example.habit_breaker_app.** { *; }