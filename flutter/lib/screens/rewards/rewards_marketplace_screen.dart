import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class RewardsMarketplaceScreen extends StatefulWidget {
  const RewardsMarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<RewardsMarketplaceScreen> createState() => _RewardsMarketplaceScreenState();
}

class _RewardsMarketplaceScreenState extends State<RewardsMarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _userDiamonds = 1250;

  final List<Map<String, dynamic>> _rewards = [
    {
      'name': 'Wireless Headphones',
      'discount': '20% OFF',
      'price': 450,
      'image': '🎧',
      'category': 'Electronics',
    },
    {
      'name': 'Coffee Voucher',
      'discount': 'FREE',
      'price': 150,
      'image': '☕',
      'category': 'Food',
    },
    {
      'name': 'Movie Tickets',
      'discount': '2 for 1',
      'price': 300,
      'image': '🎬',
      'category': 'Entertainment',
    },
    {
      'name': 'Gym Membership',
      'discount': '30% OFF',
      'price': 800,
      'image': '💪',
      'category': 'Fitness',
    },
    {
      'name': 'Book Store Voucher',
      'discount': '₹500 OFF',
      'price': 400,
      'image': '📚',
      'category': 'Shopping',
    },
    {
      'name': 'Spa Package',
      'discount': '25% OFF',
      'price': 650,
      'image': '💆',
      'category': 'Wellness',
    },
  ];

  final List<Map<String, dynamic>> _ngos = [
    {
      'name': 'Green Earth Foundation',
      'cause': 'Tree Plantation',
      'image': '🌳',
      'impact': '1 tree = 50 💎',
    },
    {
      'name': 'Clean Air Initiative',
      'cause': 'Air Quality Monitoring',
      'image': '🌫️',
      'impact': '1 sensor = 200 💎',
    },
    {
      'name': 'Solar For All',
      'cause': 'Clean Energy',
      'image': '☀️',
      'impact': '1 panel = 500 💎',
    },
    {
      'name': 'Ocean Cleanup',
      'cause': 'Ocean Conservation',
      'image': '🌊',
      'impact': '1kg plastic = 100 💎',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App Bar with Balance
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.purple.shade400,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple.shade400,
                      Colors.blue.shade400,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInDown(
                          child: const Text(
                            'Carbon Crystals',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeInDown(
                          delay: const Duration(milliseconds: 100),
                          child: Row(
                            children: [
                              const Text(
                                '💎',
                                style: TextStyle(fontSize: 32),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$_userDiamonds',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.purple.shade700,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.purple.shade700,
                tabs: const [
                  Tab(text: 'Rewards 🎁'),
                  Tab(text: 'Trade 💱'),
                  Tab(text: 'Donate 🌱'),
                ],
              ),
            ),
          ),

          // Tab Views
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRewardsTab(),
                _buildTradeTab(),
                _buildDonateTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _rewards.length,
      itemBuilder: (context, index) {
        final reward = _rewards[index];
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          child: _buildRewardCard(reward),
        );
      },
    );
  }

  Widget _buildRewardCard(Map<String, dynamic> reward) {
    final canAfford = _userDiamonds >= reward['price'];
    
    return GestureDetector(
      onTap: () => _showRewardDetails(reward),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/Emoji
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade50, Colors.blue.shade50],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  reward['image'],
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Discount Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        reward['discount'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Name
                    Text(
                      reward['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    
                    // Price
                    Row(
                      children: [
                        const Text(
                          '💎',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${reward['price']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: canAfford ? Colors.purple.shade700 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            child: const Text(
              'Trade Diamonds',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'Send or receive diamonds from friends',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Send Diamonds Card
          FadeInLeft(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.teal.shade400],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.send, color: Colors.white, size: 32),
                      SizedBox(width: 12),
                      Text(
                        'Send Diamonds',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Friend\'s email or username',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Amount (💎)',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.diamond),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showTradeConfirmation('send', 100);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Send Diamonds',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Recent Trades
          FadeInUp(
            child: const Text(
              'Recent Trades',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          ...List.generate(3, (index) {
            final isReceived = index % 2 == 0;
            return FadeInUp(
              delay: Duration(milliseconds: index * 100),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isReceived 
                          ? Colors.green.shade100 
                          : Colors.red.shade100,
                      child: Icon(
                        isReceived ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isReceived ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isReceived 
                                ? 'Received from Sarah'
                                : 'Sent to Rahul',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '2 hours ago',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isReceived ? "+" : "-"}${50 + index * 25} 💎',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isReceived ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDonateTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _ngos.length,
      itemBuilder: (context, index) {
        final ngo = _ngos[index];
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          ngo['image'],
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ngo['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ngo['cause'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Impact: ${ngo['impact']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showDonationDialog(ngo),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Donate Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRewardDetails(Map<String, dynamic> reward) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              reward['image'],
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 16),
            Text(
              reward['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                reward['discount'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '💎',
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 8),
                Text(
                  '${reward['price']}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _userDiamonds >= reward['price']
                    ? () {
                        Navigator.pop(context);
                        _redeemReward(reward);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _userDiamonds >= reward['price']
                      ? 'Redeem Now'
                      : 'Not Enough Diamonds',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _redeemReward(Map<String, dynamic> reward) {
    setState(() {
      _userDiamonds -= reward['price'] as int;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Redeemed ${reward['name']}! 🎉'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDonationDialog(Map<String, dynamic> ngo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Donate to ${ngo['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Donation Amount (💎)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.diamond),
              ),
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
              Navigator.pop(context);
              setState(() {
                _userDiamonds -= 100;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for your donation! 🌱'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Donate'),
          ),
        ],
      ),
    );
  }

  void _showTradeConfirmation(String type, int amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 12),
            Text('Confirm Trade'),
          ],
        ),
        content: Text('Send $amount 💎 to friend?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _userDiamonds -= amount;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Diamonds sent successfully! 💎'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
