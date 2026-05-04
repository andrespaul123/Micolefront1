import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/paralelo_viewmodel.dart';
<<<<<<< Updated upstream
import '../../viewmodels/curso_viewmodel.dart';
import '../../models/curso.dart';
=======
>>>>>>> Stashed changes
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';

class ParaleloCreateScreen extends StatefulWidget {
  const ParaleloCreateScreen({super.key});

  @override
  State<ParaleloCreateScreen> createState() => _ParaleloCreateScreenState();
}

class _ParaleloCreateScreenState extends State<ParaleloCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final turnoController = TextEditingController();
  final capacidadController = TextEditingController();

  Curso? selectedCurso;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CursoViewModel>(context, listen: false).loadCursos());
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ParaleloViewModel>(context);
    final cursoVM = Provider.of<CursoViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Crear Paralelo')),
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

                    // 🔥 Dropdown de cursos
                    DropdownButtonFormField<Curso>(
                      value: selectedCurso,
                      decoration: InputDecoration(
                        labelText: 'Curso',
                        prefixIcon: const Icon(Icons.class_),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      hint: const Text('Seleccionar curso'),
                      items: cursoVM.cursos.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text('${c.nombre} — ${c.nivel}'),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedCurso = value),
                      validator: (_) =>
                          selectedCurso == null ? 'Selecciona un curso' : null,
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: nombreController,
                      label: 'Nombre (ej: A, B, C)',
                      icon: Icons.label,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: turnoController,
                      label: 'Turno (ej: Mañana, Tarde)',
                      icon: Icons.schedule,
                      validator: (_) => null,
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: capacidadController,
                      label: 'Capacidad (nº alumnos)',
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
                            cursoId: selectedCurso!.id!,
                            nombre: nombreController.text.trim(),
                            turno: turnoController.text.trim().isEmpty
                                ? null
                                : turnoController.text.trim(),
                            capacidad: capacidadController.text.trim().isEmpty
                                ? null
                                : int.tryParse(capacidadController.text.trim()),
                          );

                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Paralelo creado correctamente')),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error al crear')),
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