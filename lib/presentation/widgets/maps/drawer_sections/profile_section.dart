import 'package:flutter/material.dart';
import '../../../../constants/themes/app_colors.dart';
import 'section_header.dart';
import 'profile_option.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Profile',
            subtitle: 'Manage your account',
          ),
          const SizedBox(height: 20),
          
          // Profile info
          _buildProfileInfo(),
          const SizedBox(height: 24),
          
          // Profile options
          Expanded(
            child: _buildProfileOptions(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderDark,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Profile avatar
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Profile details
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    color: AppColors.gray400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Edit button
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppColors.gray400,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Column(
      children: [
        ProfileOption(
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'App preferences and configuration',
          onTap: () {},
        ),
        ProfileOption(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Manage notification preferences',
          onTap: () {},
        ),
        ProfileOption(
          icon: Icons.privacy_tip,
          title: 'Privacy',
          subtitle: 'Privacy and security settings',
          onTap: () {},
        ),
        ProfileOption(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () {},
        ),
        const Spacer(),
        ProfileOption(
          icon: Icons.logout,
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          onTap: () {},
          isDestructive: true,
        ),
      ],
    );
  }
}
