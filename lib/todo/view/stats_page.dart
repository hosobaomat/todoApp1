import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp1/todo/bloc/bloc_Bloc.dart';
import 'package:todoapp1/todo/bloc/bloc_state.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DateTime selectedDate = DateTime.now(); //chon ngay hien tai
  // Thêm enum để quản lý loại bộ lọc
  FilterType selectedFilter = FilterType.day;
  void _selectedDate() async {
    final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocBloc, BlocState>(
      builder: (context, state) {
        final filterTodos = state.todos.where((todo) {
          final time = todo.endTime;
          switch (selectedFilter) {
            case FilterType.day:
              return time.year == selectedDate.year &&
                  time.month == selectedDate.month &&
                  time.day == selectedDate.day;
            case FilterType.year:
              return time.year == selectedDate.year;
          }
        }).toList();
        final total = filterTodos.length;
        final completed = filterTodos.where((todo) => todo.isCompleted).length;
        final incompleted = total - completed;
        final completionPercent = total == 0 ? 0 : completed / total;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '📊 Thống kê công việc',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          _selectedDate();
                          setState(() {
                            selectedFilter = FilterType.day;
                          });
                        },
                        icon: const Icon(Icons.today),
                        label: const Text('Ngày'),
                        style: TextButton.styleFrom(
                          foregroundColor: selectedFilter == FilterType.day
                              ? Colors.deepPurple
                              : Colors.grey[700],
                        )),
                    TextButton.icon(
                        onPressed: () {
                          _selectedDate();
                          setState(() {
                            selectedFilter = FilterType.year;
                          });
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Năm'),
                        style: TextButton.styleFrom(
                          foregroundColor: selectedFilter == FilterType.year
                              ? Colors.deepPurple
                              : Colors.grey[700],
                        )),
                  ],
                ),
                _buildProgressCard(completionPercent.toDouble()),
                const SizedBox(height: 24),
                _buildStatCard('📝 Tổng công việc', total, Colors.blue),
                _buildStatCard('✅ Đã hoàn thành', completed, Colors.green),
                _buildStatCard(
                    '❌ Chưa hoàn thành', incompleted, Colors.redAccent),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressCard(double percent) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tiến độ hoàn thành',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: percent,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Text('${(percent * 100).toStringAsFixed(1)} % hoàn thành'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int value, Color color) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Text(
            label[0],
            style: TextStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          value.toString(),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}

enum FilterType { day, year }
