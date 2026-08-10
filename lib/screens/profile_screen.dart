import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sighting_provider.dart';
import '../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SightingProvider>();
    final controller = TextEditingController(text: provider.reporterName);

    return Scaffold(
      appBar: AppBar(title: const Text('YOUR PRESS PASS')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.heroBlue,
              child: Text(
                provider.reporterName.isNotEmpty
                    ? provider.reporterName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              provider.reporterRank,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          Center(
            child: Text(
              '${provider.reporterPoints} reporter points',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: provider.rankProgress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: AppColors.heroRed,
            ),
          ),
          const SizedBox(height: 30),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Spidy UserName',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (v) =>
                        context.read<SightingProvider>().reporterName = v,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          context.read<SightingProvider>().reporterName =
                              controller.text,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const _RankLadder(),
        ],
      ),
    );
  }
}

class _RankLadder extends StatelessWidget {
  const _RankLadder();

  @override
  Widget build(BuildContext context) {
    const ranks = [
      ('Rookie Stringer', 0),
      ('Staff Reporter', 100),
      ('Ace Reporter', 250),
      ('Pulitzer Prospect', 500),
    ];
    final points = context.watch<SightingProvider>().reporterPoints;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rank Ladder',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (final r in ranks)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      points >= r.$2
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: points >= r.$2 ? Colors.green : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(r.$1),
                    const Spacer(),
                    Text(
                      '${r.$2}+ pts',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
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
