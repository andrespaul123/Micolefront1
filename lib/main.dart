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

// VIEWMODELS
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/tenant_viewmodel.dart';
import 'viewmodels/subject_repository.dart'; 

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
            repository: AuthRepository(dio: dio),
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