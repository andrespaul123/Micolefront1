import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/tenant_viewmodel.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';
 
class TenantScreen extends StatefulWidget {
  const TenantScreen({super.key});
 
  @override
  State<TenantScreen> createState() => _TenantScreenState();
}
 
class _TenantScreenState extends State<TenantScreen> {
  final _formKey                = GlobalKey<FormState>();
  final nameController          = TextEditingController();
  final slugController          = TextEditingController();
  final directorNameController  = TextEditingController();
  final directorEmailController = TextEditingController();
  final passwordController      = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TenantViewModel>(context);
 
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Crear Colegio')),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : AuthCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AuthInput(controller: nameController, label: 'Nombre colegio',
                      icon: Icons.school, validator: (v) => v!.isEmpty ? 'Requerido' : null),
                    const SizedBox(height: 16),
                    AuthInput(controller: slugController, label: 'Slug',
                      icon: Icons.link, validator: (v) => v!.isEmpty ? 'Requerido' : null),
                    const SizedBox(height: 16),
                    AuthInput(controller: directorNameController, label: 'Nombre director',
                      icon: Icons.person, validator: (v) => v!.isEmpty ? 'Requerido' : null),
                    const SizedBox(height: 16),
                    AuthInput(controller: directorEmailController, label: 'Email director',
                      icon: Icons.email, validator: (v) => v!.isEmpty ? 'Requerido' : null),
                    const SizedBox(height: 16),
                    AuthInput(controller: passwordController, label: 'Password',
                      icon: Icons.lock, obscure: true,
                      validator: (v) => v!.isEmpty ? 'Requerido' : null),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final success = await vm.createTenant(
                            name:          nameController.text,
                            slug:          slugController.text,
                            directorName:  directorNameController.text,
                            directorEmail: directorEmailController.text,
                            password:      passwordController.text,
                          );
                          if (mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Colegio creado')));
                              context.go('/colegios');
                              //context.pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error al crear')));
                            }
                          }
                        },
                        child: const Text('Crear Colegio'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}