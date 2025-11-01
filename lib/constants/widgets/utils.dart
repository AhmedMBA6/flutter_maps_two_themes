String generateCountryFlag(String countryCode) {
  // Ensure the code is uppercase (e.g., 'eg' → 'EG')
  return countryCode.toUpperCase().codeUnits.map(
    (unit) => String.fromCharCode(unit + 127397),
  ).join();
}

String formatDuration(String durationString) {
  // Remove any 's' or 'sec' suffix
  final raw = durationString.replaceAll(RegExp(r'[^0-9]'), '');
  final seconds = int.tryParse(raw) ?? 0;

  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;

  if (hours > 0) {
    return '$hours hr ${minutes.toString().padLeft(2, '0')} min';
  } else {
    return '$minutes min';
  }
}
