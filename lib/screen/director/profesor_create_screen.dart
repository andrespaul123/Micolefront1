import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/profesor_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';
 
class ProfesorCreateScreen extends StatefulWidget {
  const ProfesorCreateScreen({super.key});
 
  @override
  State<ProfesorCreateScreen> createState() => _ProfesorCreateScreenState();
}
 
class _ProfesorCreateScreenState extends State<ProfesorCreateScreen> {
  final _formKey             = GlobalKey<FormState>();
  final nameController       = TextEditingController();
  final emailController      = TextEditingController();
  final passwordController   = TextEditingController();
  final codigoController     = TextEditingController();
  final especialidadController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfesorViewModel>(context);
 
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Crear Profesor')),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : AuthCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, size: 60, color: Colors.blue),
                    const SizedBox(height: 10),
                    const Text('Crear Profesor',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    AuthInput(controller: nameController, label: 'Nombre', icon: Icons.person,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
                    const SizedBox(height: 16),
                    AuthInput(controller: emailController, label: 'Email', icon: Icons.email,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
                    const SizedBox(height: 16),
                    AuthInput(controller: passwordController, label: 'Contraseña', icon: Icons.lock,
                      obscure: true, validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
                    const SizedBox(height: 16),
                    AuthInput(controller: codigoController, label: 'Código Profesor', icon: Icons.badge,
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null),
                    const SizedBox(height: 16),
                    AuthInput(controller: especialidadController, label: 'Especialidad', icon: Icons.book,
                      validator: (_) => null),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final success = await vm.createProfesor(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            codigo: codigoController.text,
                            especialidad: especialidadController.text,
                          );
                          if (mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profesor creado correctamente')));
                              context.go('/profesores');
                              //context.pop(); 
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error al crear')));
                            }
                          }
                        },
                        child: const Text('Crear Profesor'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}