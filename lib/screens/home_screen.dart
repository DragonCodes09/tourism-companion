import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../constants/languages.dart';
import 'auth_landing_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel currentUser;

  const HomeScreen({
    super.key,
    required this.currentUser,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _dbService = DatabaseService();
  int _selectedNavIndex = 0;

  String _getRegionalGreeting() {
    final lang = kSupportedLanguages.firstWhere(
      (l) =>
          l.englishName.toLowerCase() ==
          widget.currentUser.preferredLanguage.toLowerCase(),
      orElse: () => kSupportedLanguages.first,
    );
    return '${lang.greeting}, ${widget.currentUser.name}!';
  }

  void _handleLogout() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text(
          'Are you sure you want to log out of Travel Sarthi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _dbService.logout();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const AuthLandingScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.explore_rounded, color: Color(0xFF00E5FF)),
            const SizedBox(width: 8),
            const Text(
              'Travel Sarthi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F2027),
        elevation: 2,
        actions: [
          IconButton(
            tooltip: 'Account & Security Details',
            icon: const Icon(Icons.shield_outlined),
            onPressed: _showSecurityDetailsModal,
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0F2027),
                    Color(0xFF203A43),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getRegionalGreeting(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Where would you like your Sarthi to guide you today?',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User language & security badge
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.translate,
                                color: Color(0xFF00E5FF), size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'Language: ${widget.currentUser.preferredLanguage}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF80DEEA),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_rounded,
                                color: Colors.greenAccent, size: 14),
                            SizedBox(width: 6),
                            Text(
                              'SHA-256 Hashed & Salted',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sarthi Quick Actions (Using Location, Camera, Mic)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Smart Travel Tools',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _buildQuickActionCard(
                        icon: Icons.mic_rounded,
                        color: const Color(0xFF5E35B1),
                        title: 'Audio Sarthi',
                        desc: 'Listen in ${widget.currentUser.preferredLanguage}',
                        onTap: () => _showFeatureDialog(
                          title: 'Audio Sarthi Voice Guide',
                          icon: Icons.mic_rounded,
                          color: const Color(0xFF5E35B1),
                          content:
                              'Microphone active! Ask any question or listen to live monument history narrated in ${widget.currentUser.preferredLanguage}.',
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildQuickActionCard(
                        icon: Icons.camera_alt_rounded,
                        color: const Color(0xFFE65100),
                        title: 'AR Scanner',
                        desc: 'Scan monuments & signs',
                        onTap: () => _showFeatureDialog(
                          title: 'Landmark AR Scanner',
                          icon: Icons.camera_alt_rounded,
                          color: const Color(0xFFE65100),
                          content:
                              'Camera active! Point your camera at any Indian historical plaque, stone engraving, or architecture to see translated stories.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildQuickActionCard(
                        icon: Icons.location_on_rounded,
                        color: const Color(0xFF00897B),
                        title: 'Nearby Heritage',
                        desc: 'Live geo-recommendations',
                        onTap: () => _showFeatureDialog(
                          title: 'Location Sarthi',
                          icon: Icons.location_on_rounded,
                          color: const Color(0xFF00897B),
                          content:
                              'GPS active! Detecting heritage sites, regional artisan workshops, and verified hygienic eateries within 5 km.',
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildQuickActionCard(
                        icon: Icons.support_agent_rounded,
                        color: const Color(0xFF1565C0),
                        title: 'Helpline 24/7',
                        desc: 'Tourist police & SOS',
                        onTap: () => _showFeatureDialog(
                          title: 'Traveler Safety & Assistance',
                          icon: Icons.support_agent_rounded,
                          color: const Color(0xFF1565C0),
                          content:
                              'Emergency Toll-Free: 1363 (Tourist Helpline) / 112 (National Emergency). Your location is ready to share if requested.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Featured Destinations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Heritage Trails',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  _buildDestinationCard(
                    title: 'Taj Mahal, Agra',
                    state: 'Uttar Pradesh',
                    rating: '4.9 â˜…',
                    imageEmoji: 'ðŸ›ï¸',
                    tag: 'Audio Tour Available in ${widget.currentUser.preferredLanguage}',
                  ),
                  const SizedBox(height: 14),
                  _buildDestinationCard(
                    title: 'Hawa Mahal, Jaipur',
                    state: 'Rajasthan',
                    rating: '4.8 â˜…',
                    imageEmoji: 'ðŸ°',
                    tag: 'Royal Architecture AR Scan',
                  ),
                  const SizedBox(height: 14),
                  _buildDestinationCard(
                    title: 'Meenakshi Amman Temple, Madurai',
                    state: 'Tamil Nadu',
                    rating: '4.9 â˜…',
                    imageEmoji: 'ðŸ›•',
                    tag: 'Cultural Stories & Sculpture Guide',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        selectedItemColor: const Color(0xFF00897B),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headphones_rounded),
            label: 'Audio Tours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationCard({
    required String title,
    required String state,
    required String rating,
    required String imageEmoji,
    required String tag,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF00897B).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                imageEmoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00897B).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF004D40),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureDialog({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSecurityDetailsModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.security_rounded,
                    color: Color(0xFF00897B), size: 28),
                const SizedBox(width: 10),
                const Text(
                  'Account Security & Database Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDetailRow('User ID:', widget.currentUser.id),
            _buildDetailRow('Name:', widget.currentUser.name),
            _buildDetailRow('Email:', widget.currentUser.email),
            _buildDetailRow('Phone:', widget.currentUser.phone),
            _buildDetailRow('Language:', widget.currentUser.preferredLanguage),
            _buildDetailRow(
              'Password Hash (SHA-256):',
              '${widget.currentUser.passwordHash.substring(0, 16)}... (encrypted)',
            ),
            _buildDetailRow(
              'Salt:',
              '${widget.currentUser.salt.substring(0, 8)}... (cryptographic)',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}

