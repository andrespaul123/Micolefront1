import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/subject_repository.dart'; // ✅ CORREGIDO
import 'subject_screen.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        Provider.of<SubjectViewModel>(context, listen: false)
            .loadSubjects());
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SubjectViewModel>(context);

    return Scaffold(
      // ❌ QUITAMOS EL APPBAR (ya lo maneja MainLayout)

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
<<<<<<< Updated upstream
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SubjectScreen(),
            ),
          );

          // 🔄 Recargar lista
          vm.loadSubjects();
        },
=======
        onPressed: () async {context.go('/materias/create');},
>>>>>>> Stashed changes
      ),

      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.subjects.isEmpty
              ? const Center(child: Text("No hay materias"))
              : ListView.builder(
                  itemCount: vm.subjects.length,
                  itemBuilder: (context, index) {
                    final s = vm.subjects[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(s.name ?? ''),
                       /*  subtitle: Text("ID: ${s.id}"), */
                        leading: const Icon(Icons.menu_book),
                      ),
                    );
                  },
                ),
    );
  }
}