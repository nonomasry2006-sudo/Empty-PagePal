class SettingsState {
  const SettingsState({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
  });

  final bool isDarkMode;
  final bool notificationsEnabled;

  SettingsState copyWith({bool? isDarkMode, bool? notificationsEnabled}) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
