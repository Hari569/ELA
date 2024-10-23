import 'package:flutter/material.dart';
import 'order_history_screen.dart';
import 'track_order_screen.dart';
import 'cash_refund_screen.dart';
import 'Account_Screen.dart';
import 'Category_Screen.dart';
import 'store_screen.dart';
import 'plant_parenting_screen.dart';
import 'ELA_Education_Screen.dart';
import 'QA_Screen.dart';
import 'contest_screen.dart';
import 'our_policies_screen.dart';
import 'support_screen.dart';
import 'rate_app_screen.dart';
import 'login_register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _username = prefs.getString('username') ?? '';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');
    setState(() {
      _isLoggedIn = false;
      _username = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ELA'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            _buildShoppingSection(context),
            _buildMenuSection(context),
            _buildParentingSection(context),
            _buildCustomerServiceSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.green),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _isLoggedIn
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $_username',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _logout,
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : TextButton(
                    onPressed: () => _navigateToLoginRegister(context),
                    child: const Text(
                      'Login/Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _navigateToLoginRegister(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginRegisterScreen()),
    );
    if (result == true) {
      _checkLoginStatus();
    }
  }

  Widget _buildShoppingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Shopping',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(Icons.person, 'Account', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              }),
              _buildIconButton(Icons.history, 'Order History', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
                );
              }),
              _buildIconButton(Icons.local_shipping, 'Track Order', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrackOrderScreen()),
                );
              }),
              _buildIconButton(Icons.money, 'Cash Refund', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CashRefundScreen()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Menu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMenuCard('Categories', Colors.pink[100]!, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
              }),
              _buildMenuCard('Plant Store', Colors.green[100]!, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StoreScreen()),
                );
              }),
              _buildMenuCard('Plant Care', Colors.purple[100]!, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlantParentingScreen()),
                );
              }),
              _buildMenuCard('ELA Education', Colors.blue[100]!, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ELAEducationScreen()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParentingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Plant Parenting',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(Icons.home, 'My Garden', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlantParentingScreen()),
                );
              }),
              _buildIconButton(Icons.emoji_events, 'Contests', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContestScreen()),
                );
              }),
              _buildIconButton(Icons.question_answer, 'Expert Q&A', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QAScreen()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerServiceSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Customer Service',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildListTile(Icons.policy, 'Our Policies', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OurPoliciesScreen()),
            );
          }),
          _buildListTile(Icons.support, 'Support', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SupportScreen()),
            );
          }),
          _buildListTile(
            Icons.star,
            'Rate the app',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RateAppScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMenuCard(String label, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
