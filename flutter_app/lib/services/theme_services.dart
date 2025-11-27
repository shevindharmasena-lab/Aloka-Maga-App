import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ThemeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>?> getActivePreset() async {
    final daily = await _db.collection('app_theme').doc('daily_background').get();
    if (!daily.exists) return null;
    final presetId = daily.data()?['presetId'] as String?;
    if (presetId == null) return null;
    final presetSnap = await _db.collection('background_presets').doc(presetId).get();
    if (!presetSnap.exists) return null;
    final preset = Map<String, dynamic>.from(presetSnap.data()!);
    final asset = preset['asset'] as String? ?? '';
    if (asset.startsWith('app_assets/') || asset.startsWith('app_assets/lottie/')) {
      try {
        final ref = _storage.ref().child(asset);
        preset['assetUrl'] = await ref.getDownloadURL();
      } catch (e) {
        preset['assetUrl'] = null;
      }
    } else if (asset.startsWith('http')) {
      preset['assetUrl'] = asset;
    } else {
      preset['assetUrl'] = asset; // local asset path, e.g. assets/lottie/...
    }
    final overrides = daily.data()?['overrides'] as Map<String, dynamic>?;
    if (overrides != null) preset.addAll(overrides);
    return preset;
  }
}
