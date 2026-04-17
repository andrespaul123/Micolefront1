import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/tenant_viewmodel.dart';
import '../../core/widgest/app/app_card.dart';
import '../../core/widgest/app/app_input.dart';
 
class DirectorTenantScreen extends StatefulWidget {
  const DirectorTenantScreen({super.key});
 
  @override
  State<DirectorTenantScreen> createState() => _DirectorTenantScreenState();
}
 
class _DirectorTenantScreenState extends State<DirectorTenantScreen> {
  final _formKey        = GlobalKey<FormState>();
  final nameController  = TextEditingController();
  final slugController  = TextEditingController();
 
  XFile?     _selectedFile;
  Uint8List? _previewBytes;
 
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() { _selectedFile = picked; _previewBytes = bytes; });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TenantViewModel>(context);
 
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('Mi Colegio')),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ── Logo ──────────────────────────────────────────────
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Logo del colegio',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 120, height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: _previewBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(_previewBytes!, fit: BoxFit.cover))
                                  : const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_photo_alternate, size: 40, color: Colors.blue),
                                        SizedBox(height: 8),
                                        Text('Seleccionar', style: TextStyle(color: Colors.blue)),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.upload),
                            label: const Text('Subir logo'),
                            onPressed: _selectedFile == null ? null : () async {
                              final ok = await vm.uploadLogo(_selectedFile!);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(ok ? '✅ Logo actualizado' : '❌ Error al subir')));
                              if (ok) context.pop(); // 🔥
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
 
                  const SizedBox(height: 20),
 
                  // ── Datos ────────────────────────────────────────────
                  AppCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Datos del colegio',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          AppInput(controller: nameController, label: 'Nombre del colegio',
                            icon: Icons.school, validator: (v) => v!.isEmpty ? 'Requerido' : null),
                          const SizedBox(height: 16),
                          AppInput(controller: slugController, label: 'Slug (ej: mi-colegio)',
                            icon: Icons.link, validator: (v) => v!.isEmpty ? 'Requerido' : null),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.save),
                              label: const Text('Guardar cambios'),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;
                                final ok = await vm.updateTenant(
                                  name: nameController.text.trim(),
                                  slug: slugController.text.trim(),
                                );
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(ok ? '✅ Colegio actualizado' : '❌ Error al actualizar')));
                                if (ok) 
                                context.go('/colegio');
                               // context.pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
 
 