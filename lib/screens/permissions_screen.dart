import 'package:flutter/material.dart';
import '../services/permission_service.dart';
import 'language_selection_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final PermissionService _permissionService = PermissionService();

  bool _locationGranted = false;
  bool _cameraGranted = false;
  bool _micGranted = false;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    _checkInitialStatuses();
  }

  Future<void> _checkInitialStatuses() async {
    final status = await _permissionService.checkPermissions();
    if (mounted) {
      setState(() {
        _locationGranted = status.locationGranted;
        _cameraGranted = status.cameraGranted;
        _micGranted = status.microphoneGranted;
      });
    }
  }

  Future<void> _requestLocation() async {
    final res = await _permissionService.requestLocation();
    if (mounted) {
      setState(() => _locationGranted = res);
    }
  }

  Future<void> _requestCamera() async {
    final res = await _permissionService.requestCamera();
    if (mounted) {
      setState(() => _cameraGranted = res);
    }
  }

  Future<void> _requestMic() async {
    final res = await _permissionService.requestMicrophone();
    if (mounted) {
      setState(() => _micGranted = res);
    }
  }

  Future<void> _requestAllAndProceed() async {
    setState(() => _isRequesting = true);
    final status = await _permissionService.requestAllPermissions();
    if (mounted) {
      setState(() {
        _locationGranted = status.locationGranted;
        _cameraGranted = status.cameraGranted;
        _micGranted = status.microphoneGranted;
        _isRequesting = false;
      });

      _proceedToLanguageSelection();
    }
  }

  void _proceedToLanguageSelection() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LanguageSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Required Permissions'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              Row(
                children: [
                  _buildStepDot(true, '1. Permissions'),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                  _buildStepDot(false, '2. Language'),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                  _buildStepDot(false, '3. Register'),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Help Travel Sarthi Guide You',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Before creating your account, please grant the following permissions so Travel Sarthi can deliver an immersive local experience.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    _buildPermissionCard(
                      icon: Icons.location_on_rounded,
                      color: const Color(0xFF00897B),
                      title: 'Location Permission',
                      subtitle:
                          'Detect nearby historical sites, local monuments, authentic regional food hubs, and navigation trails.',
                      isGranted: _locationGranted,
                      onTap: _requestLocation,
                    ),
                    const SizedBox(height: 14),
                    _buildPermissionCard(
                      icon: Icons.camera_alt_rounded,
                      color: const Color(0xFFE65100),
                      title: 'Camera Permission',
                      subtitle:
                          'Visual landmark scanning, instant plaque & sign translation into your language, and travel moments.',
                      isGranted: _cameraGranted,
                      onTap: _requestCamera,
                    ),
                    const SizedBox(height: 14),
                    _buildPermissionCard(
                      icon: Icons.mic_rounded,
                      color: const Color(0xFF5E35B1),
                      title: 'Microphone Permission',
                      subtitle:
                          'Hands-free voice assistant in your native regional language and interactive audio tour companion.',
                      isGranted: _micGranted,
                      onTap: _requestMic,
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_outlined,
                              color: Colors.blue, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your privacy is protected. Data is kept secure and never sold to third parties.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isRequesting ? null : _requestAllAndProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00897B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  child: _isRequesting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (_locationGranted && _cameraGranted && _micGranted)
                                  ? 'Continue to Language Selection'
                                  : 'Grant Permissions & Continue',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepDot(bool isActive, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF00897B) : Colors.grey.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isActive ? Icons.check : Icons.circle,
            size: 14,
            color: isActive ? Colors.white : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFF00897B) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGranted ? color.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.2),
          width: isGranted ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isGranted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Granted',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!isGranted)
                    InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tap to allow',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.touch_app_outlined,
                                size: 15, color: color),
                          ],
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
}

