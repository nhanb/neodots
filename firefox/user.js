// Symlink this to
// ~/.mozilla/firefox/XXXXXXXX.your_profile_name/user.js

// Windows-style scrollbar, which is wider than those dumb
// "modern" qt/gtk abominations.
//user_pref("widget.non-native-theme.scrollbar.style", 4);

// Force animated loading tab icon
user_pref("ui.prefersReducedMotion", 0);

// Force light mode aka prevent smartass websites from looking like garbage
user_pref("layout.css.prefers-color-scheme.content-override", 1);

user_pref("ui.key.menuAccessKeyFocuses", false); // don't show menu on Alt

user_pref("general.smoothScroll", false);
