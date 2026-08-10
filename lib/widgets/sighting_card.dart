import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sighting.dart';
import '../utils/theme.dart';

class SightingCard extends StatelessWidget {
  final Sighting sighting;
  final VoidCallback onVerify;

  const SightingCard({super.key, required this.sighting, required this.onVerify});

  Color get _levelColor {
    switch (sighting.threatLevel) {
      case ThreatLevel.calm:
        return Colors.green;
      case ThreatLevel.curious:
        return Colors.teal;
      case ThreatLevel.notable:
        return AppColors.alertAmber;
      case ThreatLevel.high:
        return AppColors.heroRed;
      case ThreatLevel.cityWide:
        return AppColors.inkNavy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeAgo = _timeAgo(sighting.timestamp);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _levelColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    sighting.threatLevel.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(timeAgo, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              sighting.title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 2),
                Text(sighting.neighborhood,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(sighting.description, style: const TextStyle(fontSize: 13.5, height: 1.35)),
            if (sighting.tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: sighting.tags
                    .map((t) => Chip(
                          label: Text('${t.emoji} ${t.label}', style: const TextStyle(fontSize: 11)),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: AppColors.paper,
                          side: BorderSide(color: Colors.grey.shade300),
                        ))
                    .toList(),
              ),
            ],
            const Divider(height: 20),
            Row(
              children: [
                Text('by ${sighting.reporterName}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontStyle: FontStyle.italic)),
                const Spacer(),
                Icon(Icons.verified, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 4),
                Text('${sighting.verifiedCount} confirmed', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: onVerify,
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 14),
                  label: const Text('I saw it too', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(time);
  }
}
