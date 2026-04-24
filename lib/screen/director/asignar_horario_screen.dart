import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/subject.dart';
import '../../models/curso.dart';
import '../../models/paralelo.dart';

import '../../viewmodels/asignacion_viewmodel.dart';
import '../../viewmodels/profesor_viewmodel.dart';
import '../../viewmodels/curso_viewmodel.dart';
import '../../viewmodels/paralelo_viewmodel.dart';

class AsignarHorarioScreen extends StatefulWidget {
  final int profesorId;

  const AsignarHorarioScreen({
    super.key,
    required this.profesorId,
  });

  @override
  State<AsignarHorarioScreen> createState() => _AsignarHorarioScreenState();
}

class _AsignarHorarioScreenState extends State<AsignarHorarioScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _dia;
  Subject? _subject;
  Curso? _curso;
  Paralelo? _paralelo;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFin;

  final _dias = ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado'];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<ProfesorViewModel>(context, listen: false)
          .loadSubjectsProfesor(widget.profesorId);

      Provider.of<CursoViewModel>(context, listen: false).loadCursos();
      Provider.of<ParaleloViewModel>(context, listen: false).loadParalelos();
    });
  }

  String _formatTime(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _pickTime(bool isInicio) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isInicio) {
          _horaInicio = picked;
        } else {
          _horaFin = picked;
        }
      });
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_dia == null ||
        _subject == null ||
        _curso == null ||
        _paralelo == null ||
        _horaInicio == null ||
        _horaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    final inicio = _horaInicio!.hour * 60 + _horaInicio!.minute;
    final fin = _horaFin!.hour * 60 + _horaFin!.minute;

    if (fin <= inicio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La hora fin debe ser mayor')),
      );
      return;
    }

    final vm = Provider.of<AsignacionViewModel>(context, listen: false);

    final error = await vm.crearAsignacion(
      profesorId: widget.profesorId,
      subjectId: _subject!.id!,
      cursoId: _curso!.id!,
      paraleloId: _paralelo!.id!,
      dia: _dia!,
      horaInicio: _formatTime(_horaInicio!),
      horaFin: _formatTime(_horaFin!),
    );

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Horario asignado correctamente')),
      );
      context.go('/profesores');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AsignacionViewModel>(context);
    final profVM = Provider.of<ProfesorViewModel>(context);
    final cursoVM = Provider.of<CursoViewModel>(context);
    final paraleVM = Provider.of<ParaleloViewModel>(context);

    final paralelos = _curso == null
        ? paraleVM.paralelos
        : paraleVM.paralelos.where((p) => p.cursoId == _curso!.id).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Asignar horario')),

      body: vm.loading || profVM.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    _label("Día"),
                    DropdownButtonFormField<String>(
                      value: _dia,
                      items: _dias
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (v) => setState(() => _dia = v),
                    ),

                    _label("Horario"),
                    ListTile(
                      title: Text(_horaInicio == null
                          ? 'Hora inicio'
                          : 'Inicio: ${_formatTime(_horaInicio!)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _pickTime(true),
                    ),

                    ListTile(
                      title: Text(_horaFin == null
                          ? 'Hora fin'
                          : 'Fin: ${_formatTime(_horaFin!)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _pickTime(false),
                    ),

                    _label("Materia"),
                    DropdownButtonFormField<Subject>(
                      value: _subject,
                      items: profVM.subjectsProfesor
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.name ?? ''),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _subject = v),
                    ),

                    _label("Curso"),
                    DropdownButtonFormField<Curso>(
                      value: _curso,
                      items: cursoVM.cursos
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text('${c.nombre} · ${c.nivel}'),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          _curso = v;
                          _paralelo = null;
                        });
                      },
                    ),

                    _label("Paralelo"),
                    DropdownButtonFormField<Paralelo>(
                      value: _paralelo,
                      items: paralelos
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text('${p.nombre} · ${p.turno ?? ''}'),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _paralelo = v),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: vm.loading ? null : _guardar,
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}