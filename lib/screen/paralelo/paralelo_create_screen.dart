import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/paralelo_viewmodel.dart';
import '../../viewmodels/curso_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';

class ParaleloCreateScreen extends StatefulWidget {
  final int cursoId;

  const ParaleloCreateScreen({
    super.key,
    required this.cursoId,
  });

  @override
  State<ParaleloCreateScreen> createState() => _ParaleloCreateScreenState();
}

class _ParaleloCreateScreenState extends State<ParaleloCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final turnoController = TextEditingController();
  final capacidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ParaleloViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text('Nuevo Paralelo'),
      ),

      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : AuthCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_tree, size: 60, color: Colors.blue),
                    const SizedBox(height: 10),

                    const Text(
                      'Crear Paralelo',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    AuthInput(
                      controller: nombreController,
                      label: 'Nombre (A, B, C...)',
                      icon: Icons.label,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),

                    const SizedBox(height: 16),

                    AuthInput(
                      controller: turnoController,
                      label: 'Turno',
                      icon: Icons.schedule,
                      validator: (_) => null,
                    ),

                    const SizedBox(height: 16),

                    AuthInput(
                      controller: capacidadController,
                      label: 'Capacidad',
                      icon: Icons.people,
                      validator: (_) => null,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          final success = await vm.createParalelo(
                            cursoId: widget.cursoId,
                            nombre: nombreController.text.trim(),
                            turno: turnoController.text.trim().isEmpty
                                ? null
                                : turnoController.text.trim(),
                            capacidad: capacidadController.text.trim().isEmpty
                                ? null
                                : int.tryParse(capacidadController.text.trim()),
                          );

                          if (!mounted) return;

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Paralelo creado correctamente'),
                              ),
                            );

                            context.go('/cursos/${widget.cursoId}/paralelos');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al crear'),
                              ),
                            );
                          }
                        },
                        child: const Text('Crear Paralelo'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}