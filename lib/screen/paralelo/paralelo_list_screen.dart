import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/paralelo_viewmodel.dart';
import '../../viewmodels/curso_viewmodel.dart';

class ParaleloListScreen extends StatefulWidget {
  final int cursoId;

  const ParaleloListScreen({super.key, required this.cursoId});

  @override
  State<ParaleloListScreen> createState() => _ParaleloListScreenState();
}

class _ParaleloListScreenState extends State<ParaleloListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final cursoVM = Provider.of<CursoViewModel>(context, listen: false);
      final periodoId = cursoVM.periodoActivo!.id!;

      Provider.of<ParaleloViewModel>(context, listen: false)
          .loadParalelosByCurso(periodoId, widget.cursoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ParaleloViewModel>(context);

    return Scaffold(
      appBar:  AppBar(title: Text('Paralelos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/cursos/${widget.cursoId}/paralelos/create');
        },
        child: const Icon(Icons.add),
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.paralelos.isEmpty
              ? const Center(child: Text('No hay paralelos'))
              : ListView.builder(
                  itemCount: vm.paralelos.length,
                  itemBuilder: (_, i) {
                    final p = vm.paralelos[i];
                    return ListTile(
                      title: Text('Paralelo ${p.nombre}'),
                      subtitle: Text(p.turno ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await vm.deleteParalelo(p.id!);

                          final cursoVM = Provider.of<CursoViewModel>(
                            context,
                            listen: false,
                          );

                          vm.loadParalelosByCurso(
                            cursoVM.periodoActivo!.id!,
                            widget.cursoId,
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}