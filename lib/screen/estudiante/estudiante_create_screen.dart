import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/estudiante_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';
import 'package:go_router/go_router.dart';

class EstudianteCreateScreen extends StatefulWidget {
  const EstudianteCreateScreen({super.key});

  @override
  State<EstudianteCreateScreen> createState() =>
      _EstudianteCreateScreenState();
}

class _EstudianteCreateScreenState extends State<EstudianteCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final codigoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<EstudianteViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : AuthCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.school, size: 60, color: Colors.blue),
                    const SizedBox(height: 10),
                    const Text(
                      'Crear Estudiante',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    AuthInput(
                      controller: nameController,
                      label: 'Nombre',
                      icon: Icons.person,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscure: true,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    AuthInput(
                      controller: codigoController,
                      label: 'Código Estudiante',
                      icon: Icons.badge,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          final success = await vm.createEstudiante(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            codigo: codigoController.text,
                          );

                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Estudiante creado correctamente')),
                            );
                            context.go('/estudiantes'); 
                            /* context.pop(true); */
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error al crear')),
                            );
                          }
                        },
                        child: const Text('Crear Estudiante'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}