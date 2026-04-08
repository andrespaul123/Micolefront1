import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/profesor_viewmodel.dart';
import 'profesor_create_screen.dart';
import 'asignar_materia_screen.dart';

class ProfesorListScreen extends StatefulWidget {
  const ProfesorListScreen({super.key});

  @override
  State<ProfesorListScreen> createState() => _ProfesorListScreenState();
}

class _ProfesorListScreenState extends State<ProfesorListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfesorViewModel>(context, listen: false)
            .loadProfesores());
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfesorViewModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfesorCreateScreen(),
            ),
          );
          vm.loadProfesores();
        },
        child: const Icon(Icons.add),
      ),

      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.profesores.isEmpty
              ? const Center(child: Text("No hay profesores"))
              : ListView.builder(
                  itemCount: vm.profesores.length,
                  itemBuilder: (_, i) {
                    final p = vm.profesores[i];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),

                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),

                        title: Text(
                          p.name ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.email ?? ''),
                            if (p.especialidad != null)
                              Text(
                                p.especialidad!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),

                        // 🔥 DOS BOTONES
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 📚 ASIGNAR MATERIA
                            IconButton(
                              icon: const Icon(
                                Icons.menu_book,
                                color: Colors.blue,
                              ),
                              tooltip: 'Asignar materia',
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AsignarMateriaScreen(profesor: p),
                                  ),
                                );
                              },
                            ),

                            // 🗑️ ELIMINAR
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              tooltip: 'Eliminar profesor',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('¿Eliminar profesor?'),
                                    content: Text(
                                        'Se eliminará a "${p.name}" permanentemente.'),
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
                                        child: const Text(
                                          'Eliminar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  final success =
                                      await vm.deleteProfesor(p.id!);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(success
                                            ? 'Profesor eliminado'
                                            : 'Error al eliminar'),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}