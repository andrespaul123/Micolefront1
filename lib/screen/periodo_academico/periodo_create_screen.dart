import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/academic_period_viewmodel.dart';
 
class PeriodoCreateScreen extends StatefulWidget {
  const PeriodoCreateScreen({super.key});
 
  @override
  State<PeriodoCreateScreen> createState() => _PeriodoCreateScreenState();
}
 
class _PeriodoCreateScreenState extends State<PeriodoCreateScreen> {
  final _formKey          = GlobalKey<FormState>();
  final nombreController  = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  bool _activar = false;
  static const _purple = Color(0xFF4F46E5);
 
  Future<void> _pickFecha(bool isInicio) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => isInicio ? _fechaInicio = picked : _fechaFin = picked);
  }
 
  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
 
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AcademicPeriodViewModel>(context);
 
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Nuevo Periodo Académico'),
        backgroundColor: _purple, foregroundColor: Colors.white, elevation: 0,
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE9FE),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.calendar_month, color: _purple, size: 32),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(child: Text('Crear Periodo Académico',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 24),
 
                        TextFormField(
                          controller: nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre del periodo', hintText: 'Ej: 2026 - I',
                            prefixIcon: const Icon(Icons.label_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                        ),
                        const SizedBox(height: 16),
 
                        _DateTile(
                          label: _fechaInicio == null ? 'Fecha de inicio' : 'Inicio: ${_formatDate(_fechaInicio!)}',
                          icon: Icons.event_outlined, onTap: () => _pickFecha(true),
                        ),
                        const SizedBox(height: 12),
                        _DateTile(
                          label: _fechaFin == null ? 'Fecha de fin' : 'Fin: ${_formatDate(_fechaFin!)}',
                          icon: Icons.event_available_outlined, onTap: () => _pickFecha(false),
                        ),
                        const SizedBox(height: 16),
 
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _activar ? const Color(0xFFEDE9FE) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.power_settings_new, color: _purple),
                              const SizedBox(width: 12),
                              const Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Activar este periodo', style: TextStyle(fontWeight: FontWeight.w600)),
                                  Text('Desactivará el periodo actual',
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              )),
                              Switch(value: _activar, activeColor: _purple,
                                onChanged: (v) => setState(() => _activar = v)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
 
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _purple, foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;
                              if (_fechaInicio == null || _fechaFin == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Selecciona las fechas de inicio y fin')));
                                return;
                              }
                              if (_fechaFin!.isBefore(_fechaInicio!)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('La fecha fin debe ser posterior al inicio')));
                                return;
                              }
                              final ok = await vm.createPeriodo(
                                nombre:      nombreController.text.trim(),
                                fechaInicio: _formatDate(_fechaInicio!),
                                fechaFin:    _formatDate(_fechaFin!),
                                activo:      _activar,
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(ok
                                    ? '✅ Periodo creado correctamente'
                                    : '❌ Error al crear el periodo')));
                                if (ok) 
                                context.go('/periodos');
                                //context.pop(); 
                              }
                            },
                            child: const Text('Crear Periodo', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
 
class _DateTile extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _DateTile({required this.label, required this.icon, required this.onTap});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
            const Spacer(),
            Icon(Icons.calendar_today, size: 18, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}