import 'package:flutter/material.dart';
import '../models/safe_models.dart';
import '../data/sample_safes.dart';
import '../services/storage_service.dart';
import 'game_screen.dart';

class SafeSelectionScreen extends StatefulWidget {
  const SafeSelectionScreen({super.key});

  @override
  State<SafeSelectionScreen> createState() => _SafeSelectionScreenState();
}

class _SafeSelectionScreenState extends State<SafeSelectionScreen> {
  List<Safe> _freeSafes = [];
  List<Safe> _premiumSafes = [];
  int _selectedTab = 0;
  bool _isLoading = true;
  bool _isPremiumUnlocked = false;
  late StorageService _storage;

  @override
  void initState() {
    super.initState();
    _storage = StorageService();
    _loadSafes();
  }

  Future<void> _loadSafes() async {
    final unlockedIds = await _storage.getUnlockedSafeIds();
    final isPremium = await _storage.isPremiumUnlocked();
    
    _freeSafes = SampleSafes.getFreeSafes().map((safe) {
      return safe.copyWith(isUnlocked: unlockedIds.contains(safe.id));
    }).toList();
    
    _premiumSafes = SampleSafes.getPremiumSafes().map((safe) {
      return safe.copyWith(isUnlocked: isPremium);
    }).toList();
    
    if (_freeSafes.isNotEmpty && !unlockedIds.contains(_freeSafes[0].id)) {
      _freeSafes[0] = _freeSafes[0].copyWith(isUnlocked: true);
      await _storage.unlockSafe(_freeSafes[0].id);
    }
    
    setState(() {
      _isPremiumUnlocked = isPremium;
      _isLoading = false;
    });
  }

  Future<void> _onSafeCompleted(Safe safe) async {
    if (safe.category == SafeCategory.free) {
      final index = _freeSafes.indexWhere((s) => s.id == safe.id);
      if (index >= 0 && index + 1 < _freeSafes.length) {
        final nextSafe = _freeSafes[index + 1];
        await _storage.unlockSafe(nextSafe.id);
        setState(() {
          _freeSafes[index + 1] = nextSafe.copyWith(isUnlocked: true);
        });
      }
    }
  }

  void _openSafe(Safe safe) {
    if (!safe.isUnlocked) {
      String message = 'Complete the previous safe to unlock this one!';
      if (safe.category == SafeCategory.premium && !_isPremiumUnlocked) {
        message = 'Premium safes require a premium subscription.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameScreen(
          safe: safe,
          onComplete: () => _onSafeCompleted(safe),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'SAFECRACK',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _selectedTab == 0
                ? _buildSafeGrid(_freeSafes)
                : _buildSafeGrid(_premiumSafes),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton('FREE', 0),
          ),
          Expanded(
            child: _buildTabButton('PREMIUM', 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSafeGrid(List<Safe> safes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: safes.length,
      itemBuilder: (context, index) => _buildSafeCard(safes[index]),
    );
  }

  Widget _buildSafeCard(Safe safe) {
    final isLocked = !safe.isUnlocked;
    
    return GestureDetector(
      onTap: () => _openSafe(safe),
      child: Container(
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey[850] : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLocked ? Colors.grey[700]! : Colors.deepPurple,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLocked ? Icons.lock : Icons.lock_open,
              size: 32,
              color: isLocked ? Colors.grey : Colors.deepPurple,
            ),
            const SizedBox(height: 8),
            Text(
              '#${safe.order}',
              style: TextStyle(
                color: isLocked ? Colors.grey : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'PAR ${safe.par}',
              style: TextStyle(
                color: isLocked ? Colors.grey[600] : Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
