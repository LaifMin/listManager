import 'package:flutter/material.dart';
import '../models/task_list.dart';

const Color kAqua = Color(0xFF00BCD4);
const Color kAquaDark = Color(0xFF0097A7);
const Color kAquaLight = Color(0xFF4DD0E1);

class StatsScreen extends StatelessWidget {
  final List<TaskList> lists;

  const StatsScreen({super.key, required this.lists});

  int get _totalTasks => lists.fold(0, (sum, l) => sum + l.totalCount);
  int get _completedTasks =>
      lists.fold(0, (sum, l) => sum + l.completedCount);
  int get _pendingTasks => _totalTasks - _completedTasks;
  double get _globalPerformance =>
      _totalTasks == 0 ? 0.0 : (_completedTasks / _totalTasks) * 100;

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.a:
        return const Color(0xFFdc3545);
      case Priority.b:
        return const Color(0xFFffc107);
      case Priority.c:
        return const Color(0xFF28a745);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: CustomScrollView(
        slivers: [
          // Aqua Gradient App Bar
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
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Statistiche 📊',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Performance: ${_globalPerformance.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: kAqua,
          ),

          // General stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statistiche Generali',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2c3e50),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Big cards row
                  Row(
                    children: [
                      Expanded(
                        child: _buildBigStatCard(
                          icon: Icons.list_alt,
                          label: 'Liste Totali',
                          value: '${lists.length}',
                          color: kAqua,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBigStatCard(
                          icon: Icons.task_alt,
                          label: 'Task Inseriti',
                          value: '$_totalTasks',
                          color: kAquaDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBigStatCard(
                          icon: Icons.check_circle,
                          label: 'Completati',
                          value: '$_completedTasks',
                          color: const Color(0xFF28a745),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBigStatCard(
                          icon: Icons.pending_actions,
                          label: 'Da Svolgere',
                          value: '$_pendingTasks',
                          color: const Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Performance card
                  _buildPerformanceCard(),
                ],
              ),
            ),
          ),

          // Per-list stats title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: const Text(
                'Statistiche per Lista',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2c3e50),
                ),
              ),
            ),
          ),

          // Per-list stats
          lists.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'Nessuna lista creata.',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 16),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final list = lists[index];
                      return _buildListStatCard(list);
                    },
                    childCount: lists.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildBigStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6c757d),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kAqua.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Performance Globale',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_globalPerformance.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_completedTasks completati su $_totalTasks totali',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Circular progress
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: _globalPerformance / 100,
                    strokeWidth: 6,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const Icon(Icons.speed, color: Colors.white, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListStatCard(TaskList list) {
    final perf = list.efficiency;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: _priorityColor(list.priority), width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _priorityColor(list.priority).withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Text(
                    list.priorityLabel,
                    style: TextStyle(
                      color: _priorityColor(list.priority),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2c3e50),
                      ),
                    ),
                    if (list.deadline != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '⏰ Scadenza: ${list.deadline}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFdc3545),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                '📅 ${list.date}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6c757d),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Stats row
          Row(
            children: [
              _buildMiniChip(Icons.check_circle, '${list.completedCount}',
                  'Svolti', const Color(0xFF28a745)),
              const SizedBox(width: 10),
              _buildMiniChip(
                  Icons.radio_button_unchecked,
                  '${list.totalCount - list.completedCount}',
                  'Da fare',
                  const Color(0xFFFF9800)),
              const SizedBox(width: 10),
              _buildMiniChip(Icons.format_list_numbered,
                  '${list.totalCount}', 'Totali', kAqua),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: list.totalCount == 0 ? 0 : perf / 100,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFe9ecef),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _priorityColor(list.priority)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${perf.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF2c3e50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChip(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Color(0xFF6c757d)),
            ),
          ],
        ),
      ),
    );
  }
}
