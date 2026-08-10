import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/sighting_provider.dart';
import 'screens/home_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/report_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const WebWatchApp());
}

class WebWatchApp extends StatelessWidget {
  const WebWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SightingProvider(),
      child: MaterialApp(
        title: 'WebWatch',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const RootNav(),
      ),
    );
  }
}

class RootNav extends StatefulWidget {
  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> {
  int _index = 0;

  void _goTo(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onReport: () => _goTo(2), onSeeFeed: () => _goTo(1)),
      const FeedScreen(),
      ReportScreen(onSubmitted: () => _goTo(1)),
      const MapScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _goTo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dynamic_feed), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.badge), label: 'Profile'),
        ],
      ),
    );
  }
}
