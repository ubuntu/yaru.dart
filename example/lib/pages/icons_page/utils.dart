String beautifyIconName(String iconName) {
  iconName = iconName.replaceAll('_', ' ');

  return iconName.isNotEmpty
      ? '${iconName[0].toUpperCase()}${iconName.substring(1).toLowerCase()}'
      : '';
}
