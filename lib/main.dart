import 'package:flutter/material.dart';

void main() {
  runApp(const ZakkerlyApp());
}

class ZakkerlyApp extends StatelessWidget {
  const ZakkerlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ذاكرلي',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: const HomePage(),
    );
  }
}

class StudyTask {
  String title;
  bool done;

  StudyTask(this.title, {this.done = false});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<StudyTask> tasks = [];
  final TextEditingController controller = TextEditingController();

  void addTask() {
    final title = controller.text.trim();

    if (title.isEmpty) return;

    setState(() {
      tasks.add(StudyTask(title));
      controller.clear();
    });

    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((task) => task.done).length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ذاكرلي 📚',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'أهلاً بيك! 👋',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('نظّم يومك وخلّص مهامك خطوة بخطوة.'),
                      const SizedBox(height: 16),
                      Text(
                        'أنجزت $completed من ${tasks.length} مهام',
                        style: const TextStyle(
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: tasks.isEmpty
                            ? 0
                            : completed / tasks.length,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'مهام المذاكرة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => addTask(),
                      decoration: const InputDecoration(
                        hintText: 'مثلاً: مذاكرة مادة البرمجة',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: addTask,
                    icon: const Icon(Icons.add),
                    tooltip: 'إضافة مهمة',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'لسه مفيش مهام.. ابدأ بأول مهمة! ✨',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return Card(
                            child: CheckboxListTile(
                              value: task.done,
                              controlAffinity:
                                  ListTileControlAffinity.leading,
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.done
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  task.done = value ?? false;
                                });
                              },
                              secondary: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  setState(() {
                                    tasks.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}