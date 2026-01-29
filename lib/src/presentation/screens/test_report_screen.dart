import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/report_providers.dart';

class TestReportScreen extends ConsumerStatefulWidget {
  const TestReportScreen({super.key});

  @override
  ConsumerState<TestReportScreen> createState() => _TestReportScreenState();
}

class _TestReportScreenState extends ConsumerState<TestReportScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _send() async {
    if (_controller.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(reportRepositoryProvider);
      final userId = ref.read(userIdProvider);
      
      await repository.sendTestReport(
        content: _controller.text,
        userId: userId,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Тестовый отчет отправлен в Supabase!')),
        );
        _controller.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ТЕСТОВЫЙ ОТЧЕТ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Данные из этой формы уйдут напрямую в новую таблицу test_reports в Supabase.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Текст отчета',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _send,
                child: const Text('ОТПРАВИТЬ В SUPABASE'),
              ),
          ],
        ),
      ),
    );
  }
}
