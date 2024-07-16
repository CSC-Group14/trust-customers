import 'package:flutter/material.dart';
import 'package:trust/screens/map_screen.dart'; // Import the map page

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeBoda'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WalletSection(),
            const SizedBox(height: 10),
            ServicesSection(),
            const SizedBox(height: 10),
            DiscoverSection(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class WalletSection extends StatelessWidget {
  const WalletSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.orange.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Good Evening, Ronnie!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.orange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Wallet',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'UGX ●●●●●',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.visibility,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Deposit Money'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WalletActionButton(icon: Icons.send, label: 'Send Money'),
              WalletActionButton(icon: Icons.arrow_downward, label: 'Withdraw'),
              WalletActionButton(icon: Icons.history, label: 'Transactions'),
              WalletActionButton(icon: Icons.payment, label: 'Pay'),
            ],
          ),
        ],
      ),
    );
  }
}

class WalletActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const WalletActionButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () {},
          color: Colors.orange,
        ),
        Text(label),
      ],
    );
  }
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ServiceButton(
            icon: Icons.directions_car, label: 'Order a SafeCar', onTap: () {}),
        ServiceButton(
          icon: Icons.two_wheeler,
          label: 'Order a SafeBoda',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeTabPage()),
            );
          },
        ),
        ServiceButton(icon: Icons.receipt, label: 'Pay Bills', onTap: () {}),
        ServiceButton(
            icon: Icons.local_shipping, label: 'Deliver Package', onTap: () {}),
        ServiceButton(
            icon: Icons.phone_android, label: 'Airtime & Data', onTap: () {}),
      ],
    );
  }
}

class ServiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ServiceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.orange),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DiscoverSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: const [
              Text(
                'Discover SafeBoda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              DiscoverCard(),
              DiscoverCard(),
              DiscoverCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class DiscoverCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(left: 16, right: 8),
      color: Colors.blueGrey,
      child: Column(
        children: const [
          Expanded(
            child: Image(
              image: AssetImage('images/sample_ad.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Islamic Halal Brunch',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.safety_divider),
          label: 'SafeBoda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'My account',
        ),
      ],
      currentIndex: 1,
      selectedItemColor: Colors.orange,
      onTap: (index) {
        // Handle tab change
      },
    );
  }
}
