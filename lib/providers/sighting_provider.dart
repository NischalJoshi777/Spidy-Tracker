import 'dart:math';
import 'package:flutter/material.dart';
import '../models/sighting.dart';

class SightingProvider extends ChangeNotifier {
  final List<Sighting> _sightings = [];
  int _reporterPoints = 40;
  String _reporterName = 'You';
  final _rand = Random();

  SightingProvider() {
    _seedDemoData();
  }

  List<Sighting> get sightings =>
      List.unmodifiable(_sightings..sort((a, b) => b.timestamp.compareTo(a.timestamp)));

  int get reporterPoints => _reporterPoints;
  String get reporterName => _reporterName;

  set reporterName(String name) {
    _reporterName = name.trim().isEmpty ? 'You' : name.trim();
    notifyListeners();
  }

  String get reporterRank {
    if (_reporterPoints >= 500) return 'Pulitzer Prospect';
    if (_reporterPoints >= 250) return 'Ace Reporter';
    if (_reporterPoints >= 100) return 'Staff Reporter';
    return 'Rookie Stringer';
  }

  double get rankProgress {
    const thresholds = [0, 100, 250, 500, 800];
    for (int i = 0; i < thresholds.length - 1; i++) {
      if (_reporterPoints < thresholds[i + 1]) {
        final span = thresholds[i + 1] - thresholds[i];
        return (_reporterPoints - thresholds[i]) / span;
      }
    }
    return 1.0;
  }

  /// A rolling "how active is the wall-crawler tonight" gauge, 0..100.
  int get spideySenseLevel {
    if (_sightings.isEmpty) return 12;
    final recent = _sightings.where(
      (s) => DateTime.now().difference(s.timestamp).inHours < 12,
    );
    final base = recent.fold<int>(0, (sum, s) => sum + s.threatLevel.score);
    return min(100, 15 + base * 7);
  }

  Sighting? get topAlert {
    final active = _sightings.where(
      (s) => s.threatLevel == ThreatLevel.high || s.threatLevel == ThreatLevel.cityWide,
    );
    if (active.isEmpty) return null;
    return active.reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b);
  }

  void addSighting({
    required String title,
    required String description,
    required String neighborhood,
    required ThreatLevel threatLevel,
    required List<PowerTag> tags,
    dynamic photo,
    double? latitude,
    double? longitude,
  }) {
    final sighting = Sighting(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      neighborhood: neighborhood,
      latitude: latitude ?? (40.7128 + (_rand.nextDouble() - 0.5) * 0.02),
      longitude: longitude ?? (-74.0060 + (_rand.nextDouble() - 0.5) * 0.02),
      threatLevel: threatLevel,
      tags: tags,
      timestamp: DateTime.now(),
      reporterName: _reporterName,
      photo: photo,
    );
    _sightings.add(sighting);
    _reporterPoints += 10 + threatLevel.score * 4;
    notifyListeners();
  }

  void verify(String id) {
    final s = _sightings.firstWhere((s) => s.id == id);
    s.verifiedCount += 1;
    _reporterPoints += 2;
    notifyListeners();
  }

  void _seedDemoData() {
    _sightings.addAll([
      Sighting(
        id: '1',
        title: 'Red-and-blue blur over 5th & Main',
        description:
            'Saw someone swing between the Meridian Tower and the old clock building. Left a web line stuck to a lamppost for a few minutes before it dissolved.',
        neighborhood: 'Meridian District',
        latitude: 40.7145,
        longitude: -74.0059,
        threatLevel: ThreatLevel.curious,
        tags: [PowerTag.webSlinging, PowerTag.acrobatics],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        reporterName: 'J. Aranda',
        verifiedCount: 14,
      ),
      Sighting(
        id: '2',
        title: 'Standoff on the parking deck roof',
        description:
            'A masked figure was cornered by someone in full body armor. Heard metal clanging, then a big web dome went up. Both gone by the time police arrived.',
        neighborhood: 'Riverside',
        latitude: 40.7112,
        longitude: -74.0093,
        threatLevel: ThreatLevel.high,
        tags: [PowerTag.standoff, PowerTag.webDome],
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        reporterName: 'Anon Cabbie',
        verifiedCount: 31,
      ),
      Sighting(
        id: '3',
        title: 'Kid\'s balloon rescued off a billboard',
        description:
            'Small assist, nothing dramatic — but he apparently made a pretty bad joke while doing it and the crowd groaned.',
        neighborhood: 'Old Market Square',
        latitude: 40.7138,
        longitude: -74.0024,
        threatLevel: ThreatLevel.calm,
        tags: [PowerTag.rescue, PowerTag.quip],
        timestamp: DateTime.now().subtract(const Duration(hours: 9)),
        reporterName: 'M. Okafor',
        verifiedCount: 8,
      ),
    ]);
  }
}
