import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../theme/app_theme.dart';

class MyCarpoolsScreen extends StatefulWidget {
  const MyCarpoolsScreen({super.key});

  @override
  State<MyCarpoolsScreen> createState() => _MyCarpoolsScreenState();
}

class _MyCarpoolsScreenState extends State<MyCarpoolsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBeige,
      appBar: AppBar(
        title: const Text('My Carpools'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryOrange,
          labelColor: AppTheme.primaryOrange,
          unselectedLabelColor: AppTheme.mediumGray,
          tabs: const [
            Tab(text: 'Active Carpools'),
            Tab(text: 'Past Carpools'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveCarpools(),
          _buildPastCarpools(),
        ],
      ),
    );
  }

  Widget _buildActiveCarpools() {
    final carpools = [
      {
        'route': 'Chembur Railway Station → VESIT College',
        'organization': 'VESIT College',
        'date': 'Jan 4, 2026',
        'time': '8:30 AM',
        'vehicleOwner': 'Amit Sharma',
        'isOwner': false,
        'members': [
          {'name': 'Amit Sharma', 'role': 'Vehicle Owner'},
          {'name': 'You', 'role': 'Member'},
          {'name': 'Priya Desai', 'role': 'Member'},
        ],
        'seats': 3,
        'status': 'Confirmed',
      },
      {
        'route': 'Dadar → BKC Office',
        'organization': 'TCS',
        'date': 'Jan 5, 2026',
        'time': '9:00 AM',
        'vehicleOwner': 'You',
        'isOwner': true,
        'members': [
          {'name': 'You', 'role': 'Vehicle Owner'},
          {'name': 'Rahul Kumar', 'role': 'Member'},
        ],
        'seats': 2,
        'status': 'Looking for members',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: carpools.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          delay: Duration(milliseconds: 100 * index),
          child: _buildCarpoolCard(carpools[index], true),
        );
      },
    );
  }

  Widget _buildPastCarpools() {
    final carpools = [
      {
        'route': 'Kurla Station → TCS Yantra Park',
        'organization': 'TCS',
        'date': 'Jan 2, 2026',
        'time': '8:45 AM',
        'vehicleOwner': 'Suresh Patel',
        'isOwner': false,
        'members': [
          {'name': 'Suresh Patel', 'role': 'Vehicle Owner'},
          {'name': 'You', 'role': 'Member'},
          {'name': 'Anjali Mehta', 'role': 'Member'},
          {'name': 'Vikram Singh', 'role': 'Member'},
        ],
        'seats': 4,
        'status': 'Completed',
      },
    ];

    if (carpools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: AppTheme.mediumGray.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No past carpools',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.mediumGray,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: carpools.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          delay: Duration(milliseconds: 100 * index),
          child: _buildCarpoolCard(carpools[index], false),
        );
      },
    );
  }

  Widget _buildCarpoolCard(Map<String, dynamic> carpool, bool isActive) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    carpool['organization'],
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(carpool['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    carpool['status'],
                    style: TextStyle(
                      fontSize: 11,
                      color: _getStatusColor(carpool['status']),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    carpool['route'].split('→')[0].trim(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 2,
                  height: 20,
                  margin: const EdgeInsets.only(left: 3),
                  color: Colors.grey[400],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    carpool['route'].split('→')[1].trim(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppTheme.mediumGray),
                const SizedBox(width: 4),
                Text(
                  '${carpool['date']} • ${carpool['time']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Carpool Members:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${carpool['seats']} people',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...((carpool['members'] as List<Map<String, String>>).map((member) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: member['name'] == 'You'
                          ? AppTheme.primaryOrange
                          : member['role'] == 'Vehicle Owner'
                              ? AppTheme.ecoGreen
                              : AppTheme.info,
                      child: Text(
                        member['name']!.substring(0, 1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member['name']!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: member['name'] == 'You'
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                          Text(
                            member['role']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (member['role'] == 'Vehicle Owner')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.ecoGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.directions_car,
                          size: 14,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              );
            }).toList()),
            if (isActive) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat, size: 18),
                      label: const Text('Group Chat'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryOrange,
                        side: BorderSide(color: AppTheme.primaryOrange),
                      ),
                    ),
                  ),
                  if (carpool['isOwner'] == false) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.cancel, size: 18),
                        label: const Text('Leave'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Looking for members':
        return Colors.orange;
      case 'Completed':
        return Colors.blue;
      default:
        return AppTheme.mediumGray;
    }
  }
}
