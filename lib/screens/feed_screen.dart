import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sighting.dart';
import '../providers/sighting_provider.dart';
import '../widgets/sighting_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ThreatLevel? _filter;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SightingProvider>();
    final sightings = provider.sightings
        .where((s) => _filter == null || s.threatLevel == _filter)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('SIGHTING FEED')),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _FilterChip(label: 'All', selected: _filter == null, onTap: () => setState(() => _filter = null)),
                for (final level in ThreatLevel.values)
                  _FilterChip(
                    label: level.label,
                    selected: _filter == level,
                    onTap: () => setState(() => _filter = level),
                  ),
              ],
            ),
          ),
          Expanded(
            child: sightings.isEmpty
                ? const Center(child: Text('No sightings match this filter yet.'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: sightings.length,
                    itemBuilder: (context, index) {
                      final s = sightings[index];
                      return SightingCard(
                        sighting: s,
                        onVerify: () => provider.verify(s.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
