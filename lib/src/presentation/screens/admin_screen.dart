import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/report_providers.dart';
import '../../domain/models/user_model.dart';
import 'economy_screen.dart';
import 'test_report_screen.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('УПРАВЛЕНИЕ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Экономика',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EconomyScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            tooltip: 'Тестовый отчет',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TestReportScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(allUsersProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddUserDialog(context, ref),
        label: const Text('ДОБАВИТЬ'),
        icon: const Icon(Icons.person_add_rounded),
      ),
      body: usersAsync.when(
        data: (users) => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: users.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final user = users[index];
            return _UserCard(user: user);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final contractorController = TextEditingController();
    String selectedStatus = 'authorized';
    String selectedRole = 'user';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('НОВЫЙ ПОЛЬЗОВАТЕЛЬ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'Telegram ID'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Имя'),
                ),
                TextField(
                  controller: contractorController,
                  decoration: const InputDecoration(labelText: 'Подрядчик'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  items: const [
                    DropdownMenuItem(
                      value: 'authorized',
                      child: Text('Активен'),
                    ),
                    DropdownMenuItem(
                      value: 'blocked',
                      child: Text('Заблокирован'),
                    ),
                  ],
                  onChanged: (v) => setState(() => selectedStatus = v!),
                  decoration: const InputDecoration(labelText: 'Статус'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  items: const [
                    DropdownMenuItem(
                      value: 'user',
                      child: Text('Пользователь'),
                    ),
                    DropdownMenuItem(value: 'admin', child: Text('Админ')),
                  ],
                  onChanged: (v) => setState(() => selectedRole = v!),
                  decoration: const InputDecoration(labelText: 'Роль'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ОТМЕНА'),
            ),
            ElevatedButton(
              onPressed: () async {
                final adminId = ref.read(userIdProvider);
                await ref
                    .read(reportRepositoryProvider)
                    .addUser(
                      adminId: adminId,
                      user: UserModel(
                        id: idController.text,
                        name: nameController.text,
                        contractor: contractorController.text,
                        status: selectedStatus,
                        role: selectedRole,
                      ),
                    );
                ref.invalidate(allUsersProvider);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('ДОБАВИТЬ'),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends ConsumerWidget {
  final UserModel user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive =
        user.status.toLowerCase() == 'active' ||
        user.status.toLowerCase() == 'authorized' ||
        user.status == 'true';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: isActive
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                child: Icon(
                  isActive ? Icons.person_rounded : Icons.person_off_rounded,
                  color: isActive ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'ID: ${user.id}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _RoleBadge(role: user.role),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              _InfoChip(label: 'Подрядчик', value: user.contractor),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit_rounded, size: 20),
                onPressed: () => _showEditDialog(context, ref),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: Colors.red,
                ),
                onPressed: () => _showDeleteConfirm(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: user.name);
    final contractorController = TextEditingController(text: user.contractor);
    String selectedStatus = user.status;
    String selectedRole = user.role;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('РЕДАКТИРОВАНИЕ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Имя'),
                ),
                TextField(
                  controller: contractorController,
                  decoration: const InputDecoration(labelText: 'Подрядчик'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  items: const [
                    DropdownMenuItem(
                      value: 'authorized',
                      child: Text('Активен'),
                    ),
                    DropdownMenuItem(
                      value: 'blocked',
                      child: Text('Заблокирован'),
                    ),
                  ],
                  onChanged: (v) => setState(() => selectedStatus = v!),
                  decoration: const InputDecoration(labelText: 'Статус'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  items: const [
                    DropdownMenuItem(
                      value: 'user',
                      child: Text('Пользователь'),
                    ),
                    DropdownMenuItem(value: 'admin', child: Text('Админ')),
                  ],
                  onChanged: (v) => setState(() => selectedRole = v!),
                  decoration: const InputDecoration(labelText: 'Роль'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ОТМЕНА'),
            ),
            ElevatedButton(
              onPressed: () async {
                final adminId = ref.read(userIdProvider);
                await ref
                    .read(reportRepositoryProvider)
                    .updateUser(
                      adminId: adminId,
                      targetUserId: user.id,
                      data: {
                        'name': nameController.text,
                        'contractor': contractorController.text,
                        'status': selectedStatus,
                        'role': selectedRole,
                      },
                    );
                ref.invalidate(allUsersProvider);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('СОХРАНИТЬ'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('УДАЛЕНИЕ'),
        content: Text(
          'Вы уверены, что хотите удалить пользователя ${user.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОТМЕНА'),
          ),
          TextButton(
            onPressed: () async {
              final adminId = ref.read(userIdProvider);
              await ref
                  .read(reportRepositoryProvider)
                  .deleteUser(adminId: adminId, targetUserId: user.id);
              ref.invalidate(allUsersProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('УДАЛИТЬ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final isAdmin = role.toLowerCase() == 'admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAdmin
            ? Colors.purple.withValues(alpha: 0.1)
            : Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: isAdmin ? Colors.purple : Colors.blue,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
      ],
    );
  }
}
