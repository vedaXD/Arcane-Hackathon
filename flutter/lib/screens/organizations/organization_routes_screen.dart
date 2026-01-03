import 'package:flutter/material.dart';

class OrganizationRoutesScreen extends StatefulWidget {
  final String organizationName;
  final int organizationId;

  const OrganizationRoutesScreen({
    Key? key,
    required this.organizationName,
    required this.organizationId,
  }) : super(key: key);

  @override
  State<OrganizationRoutesScreen> createState() => _OrganizationRoutesScreenState();
}

class _OrganizationRoutesScreenState extends State<OrganizationRoutesScreen> {
  List<Map<String, dynamic>> _routes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  void _loadRoutes() {
    setState(() => _isLoading = true);
    
    // TODO: Load from API
    // Mock data for demonstration
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _routes = [
          {
            'id': 1,
            'name': 'Home to Office (Morning)',
            'origin_name': 'Koramangala',
            'destination_name': widget.organizationName,
            'estimated_distance': 12.5,
            'estimated_duration': 30,
            'usage_count': 45,
          },
          {
            'id': 2,
            'name': 'HSR Layout to Office',
            'origin_name': 'HSR Layout',
            'destination_name': widget.organizationName,
            'estimated_distance': 8.2,
            'estimated_duration': 20,
            'usage_count': 32,
          },
          {
            'id': 3,
            'name': 'Whitefield to Office',
            'origin_name': 'Whitefield',
            'destination_name': widget.organizationName,
            'estimated_distance': 15.0,
            'estimated_duration': 40,
            'usage_count': 28,
          },
        ];
        _isLoading = false;
      });
    });
  }

  void _useRoute(Map<String, dynamic> route, {bool reversed = false}) {
    final originName = reversed ? route['destination_name'] : route['origin_name'];
    final destName = reversed ? route['origin_name'] : route['destination_name'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reversed ? 'Return Route' : 'Use Route'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From: $originName',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'To: $destName',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              '${route['estimated_distance']} km • ${route['estimated_duration']} min',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to create trip with pre-filled data
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Route loaded! Fill remaining details.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Create Trip'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preset Routes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.organizationName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _routes.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _routes.length,
                  itemBuilder: (context, index) {
                    return _buildRouteCard(_routes[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Create new route
        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add),
        label: const Text('New Route'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.route, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No preset routes yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Create routes for common commute paths',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> route) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.route, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${route['usage_count']} trips',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Route Details
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.circle, color: Colors.green, size: 12),
                          SizedBox(width: 8),
                          Text(
                            'From',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        route['origin_name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: Colors.red, size: 12),
                          SizedBox(width: 8),
                          Text(
                            'To',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        route['destination_name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Stats
            Row(
              children: [
                _buildStat(Icons.straighten, '${route['estimated_distance']} km'),
                const SizedBox(width: 16),
                _buildStat(Icons.access_time, '${route['estimated_duration']} min'),
              ],
            ),
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _useRoute(route),
                    icon: const Icon(Icons.north, size: 16),
                    label: const Text('Use Route'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _useRoute(route, reversed: true),
                    icon: const Icon(Icons.swap_vert, size: 16),
                    label: const Text('Reverse'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
