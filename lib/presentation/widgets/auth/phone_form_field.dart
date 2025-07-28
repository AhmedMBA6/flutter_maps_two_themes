import 'package:flutter/material.dart';
import '../../../constants/themes/app_colors.dart';
import '../../../constants/widgets/utils.dart';

class Country {
  final String name;
  final String code; // e.g. "EG"
  final String dialCode; // e.g. "+20"

  Country({required this.name, required this.code, required this.dialCode});
}

class PhoneFormField extends StatefulWidget {
  final TextEditingController controller;

  const PhoneFormField({super.key, required this.controller});

  @override
  State<PhoneFormField> createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends State<PhoneFormField> {
  late Country selectedCountry;
  final List<Country> countries = [
    Country(name: 'Egypt', code: 'EG', dialCode: '+20'),
    Country(name: 'United States', code: 'US', dialCode: '+1'),
    Country(name: 'UAE', code: 'AE', dialCode: '+971'),
    Country(name: 'Saudi Arabia', code: 'SA', dialCode: '+966'),
  ];

  @override
  void initState() {
    super.initState();
    selectedCountry = countries[0]; // Default to Egypt
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        // Country Picker Dropdown
        DropdownButton<Country>(
          value: selectedCountry,
          underline: const SizedBox(),
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.gray900,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.1,
          ),
          onChanged: (Country? newCountry) {
            if (newCountry != null) {
              setState(() {
                selectedCountry = newCountry;
              });
            }
          },
          items: countries.map((country) {
            return DropdownMenuItem<Country>(
              value: country,
              child: Row(
                children: [
                  Text(generateCountryFlag(country.code)),
                  const SizedBox(width: 4),
                  Text(country.dialCode),
                ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(width: 8),

        // Phone Number Input Field
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Enter your phone number',
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : AppColors.gray400,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: isDark ? AppColors.gray600 : AppColors.gray100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : AppColors.gray900,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              } else if (value.length < 7) {
                return 'Enter a valid number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
