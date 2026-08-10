import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sighting_provider.dart';
import '../utils/theme.dart';
import '../widgets/spidey_sense_meter.dart';
import '../widgets/web_background_painter.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onReport;
  final VoidCallback onSeeFeed;

  const HomeScreen({
    super.key,
    required this.onReport,
    required this.onSeeFeed,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SightingProvider>();
    final topAlert = provider.topAlert;

    return Scaffold(
      appBar: AppBar(title: const Text('SPIDY TRACKER')),
      body: WebCornerBackground(
        color: AppColors.heroBlue,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (topAlert != null)
                _AlertBanner(
                  title: topAlert.title,
                  area: topAlert.neighborhood,
                ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Tonight\'s City Buzz',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SpideySenseMeter(level: provider.spideySenseLevel),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'Sightings logged',
                      value: '${provider.sightings.length}',
                      icon: Icons.visibility,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      label: 'Your rank',
                      value: provider.reporterRank,
                      icon: Icons.badge,
                      small: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onReport,
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Report a Sighting',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onSeeFeed,
                icon: const Icon(Icons.dynamic_feed),
                label: const Text('Browse the Feed'),
              ),
              const SizedBox(height: 24),
              Text(
                'Every tip gets cross-checked by the community before it counts toward '
                'the city buzz meter. Keep it honest, keep it quick.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final String title;
  final String area;
  const _AlertBanner({required this.title, required this.area});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.heroRed,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.heroRed.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.campaign, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BREAKING',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'near $area',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool small;
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.heroBlue),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: small ? 15 : 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
