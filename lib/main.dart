import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'repository/profesor_repository.dart';
import 'viewmodels/profesor_viewmodel.dart';
// 🔥 INTERCEPTOR
import 'core/dio/dio_client.dart';
import 'core/app_keys.dart';
import 'core/layout/main_layout.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 USAR DIO CON INTERCEPTOR
  final dio = DioClient.create();
  final authViewModel = AuthViewModel(repository: AuthRepository(dio));
  await authViewModel.loadSession();

  runApp(
    MultiProvider(
      providers: [
        // 🔐 AUTH
        ChangeNotifierProvider.value(value: authViewModel),

        // 🏫 TENANT
        ChangeNotifierProxyProvider<AuthViewModel, TenantViewModel>(
          create: (_) => TenantViewModel(
            repository: TenantRepository(dio),
          ),
          update: (_, auth, previous) =>
              previous ?? TenantViewModel(repository: TenantRepository(dio)),
        ),

        // 📚 SUBJECT
        ChangeNotifierProxyProvider<AuthViewModel, SubjectViewModel>(
          create: (_) => SubjectViewModel(
            repository: SubjectRepository(dio),
          ),
          update: (_, auth, previous) =>
              previous ?? SubjectViewModel(repository: SubjectRepository(dio)),
        ),

        // CURSO
        ChangeNotifierProxyProvider<AuthViewModel, CursoViewModel>(
          create: (_) => CursoViewModel(
            repository: CursoRepository(dio),
          ),
          update: (_, auth, previous) =>
              previous ?? CursoViewModel(repository: CursoRepository(dio)),
        ),

        // PARALELO
        ChangeNotifierProxyProvider<AuthViewModel, ParaleloViewModel>(
          create: (_) => ParaleloViewModel(
            repository: ParaleloRepository(dio),
          ),
          update: (_, auth, previous) =>
              previous ?? ParaleloViewModel(repository: ParaleloRepository(dio)),
        ),

        // PROFESOR
        ChangeNotifierProxyProvider<AuthViewModel, ProfesorViewModel>(
          create: (_) => ProfesorViewModel(
            repository: ProfesorRepository(dio),
          ),
          update: (_, auth, previous) =>
              previous ?? ProfesorViewModel(repository: ProfesorRepository(dio)),
        ),

        // ASIGNACION
        ChangeNotifierProvider(
          create: (_) => AsignacionViewModel(
            repository: AsignacionRepository(dio),
          ),
        ),
      ],
      child: MyApp(isLoggedIn: authViewModel.isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MI COLE APP',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? const MainLayout() : const LoginScreen(),
    );
  }
}