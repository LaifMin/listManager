import 'package:flutter/material.dart';
import '../models/task_list.dart';
import '../models/task_item.dart';

const Color kAqua = Color(0xFF00BCD4);
const Color kAquaDark = Color(0xFF0097A7);

class AddListDialog extends StatefulWidget {
  const AddListDialog({super.key});

  @override
  State<AddListDialog> createState() => _AddListDialogState();
}

class _AddListDialogState extends State<AddListDialog> {
  final _nameController = TextEditingController();
  Priority _priority = Priority.a;
  DateTime? _deadline;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: kAqua,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.playlist_add, color: kAqua),
          SizedBox(width: 10),
          Text('Nuova Lista'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nome della lista',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.edit),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Priority>(
            initialValue: _priority,
            decoration: InputDecoration(
              labelText: 'Priorità',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.flag),
            ),
            items: const [
              DropdownMenuItem(
                  value: Priority.a,
                  child: Text('🔴 Priorità A - Alta')),
              DropdownMenuItem(
                  value: Priority.b,
                  child: Text('🟡 Priorità B - Media')),
              DropdownMenuItem(
                  value: Priority.c,
                  child: Text('🟢 Priorità C - Bassa')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _priority = v);
            },
          ),
          const SizedBox(height: 16),
          // Deadline picker
          InkWell(
            onTap: _pickDeadline,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Scadenza',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.event),
                suffixIcon: _deadline != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _deadline = null),
                      )
                    : null,
              ),
              child: Text(
                _deadline != null
                    ? '${_deadline!.day.toString().padLeft(2, '0')}/${_deadline!.month.toString().padLeft(2, '0')}/${_deadline!.year}'
                    : 'Nessuna scadenza',
                style: TextStyle(
                  color: _deadline != null
                      ? const Color(0xFF2c3e50)
                      : const Color(0xFF6c757d),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAqua,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            if (_nameController.text.trim().isEmpty) return;
            final now = DateTime.now();
            final dateStr =
                '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}';
            String? deadlineStr;
            if (_deadline != null) {
              deadlineStr =
                  '${_deadline!.day.toString().padLeft(2, '0')}/${_deadline!.month.toString().padLeft(2, '0')}/${_deadline!.year}';
            }
            final newList = TaskList(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameController.text.trim(),
              priority: _priority,
              date: dateStr,
              deadline: deadlineStr,
            );
            Navigator.pop(context, newList);
          },
          child: const Text('Crea'),
        ),
      ],
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.add_task, color: kAqua),
          SizedBox(width: 10),
          Text('Nuovo Task'),
        ],
      ),
      content: TextField(
        controller: _nameController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Nome del task',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: const Icon(Icons.task_alt),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAqua,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _submit,
          child: const Text('Aggiungi'),
        ),
      ],
    );
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) return;
    final task = TaskItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
    );
    Navigator.pop(context, task);
  }
}
