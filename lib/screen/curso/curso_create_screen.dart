import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/curso_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';
 
class CursoCreateScreen extends StatefulWidget {
  const CursoCreateScreen({super.key});
 
  @override
  State<CursoCreateScreen> createState() => _CursoCreateScreenState();
}
 
class _CursoCreateScreenState extends State<CursoCreateScreen> {
  final _formKey            = GlobalKey<FormState>();
  final nombreController    = TextEditingController();
  final nivelController     = TextEditingController();
  final descripcionController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CursoViewModel>(context);
 
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Crear Curso')),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : AuthCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.class_, size: 60, color: Colors.blue),
                    const SizedBox(height: 10),
                    const Text('Crear Curso',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    AuthInput(controller: nombreController, label: 'Nombre del curso',
                      icon: Icons.drive_file_rename_outline,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
                    const SizedBox(height: 16),
                    AuthInput(controller: nivelController, label: 'Nivel (ej: Primaria)',
                      icon: Icons.stairs,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
                    const SizedBox(height: 16),
                    AuthInput(controller: descripcionController, label: 'Descripción (opcional)',
                      icon: Icons.notes, validator: (_) => null),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final success = await vm.createCurso(
                            nombre:      nombreController.text.trim(),
                            nivel:       nivelController.text.trim(),
                            descripcion: descripcionController.text.trim(),
                          );
                          if (mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Curso creado correctamente')));
                              context.go('/cursos'); 
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error al crear')));
                            }
                          }
                        },
                        child: const Text('Crear Curso'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}