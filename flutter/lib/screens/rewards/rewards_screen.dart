import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../theme/app_theme.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int diamondBalance = 1250;
  
  final List<Map<String, dynamic>> ngoList = [
    {
      'name': 'Green Earth Foundation',
      'description': 'Plant trees and restore forests',
      'icon': Icons.park,
      'color': Colors.green,
      'minDonation': 100,
    },
    {
      'name': 'Clean Air Initiative',
      'description': 'Reduce pollution in urban areas',
      'icon': Icons.air,
      'color': Colors.cyan,
      'minDonation': 50,
    },
    {
      'name': 'Ocean Conservation Trust',
      'description': 'Protect marine ecosystems',
      'icon': Icons.waves,
      'color': Colors.blue,
      'minDonation': 150,
    },
  ];
  
  final List<Map<String, dynamic>> rewardsList = [
    {
      'title': '10% Off Coffee at CafeBuzz',
      'description': 'Valid at all CafeBuzz outlets',
      'cost': 200,
      'icon': Icons.coffee,
      'color': Colors.brown,
      'category': 'Food & Beverage',
    },
    {
      'title': '₹50 Off on EcoMart',
      'description': 'Minimum purchase ₹500',
      'cost': 150,
      'icon': Icons.shopping_bag,
      'color': Colors.orange,
      'category': 'Shopping',
    },
    {
      'title': '20% Off Movie Tickets',
      'description': 'Valid at CinePlex theaters',
      'cost': 300,
      'icon': Icons.movie,
      'color': Colors.purple,
      'category': 'Entertainment',
    },
    {
      'title': 'Free Delivery on FoodHub',
      'description': 'One-time use coupon',
      'cost': 100,
      'icon': Icons.delivery_dining,
      'color': Colors.red,
      'category': 'Food Delivery',
    },
    {
      'title': '₹100 Off Gym Membership',
      'description': 'Valid at FitZone gyms',
      'cost': 250,
      'icon': Icons.fitness_center,
      'color': Colors.teal,
      'category': 'Health & Fitness',
    },
    {
      'title': '15% Off Books at ReadMore',
      'description': 'Online and in-store',
      'cost': 180,
      'icon': Icons.book,
      'color': Colors.indigo,
      'category': 'Books & Education',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showDonateDialog() {
    int selectedAmount = 100;
    String? selectedNgo;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 12),
              Text('Donate Real Money'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select an NGO and donation amount:', style: TextStyle(fontSize: 14)),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Choose NGO',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: ngoList.map((ngo) {
                  return DropdownMenuItem<String>(
                    value: ngo['name'] as String,
                    child: Text(ngo['name'] as String),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() => selectedNgo = value);
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount (₹)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setDialogState(() => selectedAmount = int.tryParse(value) ?? 100);
                },
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.green.shade700),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Earn ${(selectedAmount * 0.5).toInt()} 💎 (based on CO₂ impact)',
                        style: TextStyle(fontSize: 11, color: Colors.green.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedNgo == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select an NGO')),
                  );
                  return;
                }
                // Calculate diamonds earned (50% of rupees donated)
                int diamondsEarned = (selectedAmount * 0.5).toInt();
                setState(() => diamondBalance += diamondsEarned);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Donated ₹$selectedAmount to $selectedNgo! Earned $diamondsEarned 💎 based on CO₂ impact! 🙏'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 4),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Donate'),
            ),
          ],
        ),
      ),
    );
  }

  void _redeemReward(Map<String, dynamic> reward) {
    if (diamondBalance < reward['cost']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insufficient balance! Need ${reward['cost']} 💎')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Redeem Reward?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(reward['icon'], size: 48, color: reward['color']),
            SizedBox(height: 16),
            Text(
              reward['title'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              reward['description'],
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${reward['cost']} 💎',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => diamondBalance -= reward['cost'] as int);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reward redeemed! Check your email for coupon code 🎉'),
                  backgroundColor: Colors.green,
                ),
              );
            },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.ecoGreen),
            child: Text('Redeem'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppTheme.ecoGreen,
        title: Text('Rewards & Impact'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Diamond Showcase with Animation
            FadeInDown(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.ecoGreen, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Diamond Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.1).animate(_pulseController),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '💎',
                            style: TextStyle(fontSize: 48),
                          ),
                          SizedBox(width: 12),
                          Text(
                            '$diamondBalance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Keep riding to earn more! 🚗',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: FadeInLeft(
                      child: _buildActionButton(
                        icon: Icons.favorite,
                        title: 'Donate to NGOs',
                        subtitle: 'Make an impact',
                        color: Colors.green,
                        onTap: _showDonateDialog,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: FadeInRight(
                      child: _buildActionButton(
                        icon: Icons.card_giftcard,
                        title: 'Redeem Rewards',
                        subtitle: 'Get discounts',
                        color: AppTheme.ecoGreen,
                        onTap: () {
                          // Scroll to rewards section
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // NGO Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    child: Text(
                      'Featured NGO Partners',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ...ngoList.asMap().entries.map((entry) {
                    return FadeInUp(
                      delay: Duration(milliseconds: entry.key * 100),
                      child: _buildNgoCard(entry.value),
                    );
                  }).toList(),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Rewards Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    child: Text(
                      'Available Rewards',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ...rewardsList.asMap().entries.map((entry) {
                    return FadeInUp(
                      delay: Duration(milliseconds: entry.key * 80),
                      child: _buildRewardCard(entry.value),
                    );
                  }).toList(),
                ],
              ),
            ),
            
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNgoCard(Map<String, dynamic> ngo) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ngo['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(ngo['icon'], color: ngo['color'], size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ngo['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  ngo['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Min. ₹${ngo['minDonation']} donation',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green,
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

  Widget _buildRewardCard(Map<String, dynamic> reward) {
    bool canAfford = diamondBalance >= reward['cost'];
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _redeemReward(reward),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: reward['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(reward['icon'], color: reward['color'], size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        reward['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              reward['category'],
                              style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: canAfford 
                            ? Colors.orange.shade50 
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${reward['cost']} 💎',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: canAfford ? Colors.orange : Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      canAfford ? 'Tap to redeem' : 'Need more 💎',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
