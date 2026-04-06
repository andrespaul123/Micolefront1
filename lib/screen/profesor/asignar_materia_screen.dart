import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/profesor.dart';
import '../../models/subject.dart';
import '../../viewmodels/profesor_viewmodel.dart';
import '../../viewmodels/subject_repository.dart';
import '../../core/widgest/auth_card.dart';

class AsignarMateriaScreen extends StatefulWidget {
  final Profesor profesor;

  const AsignarMateriaScreen({super.key, required this.profesor});

  @override
  State<AsignarMateriaScreen> createState() => _AsignarMateriaScreenState();
}

class _AsignarMateriaScreenState extends State<AsignarMateriaScreen> {
  Subject? selectedSubject;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SubjectViewModel>(context, listen: false).loadSubjects());
  }

  @override
  Widget build(BuildContext context) {
    final subjectVM = Provider.of<SubjectViewModel>(context);
    final profesorVM = Provider.of<ProfesorViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text("Asignar a ${widget.profesor.name}"),
      ),
      body: subjectVM.loading
          ? const Center(child: CircularProgressIndicator())
          : AuthCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Selecciona una materia",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔥 Dropdown de materias
                  DropdownButtonFormField<Subject>(
                    value: selectedSubject,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    hint: const Text("Elegir materia"),
                    items: subjectVM.subjects.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s.name ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubject = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  // 🔥 Botón asignar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text("Asignar"),
                      onPressed: profesorVM.loading
                          ? null
                          : () async {
                              if (selectedSubject == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Selecciona una materia"),
                                  ),
                                );
                                return;
                              }

                              final success = await profesorVM.asignarMateria(
                                profesorId: widget.profesor.id!,
                                subjectId: selectedSubject!.id!,
                              );

                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Materia asignada"),
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Error al asignar"),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}