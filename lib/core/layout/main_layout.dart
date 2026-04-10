import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/tenant_viewmodel.dart';
import '../../screen/tenant_screen.dart';
import '../../screen/subject/subject_list_screen.dart';
import '../../screen/login/login_screen.dart';
import '../../screen/director/profesor_list_screen.dart';
import '../../screen/curso/curso_list_screen.dart';
import '../../screen/paralelo/paralelo_list_screen.dart';
import '../../screen/tenant/tenant_list_screen.dart';
import '../../screen/tenant/my_tenant_screen.dart';
import '../layout/home_dashboard.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;

  static const _purple     = Color(0xFF4F46E5);
  static const _purpleSoft = Color(0xFFF0EFFF);
  static const _gray400    = Color(0xFF9CA3AF);
  static const _bgPage     = Color(0xFFF5F7FB);

  @override
  void initState() {
    super.initState();
    // Carga el tenant al entrar para tener nombre y logo en el AppBar
    Future.microtask(() {
      final auth = context.read<AuthViewModel>();
      if (auth.role == 'director') {
        final vm = context.read<TenantViewModel>();
        if (vm.currentTenant == null && !vm.loading) {
          vm.loadMyTenant();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth     = Provider.of<AuthViewModel>(context);
    final tenantVM = Provider.of<TenantViewModel>(context);
    final role     = auth.role;

    List<Widget>  screens = [];
    List<_NavTab> tabs    = [];

    // ── SUPER ADMIN ──────────────────────────────────────────────────────
    if (role == 'super-admin') {
      screens = [
        HomeDashboard(onNavigate: (i) => setState(() => selectedIndex = i)),
        const TenantListScreen(),
        const TenantScreen(),
      ];
      tabs = const [
        _NavTab(Icons.home_outlined,        Icons.home,         'Inicio'),
        _NavTab(Icons.school_outlined,       Icons.school,       'Colegios'),
        _NavTab(Icons.add_business_outlined, Icons.add_business, 'Crear'),
      ];
    }

    // ── DIRECTOR ─────────────────────────────────────────────────────────
    else if (role == 'director') {
      screens = [
        HomeDashboard(onNavigate: (i) => setState(() => selectedIndex = i)),
        const SubjectListScreen(),
        const ProfesorListScreen(),
        const CursoListScreen(),
        const ParaleloListScreen(),
        const MyTenantScreen(),
      ];
      tabs = const [
        _NavTab(Icons.home_outlined,          Icons.home,         'Inicio'),
        _NavTab(Icons.menu_book_outlined,     Icons.menu_book,    'Materias'),
        _NavTab(Icons.person_outline,         Icons.person,       'Profesores'),
        _NavTab(Icons.class_outlined,         Icons.class_,       'Cursos'),
        _NavTab(Icons.account_tree_outlined,  Icons.account_tree, 'Paralelos'),
        _NavTab(Icons.school_outlined,        Icons.school,       'Colegio'),
      ];
    }

    return Scaffold(
      backgroundColor: _bgPage,

      // ── AppBar ─────────────────────────────────────────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(62),
        child: Container(
          color: _purple,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Logo: imagen del tenant o fallback con iniciales
                  _buildLogo(role, tenantVM),
                  const SizedBox(width: 10),

                  // Nombre dinámico del colegio
                  Expanded(child: _buildTitle(role, tenantVM)),

                  // Avatar → logout
                  GestureDetector(
                    onTap: () => _showLogoutDialog(context, auth),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _initials(auth.user?.name ?? '?'),
                        style: const TextStyle(
                          color: _purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // ── Body ───────────────────────────────────────────────────────────
      body: screens.isNotEmpty ? screens[selectedIndex] : const SizedBox(),

      // ── Bottom nav ─────────────────────────────────────────────────────
      bottomNavigationBar: tabs.isEmpty ? null : _buildBottomNav(tabs),
    );
  }

  // ── AppBar: logo ─────────────────────────────────────────────────────────
  Widget _buildLogo(String? role, TenantViewModel tenantVM) {
    final logoUrl = role == 'director' ? tenantVM.currentTenant?.logoUrl : null;

    if (logoUrl != null && logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          logoUrl,
          width: 36,
          height: 36,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _logoFallback(),
        ),
      );
    }
    return _logoFallback();
  }

  Widget _logoFallback() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.school_outlined, color: Colors.white, size: 20),
    );
  }

  // ── AppBar: título ───────────────────────────────────────────────────────
  Widget _buildTitle(String? role, TenantViewModel tenantVM) {
    final String title;
    final String subtitle;

    if (role == 'director') {
      title    = tenantVM.currentTenant?.name ?? 'Cargando...';
      subtitle = 'Panel Director';
    } else {
      title    = 'Admin Panel';
      subtitle = 'Super Administrador';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ── Bottom nav ───────────────────────────────────────────────────────────
  Widget _buildBottomNav(List<_NavTab> tabs) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: List.generate(tabs.length, (i) {
              final tab    = tabs[i];
              final active = selectedIndex == i;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => selectedIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: active ? _purpleSoft : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            active ? tab.activeIcon : tab.icon,
                            key: ValueKey(active),
                            size: 22,
                            color: active ? _purple : _gray400,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w400,
                            color: active ? _purple : _gray400,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width:  active ? 4 : 0,
                          height: active ? 4 : 0,
                          decoration: const BoxDecoration(
                            color: _purple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ── Logout ───────────────────────────────────────────────────────────────
  Future<void> _showLogoutDialog(BuildContext ctx, AuthViewModel auth) async {
    final confirm = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      auth.logout();
      Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    return p[0].isNotEmpty ? p[0][0].toUpperCase() : '?';
  }
}

// ── Modelo de tab ─────────────────────────────────────────────────────────────
class _NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavTab(this.icon, this.activeIcon, this.label);
}