import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';   
import 'core/dio/dio_client.dart';

// Repositories
import 'repository/auth_repository.dart';
import 'repository/tenant_repository.dart';
import 'repository/subject_repository.dart';
import 'repository/curso_repository.dart';
import 'repository/paralelo_repository.dart';
import 'repository/asignacion_repository.dart';
import 'repository/academic_period_repository.dart';
import 'repository/profesor_repository.dart';
import 'repository/estudiante_repository.dart';
import 'repository/padre_familia_repository.dart';

// ViewModels
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/tenant_viewmodel.dart';
import 'viewmodels/subject_repository.dart';
import 'viewmodels/curso_viewmodel.dart';
import 'viewmodels/paralelo_viewmodel.dart';
import 'viewmodels/asignacion_viewmodel.dart';
import 'viewmodels/academic_period_viewmodel.dart';
import 'viewmodels/profesor_viewmodel.dart';
import 'viewmodels/estudiante_viewmodel.dart';
import 'viewmodels/padre_familia_viewmodel.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = DioClient.create();
  final authViewModel = AuthViewModel(repository: AuthRepository(dio));
  await authViewModel.loadSession();

  // 🔥 Crear el router UNA sola vez, fuera del build tree
  final router = createRouter(authViewModel);

  runApp(
    MultiProvider(
      providers: [
        // Auth
        ChangeNotifierProvider.value(value: authViewModel),

        // Tenant
        ChangeNotifierProxyProvider<AuthViewModel, TenantViewModel>(
          create: (_) => TenantViewModel(repository: TenantRepository(dio)),
          update: (_, __, prev) => prev ?? TenantViewModel(repository: TenantRepository(dio)),
        ),

        // Subject
        ChangeNotifierProxyProvider<AuthViewModel, SubjectViewModel>(
          create: (_) => SubjectViewModel(repository: SubjectRepository(dio)),
          update: (_, __, prev) => prev ?? SubjectViewModel(repository: SubjectRepository(dio)),
        ),

        // Curso
        ChangeNotifierProxyProvider<AuthViewModel, CursoViewModel>(
          create: (_) => CursoViewModel(
            repository: CursoRepository(dio),
            periodoRepository: AcademicPeriodRepository(dio),
          ),
          update: (_, __, prev) => prev ?? CursoViewModel(
            repository: CursoRepository(dio),
            periodoRepository: AcademicPeriodRepository(dio),
          ),
        ),

        // Paralelo
        ChangeNotifierProxyProvider<AuthViewModel, ParaleloViewModel>(
          create: (_) => ParaleloViewModel(repository: ParaleloRepository(dio)),
          update: (_, __, prev) => prev ?? ParaleloViewModel(repository: ParaleloRepository(dio)),
        ),

        // Profesor
        ChangeNotifierProxyProvider<AuthViewModel, ProfesorViewModel>(
          create: (_) => ProfesorViewModel(repository: ProfesorRepository(dio)),
          update: (_, __, prev) => prev ?? ProfesorViewModel(repository: ProfesorRepository(dio)),
        ),

        //ESTUDIANTE
        ChangeNotifierProxyProvider<AuthViewModel, EstudianteViewModel>(
          create: (_) => EstudianteViewModel(repository: EstudianteRepository(dio)),
          update: (_, __, prev) => prev ?? EstudianteViewModel(repository: EstudianteRepository(dio)),
        ),

        //PADRE DE FAMILIA
        ChangeNotifierProxyProvider<AuthViewModel, PadreFamiliaViewModel>(
          create: (_) => PadreFamiliaViewModel(repository: PadreFamiliaRepository(dio)),
          update: (_, __, prev) => prev ?? PadreFamiliaViewModel(repository: PadreFamiliaRepository(dio)),

        ),
        // Periodo académico
        ChangeNotifierProxyProvider<AuthViewModel, AcademicPeriodViewModel>(
          create: (_) => AcademicPeriodViewModel(repository: AcademicPeriodRepository(dio)),
          update: (_, __, prev) => prev ?? AcademicPeriodViewModel(repository: AcademicPeriodRepository(dio)),
        ),

        // Asignación
        ChangeNotifierProvider(
          create: (_) => AsignacionViewModel(repository: AsignacionRepository(dio)),
        ),
      ],
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(           
      title: 'MI COLE APP',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}