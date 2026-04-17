import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/subject_repository.dart';
import '../../core/widgest/app/app_card.dart';
import '../../core/widgest/app/app_input.dart';
 
class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});
 
  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}
 
class _SubjectScreenState extends State<SubjectScreen> {
  final _formKey        = GlobalKey<FormState>();
  final nameController  = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SubjectViewModel>(context);
 
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Nueva Materia'), elevation: 0),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: AppCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Crear Materia',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          AppInput(
                            controller: nameController,
                            label: 'Nombre de la materia',
                            icon: Icons.menu_book,
                            validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: vm.loading ? null : () async {
                                if (!_formKey.currentState!.validate()) return;
                                final success = await vm.createSubject(nameController.text);
                                if (mounted) {
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Materia creada correctamente')));
                                    //context.go('/materias');
                                   
                                   context.go('/materias');
                              
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Error al crear')));
                                  }
                                }
                              },
                              child: vm.loading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Guardar Materia', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}