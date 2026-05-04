import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'repository/profesor_repository.dart';
import 'viewmodels/profesor_viewmodel.dart';
// 🔥 INTERCEPTOR
import 'core/dio/dio_client.dart';
// REPOSITORIES
import 'repository/auth_repository.dart';
import 'repository/tenant_repository.dart';
import 'repository/subject_repository.dart';
import 'repository/curso_repository.dart';
import 'repository/paralelo_repository.dart';
import 'repository/asignacion_repository.dart';

// VIEWMODELS
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/tenant_viewmodel.dart';
import 'viewmodels/subject_repository.dart'; 
import 'viewmodels/curso_viewmodel.dart'; 
import 'viewmodels/paralelo_viewmodel.dart';
import 'viewmodels/asignacion_viewmodel.dart';

// SCREENS
import 'screen/login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 USAR DIO CON INTERCEPTOR
  final dio = DioClient.create();

  runApp(
    MultiProvider(
      providers: [
        // 🔐 AUTH
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            repository: AuthRepository(dio),
          ),
        ),

        // 🏫 TENANT
        ChangeNotifierProxyProvider<AuthViewModel, TenantViewModel>(
          create: (_) => TenantViewModel(
            repository: TenantRepository(dio),
          ),
          update: (_, auth, previous) {
            // ❌ YA NO USAMOS HEADERS MANUALES
            return TenantViewModel(
              repository: TenantRepository(dio),
            );
          },
        ),

        // 📚 SUBJECT
        ChangeNotifierProxyProvider<AuthViewModel, SubjectViewModel>(
          create: (_) => SubjectViewModel(
            repository: SubjectRepository(dio),
          ),
          update: (_, auth, previous) {
            // ❌ YA NO USAMOS HEADERS MANUALES
            return SubjectViewModel(
              repository: SubjectRepository(dio),
            );
          },
        ),
        
        //curso
        ChangeNotifierProxyProvider<AuthViewModel, CursoViewModel>(
          create: (_) => CursoViewModel(
            repository: CursoRepository(dio),
          ),  
          update: (_, auth, previous) {
            // ❌ YA NO USAMOS HEADERS MANUALES
            return CursoViewModel(
              repository: CursoRepository(dio),
            );
          },
        ),
        
        ChangeNotifierProxyProvider<AuthViewModel, ParaleloViewModel>(
        create: (_) => ParaleloViewModel(
        repository: ParaleloRepository(dio),
    ),
  update: (_, auth, previous) {
    return ParaleloViewModel(
      repository: ParaleloRepository(dio),
    );
  },
),
ChangeNotifierProvider(
  create: (_) => AsignacionViewModel(
    repository: AsignacionRepository(dio),
  ),
),
// Dentro de MultiProvider, añade esto:

<<<<<<< Updated upstream
        ChangeNotifierProxyProvider<AuthViewModel, ProfesorViewModel>(
  create: (_) => ProfesorViewModel(
    repository: ProfesorRepository(dio),
  ),
  update: (_, auth, previous) {
    return ProfesorViewModel(
      repository: ProfesorRepository(dio),
    );
  },
),
=======
        // Paralelo
        ChangeNotifierProvider(
          create: (_) => ParaleloViewModel(
            repository: ParaleloRepository(dio),
          ),
        ),

        // Profesor
        ChangeNotifierProvider(
          create: (_) => ProfesorViewModel(
            repository: ProfesorRepository(dio),
          ),
        ),

        //  Estudiante
        ChangeNotifierProvider(
          create: (_) => EstudianteViewModel(
            repository: EstudianteRepository(dio),
          ),
        ),

        //  Padre de familia
        ChangeNotifierProvider(
          create: (_) => PadreFamiliaViewModel(
            repository: PadreFamiliaRepository(dio),
          ),
        ),

        // Periodo académico
        ChangeNotifierProvider(
          create: (_) => AcademicPeriodViewModel(
            repository: AcademicPeriodRepository(dio),
          )..loadPeriodoActivo(),
        ),

        // Asignación
        ChangeNotifierProvider(
          create: (_) => AsignacionViewModel(
            repository: AsignacionRepository(dio),
            periodoRepository: AcademicPeriodRepository(dio),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => CircularViewModel(
            repository: CircularRepository(dio),  
          ),
        ),
>>>>>>> Stashed changes
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MI COLE APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),

      // 🔥 SE MANTIENE COMO ANTES
      home: const LoginScreen(),
    );
  }
}