String generateCountryFlag(String countryCode) {
  // Ensure the code is uppercase (e.g., 'eg' → 'EG')
  return countryCode.toUpperCase().codeUnits.map(
    (unit) => String.fromCharCode(unit + 127397),
  ).join();
}
