import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';
import '../../core/widgest/auth_card.dart';
import '../../core/widgest/auth_input.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
          ),
        ),
        child: AuthCard(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_add,
                    size: 60, color: Colors.blue),
                const SizedBox(height: 10),
                const Text(
                  'Crear cuenta',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                AuthInput(
                  controller: nameController,
                  label: 'Nombre',
                  icon: Icons.person,
                  validator: (v) =>
                      v!.isEmpty ? 'Campo requerido' : null,
                ),

                const SizedBox(height: 16),
<<<<<<< Updated upstream

                AuthInput(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                  validator: (v) =>
                      v!.isEmpty ? 'Campo requerido' : null,
                ),

                const SizedBox(height: 16),

                AuthInput(
                  controller: passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock,
                  obscure: true,
                  validator: (v) =>
                      v!.isEmpty ? 'Campo requerido' : null,
                ),

=======
                AuthInput(
  controller: emailController,
  label: 'Email',
  icon: Icons.email,
  validator: (v) {
    if (v == null || v.isEmpty) {
      return 'Campo requerido';
    }

    if (!v.contains('@') || !v.contains('.')) {
      return 'Correo inválido';
    }

    return null;
  },
),
                const SizedBox(height: 16),
                AuthInput(controller: passwordController, label: 'Contraseña', icon: Icons.lock,
                  obscure: true, validator: (v) {
  if (v == null || v.isEmpty) return 'Campo requerido';
  if (v.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
  return null;
},),
>>>>>>> Stashed changes
                const SizedBox(height: 20),
                if (auth.loginError != null) ...[
               const SizedBox(height: 10),
                Text( auth.loginError!, style: const TextStyle(   color: Colors.red,   fontSize: 14, fontWeight: FontWeight.w600,),
               textAlign: TextAlign.center,
               ),
            ],
          const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.loading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate())
                              return;

                            final success = await auth.register(
                              nameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text,
                            );

                            if (success && mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LoginScreen(),
                                ),
                              );
                            }
                          },
                    child: auth.loading
                        ? const CircularProgressIndicator(
                            color: Colors.white)
                        : const Text('Registrarse'),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                      '¿Ya tienes cuenta? Inicia sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}