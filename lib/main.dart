import 'package:flutter/material.dart';
import 'models/task_list.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/stats_screen.dart';

void main() {
  runApp(const ListManagerApp());
}

class ListManagerApp extends StatelessWidget {
  const ListManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BCD4),
          brightness: Brightness.light,
        ),
        fontFamily: 'Segoe UI',
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  List<TaskList> _lists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final lists = await StorageService.loadLists();
    setState(() {
      _lists = lists;
      _isLoading = false;
    });
  }

  void _onDataChanged() {
    StorageService.saveLists(_lists);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00BCD4),
          ),
        ),
      );
    }

    final screens = [
      HomeScreen(lists: _lists, onDataChanged: _onDataChanged),
      StatsScreen(lists: _lists),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF00BCD4).withValues(alpha: 0.15),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon:
                  Icon(Icons.list_alt, color: Color(0xFF00BCD4)),
              label: 'Liste',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon:
                  Icon(Icons.bar_chart, color: Color(0xFF00BCD4)),
              label: 'Stats',
            ),
          ],
        ),
      ),
    );
  }
}
