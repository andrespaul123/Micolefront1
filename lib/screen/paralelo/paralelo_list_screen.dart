import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/paralelo_viewmodel.dart';
import 'paralelo_create_screen.dart';

class ParaleloListScreen extends StatefulWidget {
  const ParaleloListScreen({super.key});

  @override
  State<ParaleloListScreen> createState() => _ParaleloListScreenState();
}

class _ParaleloListScreenState extends State<ParaleloListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ParaleloViewModel>(context, listen: false).loadParalelos());
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ParaleloViewModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ParaleloCreateScreen()),
          );
          vm.loadParalelos();
        },
        child: const Icon(Icons.add),
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.paralelos.isEmpty
              ? const Center(child: Text("No hay paralelos"))
              : ListView.builder(
                  itemCount: vm.paralelos.length,
                  itemBuilder: (_, i) {
                    final p = vm.paralelos[i];
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
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            p.nombre ?? '?',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                        title: Text(
                          '${p.curso?.nombre ?? 'Curso'} — Paralelo ${p.nombre}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (p.turno != null)
                              Text('Turno: ${p.turno}'),
                            if (p.capacidad != null)
                              Text(
                                'Capacidad: ${p.capacidad} alumnos',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),
                     trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar paralelo',
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('¿Eliminar paralelo?'),
                                content: Text(
                                    'Se eliminará "${p.nombre}" permanentemente.'),
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
                                  await vm.deleteParalelo(p.id!);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success
                                        ? 'Paralelo eliminado'
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