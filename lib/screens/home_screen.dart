import 'package:flutter/material.dart';
import '../models/task_list.dart';
import '../widgets/list_card.dart';
import '../widgets/dialogs.dart';

const Color kAqua = Color(0xFF00BCD4);
const Color kAquaDark = Color(0xFF0097A7);
const Color kAquaLight = Color(0xFF4DD0E1);

class HomeScreen extends StatefulWidget {
  final List<TaskList> lists;
  final VoidCallback onDataChanged;

  const HomeScreen({
    super.key,
    required this.lists,
    required this.onDataChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedIndex;

  int get _totalTasks =>
      widget.lists.fold(0, (sum, l) => sum + l.totalCount);
  int get _completedTasks =>
      widget.lists.fold(0, (sum, l) => sum + l.completedCount);
  double get _globalPerformance =>
      _totalTasks == 0 ? 0.0 : (_completedTasks / _totalTasks) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: CustomScrollView(
        slivers: [
          // Aqua Gradient App Bar — no performance badge in header
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                  ),
                ),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Benvenuto 👋',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Gestisci le tue liste',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: kAqua,
          ),

          // Summary strip
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    kAquaLight.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: kAqua.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniStat(
                      Icons.list_alt, '${widget.lists.length}', 'Liste'),
                  _buildMiniStat(Icons.check_circle_outline,
                      '$_completedTasks', 'Completati'),
                  _buildMiniStat(Icons.pending_actions,
                      '${_totalTasks - _completedTasks}', 'Da fare'),
                  _buildMiniStat(Icons.speed,
                      '${_globalPerformance.toStringAsFixed(0)}%', 'Performance'),
                ],
              ),
            ),
          ),

          // Section title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(
                'Le tue liste (${widget.lists.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2c3e50),
                ),
              ),
            ),
          ),

          // Lists
          widget.lists.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'Nessuna lista ancora.\nTocca + per crearne una!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final list = widget.lists[index];
                      return ListCard(
                        taskList: list,
                        isSelected: _selectedIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedIndex =
                                _selectedIndex == index ? null : index;
                          });
                        },
                        onTaskToggled: () {
                          widget.onDataChanged();
                          setState(() {});
                        },
                        onTaskAdded: (task) {
                          list.tasks.add(task);
                          widget.onDataChanged();
                          setState(() {});
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              title: const Text('Elimina lista'),
                              content: Text(
                                  'Vuoi eliminare "${list.name}" e tutti i suoi task?'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Annulla')),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFFdc3545)),
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Elimina',
                                      style:
                                          TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            widget.lists.removeAt(index);
                            if (_selectedIndex == index) {
                              _selectedIndex = null;
                            }
                            widget.onDataChanged();
                            setState(() {});
                          }
                        },
                      );
                    },
                    childCount: widget.lists.length,
                  ),
                ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newList = await showDialog<TaskList>(
            context: context,
            builder: (_) => const AddListDialog(),
          );
          if (newList != null) {
            widget.lists.add(newList);
            widget.onDataChanged();
            setState(() {});
          }
        },
        backgroundColor: kAqua,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: kAqua, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF2c3e50),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6c757d)),
        ),
      ],
    );
  }
}
