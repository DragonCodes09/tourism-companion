import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'permissions_screen.dart';

class AuthLandingScreen extends StatefulWidget {
  const AuthLandingScreen({super.key});

  @override
  State<AuthLandingScreen> createState() => _AuthLandingScreenState();
}

class _AuthLandingScreenState extends State<AuthLandingScreen> {
  final ApiService _apiService = ApiService();

  // null = checking, true = online, false = offline
  bool? _serverOnline;

  @override
  void initState() {
    super.initState();
    _checkServerStatus();
  }

  Future<void> _checkServerStatus() async {
    final online = await _apiService.isBackendOnline();
    if (mounted) {
      setState(() => _serverOnline = online);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Server Status Badge ──────────────────────────────────
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _serverOnline = null);
                      _checkServerStatus();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _serverOnline == null
                            ? Colors.grey.withValues(alpha: 0.25)
                            : _serverOnline!
                                ? Colors.green.withValues(alpha: 0.22)
                                : Colors.orange.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _serverOnline == null
                              ? Colors.grey.withValues(alpha: 0.5)
                              : _serverOnline!
                                  ? Colors.greenAccent.withValues(alpha: 0.6)
                                  : Colors.orangeAccent.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _serverOnline == null
                              ? const SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                    color: Colors.white54,
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : Icon(
                                  _serverOnline!
                                      ? Icons.cloud_done_outlined
                                      : Icons.cloud_off_outlined,
                                  size: 13,
                                  color: _serverOnline!
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                ),
                          const SizedBox(width: 5),
                          Text(
                            _serverOnline == null
                                ? 'Checking...'
                                : _serverOnline!
                                    ? 'Server Online'
                                    : 'Offline Mode',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _serverOnline == null
                                  ? Colors.white54
                                  : _serverOnline!
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ── Hero Logo & App Title ────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00B4DB).withValues(alpha: 0.3),
                        blurRadius: 25,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.explore_rounded,
                    size: 68,
                    color: Color(0xFF00E5FF),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Travel Sarthi',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ट्रैवल सार्थी • Your Smart Companion',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.tealAccent.withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    'Multi-lingual • Audio Guide • Regional Assistance',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF80DEEA),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Offline Mode Notice ──────────────────────────────────
                if (_serverOnline == false)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: Colors.orangeAccent.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: Colors.orangeAccent, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Running in offline mode — data will be saved locally on this device.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[200],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => _serverOnline = null);
                            _checkServerStatus();
                          },
                          child: const Icon(Icons.refresh,
                              color: Colors.orangeAccent, size: 18),
                        ),
                      ],
                    ),
                  ),

                // ── Feature Cards ────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    children: [
                      _buildFeatureRow(
                        Icons.mic_none_rounded,
                        'Regional Voice Sarthi',
                        'Explore monuments in your native Indian language',
                      ),
                      const Divider(color: Colors.white12, height: 18),
                      _buildFeatureRow(
                        Icons.camera_alt_outlined,
                        'Smart Visual Scanner',
                        'Scan heritage sights for real-time history & stories',
                      ),
                      const Divider(color: Colors.white12, height: 18),
                      _buildFeatureRow(
                        Icons.location_on_outlined,
                        'Nearby Curated Routes',
                        'Personalized travel trails & safe regional guidance',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Register Button ──────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PermissionsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C9FF),
                      foregroundColor: const Color(0xFF0F2027),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_add_alt_1_rounded, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Register New User',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Login Button ─────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(
                          color: Color(0xFF80DEEA), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login_rounded, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Login to Existing Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF80DEEA), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
