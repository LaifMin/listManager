import 'package:flutter/material.dart';
import '../models/task_list.dart';
import '../models/task_item.dart';
import '../widgets/dialogs.dart';

const Color kAqua = Color(0xFF00BCD4);

class ListCard extends StatefulWidget {
  final TaskList taskList;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onTaskToggled;
  final Function(TaskItem) onTaskAdded;
  final VoidCallback onDelete;

  const ListCard({
    super.key,
    required this.taskList,
    required this.isSelected,
    required this.onTap,
    required this.onTaskToggled,
    required this.onTaskAdded,
    required this.onDelete,
  });

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(ListCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _priorityColor {
    switch (widget.taskList.priority) {
      case Priority.a:
        return const Color(0xFFdc3545);
      case Priority.b:
        return const Color(0xFFffc107);
      case Priority.c:
        return const Color(0xFF28a745);
    }
  }

  String get _priorityEmoji {
    switch (widget.taskList.priority) {
      case Priority.a:
        return '🔴';
      case Priority.b:
        return '🟡';
      case Priority.c:
        return '🟢';
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.taskList;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? kAqua.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: _priorityColor, width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: widget.onTap,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // List icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          _priorityColor.withValues(alpha: 0.8),
                          _priorityColor,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        list.name.isNotEmpty
                            ? list.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                list.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2c3e50),
                                ),
                              ),
                            ),
                            AnimatedRotation(
                              turns: widget.isSelected ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: const Icon(Icons.expand_more,
                                  color: Color(0xFF6c757d)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: _priorityColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$_priorityEmoji Priorità ${list.priorityLabel}',
                                style: TextStyle(
                                  color: list.priority == Priority.b
                                      ? Colors.black87
                                      : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '📅 ${list.date}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6c757d),
                              ),
                            ),
                            if (list.deadline != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFdc3545).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '⏰ ${list.deadline}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFFdc3545),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Stats column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            list.isActive ? 'Active' : 'Done',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: list.isActive
                                  ? const Color(0xFF28a745)
                                  : const Color(0xFF6c757d),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: list.isActive
                                  ? const Color(0xFF28a745)
                                  : const Color(0xFFdc3545),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tasks: ${list.completedCount}/${list.totalCount}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6c757d),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Expandable tasks
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                const Divider(height: 1),
                ...list.tasks.map((task) => _buildTaskItem(task)),
                // Add task button
                InkWell(
                  onTap: () async {
                    final newTask = await showDialog<TaskItem>(
                      context: context,
                      builder: (_) => const AddTaskDialog(),
                    );
                    if (newTask != null) {
                      widget.onTaskAdded(newTask);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kAqua,
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          child: const Icon(Icons.add,
                              size: 16, color: Color(0xFF667eea)),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Aggiungi task...',
                          style: TextStyle(
                            color: kAqua,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Delete list button
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete_outline,
                          size: 18, color: Color(0xFFdc3545)),
                      label: const Text('Elimina lista',
                          style: TextStyle(
                              color: Color(0xFFdc3545), fontSize: 12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TaskItem task) {
    return InkWell(
      onTap: () {
        setState(() {
          task.isCompleted = !task.isCompleted;
        });
        widget.onTaskToggled();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    task.isCompleted ? const Color(0xFF28a745) : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted
                      ? const Color(0xFF28a745)
                      : const Color(0xFF6c757d),
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            // Task name
            Expanded(
              child: Text(
                task.name,
                style: TextStyle(
                  fontSize: 15,
                  color: task.isCompleted
                      ? const Color(0xFF6c757d)
                      : const Color(0xFF2c3e50),
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
