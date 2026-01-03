import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/rotating_co2_logo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeInDown(
              child: _buildProfileHeader(),
            ),
            SizedBox(height: 20),
            // Animated CO2 Logo Section
            FadeInUp(
              delay: Duration(milliseconds: 200),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Environmental Impact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    SizedBox(height: 24),
                    RotatingCO2Logo(
                      size: 220,
                      points: 1250,
                      co2Saved: 12.5,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Keep up the great work!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.mediumGray,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeInUp(
              delay: Duration(milliseconds: 400),
              child: _buildStatsSection(),
            ),
            SizedBox(height: 20),
            FadeInUp(
              delay: Duration(milliseconds: 400),
              child: _buildMenuSection(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryOrange,
            AppTheme.darkOrange,
          ],
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: AppTheme.primaryOrange,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'john.doe@organization.com',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'Verified Driver',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _statItem(
                  icon: FontAwesomeIcons.route,
                  value: '47',
                  label: 'Total Trips',
                  color: AppTheme.info,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: AppTheme.lightGray,
              ),
              Expanded(
                child: _statItem(
                  icon: FontAwesomeIcons.star,
                  value: '4.8',
                  label: 'Rating',
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),
          Divider(height: 32),
          Row(
            children: [
              Expanded(
                child: _statItem(
                  icon: FontAwesomeIcons.coins,
                  value: '1,250',
                  label: 'Reward Points',
                  color: AppTheme.primaryOrange,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: AppTheme.lightGray,
              ),
              Expanded(
                child: _statItem(
                  icon: FontAwesomeIcons.leaf,
                  value: '12.5 kg',
                  label: 'CO₂ Saved',
                  color: AppTheme.ecoGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: FaIcon(icon, color: color, size: 24),
        ),
        SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGray,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.mediumGray,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _menuItem(
            icon: FontAwesomeIcons.car,
            title: 'My Vehicles',
            subtitle: 'Manage your registered vehicles',
            onTap: () {},
          ),
          Divider(height: 1),
          _menuItem(
            icon: FontAwesomeIcons.clockRotateLeft,
            title: 'Trip History',
            subtitle: 'View all your past trips',
            onTap: () {},
          ),
          Divider(height: 1),
          _menuItem(
            icon: FontAwesomeIcons.wallet,
            title: 'Payment Methods',
            subtitle: 'Manage payment options',
            onTap: () {},
          ),
          Divider(height: 1),
          _menuItem(
            icon: FontAwesomeIcons.trophy,
            title: 'Rewards & Achievements',
            subtitle: 'View your rewards',
            onTap: () {},
          ),
          Divider(height: 1),
          _menuItem(
            icon: FontAwesomeIcons.shieldHalved,
            title: 'Safety & Privacy',
            subtitle: 'Security settings',
            onTap: () {},
          ),
          Divider(height: 1),
          _menuItem(
            icon: FontAwesomeIcons.circleQuestion,
            title: 'Help & Support',
            subtitle: 'Get help or contact us',
            onTap: () {},
          ),
          Divider(height: 1),
          _menuItem(
            icon: FontAwesomeIcons.rightFromBracket,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            titleColor: AppTheme.error,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (titleColor ?? AppTheme.primaryOrange).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FaIcon(
          icon,
          color: titleColor ?? AppTheme.primaryOrange,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: titleColor ?? AppTheme.darkGray,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.mediumGray,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppTheme.mediumGray,
      ),
      onTap: onTap,
    );
  }
}
