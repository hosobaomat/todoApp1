import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp1/Theme/themecubit.dart';
import 'package:todoapp1/todo/bloc/bloc_Bloc.dart';
import 'package:todoapp1/todo/bloc/bloc_event.dart';
import 'package:todoapp1/todo/bloc/bloc_state.dart';
import 'package:todoapp1/todo/models/todo.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class TodoPage extends StatefulWidget {
  final String us;
  const TodoPage({super.key, required this.us});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  DateTime? selectedEndTime;
  TaskCategory _selectedCategory = TaskCategory.other;
  @override
  void initState() {
    super.initState();
    // load data user khi khoi tao man hinh
    context.read<BlocBloc>().add(LoadTodos(widget.us));
  }

  void pickEndTime(BuildContext context) {
    picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2100, 12, 31),
      onConfirm: (date) {
        setState(() {
          selectedEndTime = date;
        });
      },
      currentTime: DateTime.now(),
      locale: picker.LocaleType.vi, // Tiếng Việt (hoặc en)
    );
  }

  Icon _getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.study:
        return const Icon(Icons.school);
      case TaskCategory.work:
        return const Icon(Icons.work);
      case TaskCategory.family:
        return const Icon(Icons.home);
      case TaskCategory.health:
        return const Icon(Icons.fitness_center);
      case TaskCategory.shopping:
        return const Icon(Icons.shopping_cart);
      default:
        return const Icon(Icons.category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, themeMode) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            "Todo App",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton<FliterType>(
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: FliterType.byDate, child: Text('Lọc theo ngày')),
                const PopupMenuItem(
                    value: FliterType.byTitle, child: Text('Lọc theo chữ cái')),
                const PopupMenuItem(
                    value: FliterType.byCategory,
                    child: Text('Tất cả công việc')),
              ],
              icon: const Icon(Icons.filter_list, color: Color(0xFF22223B)),
              onSelected: (filter) {
                context
                    .read<BlocBloc>()
                    .add(FilterTodos(filterType: filter, username: widget.us));
              },
              color: Theme.of(context).cardColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                labelText: 'Thêm công việc mới',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.edit_note_rounded),
                              ),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            onPressed: () => pickEndTime(context),
                            icon: Icon(
                              Icons.access_time,
                              color: selectedEndTime != null
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            tooltip: selectedEndTime != null
                                ? '${selectedEndTime!.hour.toString().padLeft(2, '0')}:${selectedEndTime!.minute.toString().padLeft(2, '0')}'
                                : 'Chọn thời gian kết thúc',
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add,
                                  color: Theme.of(context).cardColor),
                              onPressed: () {
                                if (_controller.text.isNotEmpty &&
                                    selectedEndTime != null) {
                                  context.read<BlocBloc>().add(AddtoDo(
                                      _controller.text,
                                      _selectedCategory,
                                      selectedEndTime!,
                                      widget.us));
                                  _controller.clear();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text('Vui lòng nhập đầy đủ thông tin!'),
                                    duration: Duration(milliseconds: 1200),
                                  ));
                                }
                              },
                              tooltip: 'Thêm',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<TaskCategory>(
                              isExpanded: true,
                              value: _selectedCategory,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                              ),
                              items: TaskCategory.values
                                  .map((TaskCategory category) {
                                return DropdownMenuItem<TaskCategory>(
                                  value: category,
                                  child: Row(children: [
                                    _getCategoryIcon(category),
                                    const SizedBox(width: 6),
                                    Text(
                                      category.name,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ]),
                                );
                              }).toList(),
                              onChanged: (TaskCategory? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<BlocBloc, BlocState>(
                builder: (context, state) {
                  final grouped = <TaskCategory, List<Todo>>{};
                  for (var cat in TaskCategory.values) {
                    grouped[cat] = state.todos
                        .where((todo) => todo.category == cat)
                        .toList();
                  }
                  return ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    children: grouped.entries.map((entry) {
                      final category = entry.key;
                      final todos = entry.value;
                      if (todos.isEmpty) return const SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 16, bottom: 4),
                            child: Row(
                              children: [
                                _getCategoryIcon(category),
                                const SizedBox(width: 8),
                                Text(
                                  category.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF4A4E69),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...todos.map((todo) {
                            final remaining =
                                todo.endTime.difference(DateTime.now());
                            final isOverdue = remaining.isNegative;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 2),
                              decoration: BoxDecoration(
                                color: todo.isCompleted
                                    ? const Color(0xFFD3F9D8)
                                    : isOverdue
                                        ? const Color(0xFFFFE0E0)
                                        : Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: todo.isCompleted
                                      ? Colors.green.shade300
                                      : isOverdue
                                          ? Colors.red.shade200
                                          : Colors.transparent,
                                  width: 1.2,
                                ),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: todo.isCompleted,
                                  onChanged: (_) {
                                    context
                                        .read<BlocBloc>()
                                        .add(ToggletoDo(todo.id));
                                  },
                                  activeColor: Colors.green,
                                ),
                                title: Text(
                                  todo.title,
                                  style: TextStyle(
                                    decoration: todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: todo.isCompleted
                                        ? Colors.green.shade700
                                        : isOverdue
                                            ? Colors.red.shade700
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color:
                                          isOverdue ? Colors.red : Colors.blue,
                                    ),
                                    const SizedBox(width: 4),
                                    // Text(
                                    //   isOverdue ? 'Quá hạn: ' : 'Kết thúc: ',
                                    //   style: TextStyle(
                                    //     color:
                                    //         isOverdue ? Colors.red : Colors.blue,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                    Text(
                                      '${todo.endTime.year.toString().padLeft(2, '0')}-${todo.endTime.month.toString().padLeft(2, '0')}-${todo.endTime.day.toString().padLeft(2, '0')} ${todo.endTime.hour.toString().padLeft(2, '0')}:${todo.endTime.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        color: isOverdue
                                            ? Colors.red
                                            : const Color.fromRGBO(
                                                33, 150, 243, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            final editController =
                                                TextEditingController(
                                                    text: todo.title);
                                            TaskCategory editCategory =
                                                todo.category;
                                            DateTime editEndTime = todo.endTime;
                                            return StatefulBuilder(
                                              builder: (context, setState) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'Chỉnh sửa công việc'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          editController,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Tên công việc'),
                                                    ),
                                                    DropdownButtonFormField<
                                                        TaskCategory>(
                                                      value: editCategory,
                                                      items: TaskCategory.values
                                                          .map((cat) {
                                                        return DropdownMenuItem(
                                                          value: cat,
                                                          child: Text(cat.name),
                                                        );
                                                      }).toList(),
                                                      onChanged: (val) {
                                                        if (val != null) {
                                                          setState(() =>
                                                              editCategory =
                                                                  val);
                                                        }
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Danh mục'),
                                                    ),
                                                    TextButton.icon(
                                                      icon: const Icon(
                                                          Icons.access_time),
                                                      label: Text(
                                                        'Kết thúc: ${editEndTime.day.toString().padLeft(2, '0')}/'
                                                        '${editEndTime.month.toString().padLeft(2, '0')}/'
                                                        '${editEndTime.year} '
                                                        '${editEndTime.hour.toString().padLeft(2, '0')}:'
                                                        '${editEndTime.minute.toString().padLeft(2, '0')}',
                                                      ),
                                                      onPressed: () async {
                                                        final picked =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime: TimeOfDay
                                                              .fromDateTime(
                                                                  editEndTime),
                                                        );
                                                        if (picked != null) {
                                                          setState(() {
                                                            editEndTime =
                                                                DateTime(
                                                              editEndTime.year,
                                                              editEndTime.month,
                                                              editEndTime.day,
                                                              picked.hour,
                                                              picked.minute,
                                                            );
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Hủy'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      context
                                                          .read<BlocBloc>()
                                                          .add(
                                                            EdittoDo(
                                                              todo.id,
                                                              editController
                                                                  .text,
                                                              editCategory,
                                                              editEndTime,
                                                              widget.us,
                                                            ),
                                                          );
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text('Xác nhận'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.edit,
                                          color: Colors.orange),
                                      tooltip: 'Sửa',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      tooltip: 'Xóa',
                                      onPressed: () {
                                        context
                                            .read<BlocBloc>()
                                            .add(DeletetoDo(todo.id));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
