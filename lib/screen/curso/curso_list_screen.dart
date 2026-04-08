import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/curso_viewmodel.dart';
import 'curso_create_screen.dart';

class CursoListScreen extends StatefulWidget {
  const CursoListScreen({super.key});

  @override
  State<CursoListScreen> createState() => _CursoListScreenState();
}

class _CursoListScreenState extends State<CursoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CursoViewModel>(context, listen: false).loadCursos());
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CursoViewModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CursoCreateScreen()),
          );
          vm.loadCursos();
        },
        child: const Icon(Icons.add),
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.cursos.isEmpty
              ? const Center(child: Text("No hay cursos"))
              : ListView.builder(
                  itemCount: vm.cursos.length,
                  itemBuilder: (_, i) {
                    final c = vm.cursos[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        leading: const CircleAvatar(
                          child: Icon(Icons.class_),
                        ),
                        title: Text(
                          c.nombre ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.nivel ?? ''),
                            if (c.descripcion != null && c.descripcion!.isNotEmpty)
                              Text(
                                c.descripcion!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),

                  //  BOTÓN ELIMINAR
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar curso',
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('¿Eliminar curso?'),
                                content: Text(
                                    'Se eliminará "${c.nombre}" permanentemente.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Eliminar',
                                        style:
                                            TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final success =
                                  await vm.deleteCurso(c.id!);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success
                                        ? 'Curso eliminado'
                                        : 'Error al eliminar'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}