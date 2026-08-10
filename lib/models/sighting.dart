import 'dart:io';

enum ThreatLevel { calm, curious, notable, high, cityWide }

extension ThreatLevelX on ThreatLevel {
  String get label {
    switch (this) {
      case ThreatLevel.calm:
        return 'Just Swinging By';
      case ThreatLevel.curious:
        return 'Worth a Look';
      case ThreatLevel.notable:
        return 'Notable Activity';
      case ThreatLevel.high:
        return 'High Alert';
      case ThreatLevel.cityWide:
        return 'City-Wide Incident';
    }
  }

  int get score {
    switch (this) {
      case ThreatLevel.calm:
        return 1;
      case ThreatLevel.curious:
        return 2;
      case ThreatLevel.notable:
        return 3;
      case ThreatLevel.high:
        return 4;
      case ThreatLevel.cityWide:
        return 5;
    }
  }
}

/// A tag describing what kind of hero activity a witness observed.
enum PowerTag {
  webSlinging,
  wallCrawling,
  acrobatics,
  webDome,
  rescue,
  standoff,
  quip,
  vanished,
}

extension PowerTagX on PowerTag {
  String get label {
    switch (this) {
      case PowerTag.webSlinging:
        return 'Web-Slinging';
      case PowerTag.wallCrawling:
        return 'Wall-Crawling';
      case PowerTag.acrobatics:
        return 'Acrobatics';
      case PowerTag.webDome:
        return 'Web Dome';
      case PowerTag.rescue:
        return 'Rescue';
      case PowerTag.standoff:
        return 'Standoff';
      case PowerTag.quip:
        return 'One-Liners';
      case PowerTag.vanished:
        return 'Vanished Fast';
    }
  }

  String get emoji {
    switch (this) {
      case PowerTag.webSlinging:
        return '🕸️';
      case PowerTag.wallCrawling:
        return '🧗';
      case PowerTag.acrobatics:
        return '🤸';
      case PowerTag.webDome:
        return '🛡️';
      case PowerTag.rescue:
        return '🆘';
      case PowerTag.standoff:
        return '⚔️';
      case PowerTag.quip:
        return '💬';
      case PowerTag.vanished:
        return '💨';
    }
  }
}

class Sighting {
  final String id;
  final String title;
  final String description;
  final String neighborhood;
  final double latitude;
  final double longitude;
  final ThreatLevel threatLevel;
  final List<PowerTag> tags;
  final DateTime timestamp;
  final File? photo;
  int verifiedCount;
  final String reporterName;

  Sighting({
    required this.id,
    required this.title,
    required this.description,
    required this.neighborhood,
    required this.latitude,
    required this.longitude,
    required this.threatLevel,
    required this.tags,
    required this.timestamp,
    required this.reporterName,
    this.photo,
    this.verifiedCount = 0,
  });
}
