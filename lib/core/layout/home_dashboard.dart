import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/tenant_viewmodel.dart';

class HomeDashboard extends StatelessWidget {
  final void Function(int index) onNavigate;

  const HomeDashboard({super.key, required this.onNavigate});

  static const _purple = Color(0xFF4F46E5);
  static const _bgPage = Color(0xFFF5F7FB);

  @override
  Widget build(BuildContext context) {
    final auth     = Provider.of<AuthViewModel>(context);
    final tenantVM = Provider.of<TenantViewModel>(context);
    final role     = auth.role;
    final name     = auth.user?.name ?? '';

    // Nombre del colegio para el director, genérico para admin
    final schoolName = role == 'director'
        ? (tenantVM.currentTenant?.name ?? '')
        : 'Admin Panel';

    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Hero ──────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _purple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Logo del colegio o avatar con iniciales
                        _buildHeroLogo(role, tenantVM, name),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hola, ${name.split(' ').first}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                role == 'super-admin'
                                    ? 'Super Administrador'
                                    : 'Panel Director',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                              // Nombre del colegio solo para director
                              if (role == 'director' &&
                                  schoolName.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  schoolName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Container(height: 0.5, color: Colors.white.withOpacity(0.25)),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        _Chip(Icons.check_circle_outline, 'Sistema activo'),
                        const SizedBox(width: 8),
                        _Chip(Icons.wifi_rounded, 'En línea'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Super Admin ───────────────────────────────────────────
              if (role == 'super-admin') ...[
                const _SectionLabel('GESTIÓN DE COLEGIOS'),
                const SizedBox(height: 12),
                _RowCard(
                  icon: Icons.school_outlined,
                  label: 'Colegios registrados',
                  description: 'Ver, editar y eliminar colegios',
                  bgColor: const Color(0xFFEDE9FE),
                  iconColor: const Color(0xFF7C3AED),
                  onTap: () => onNavigate(1),
                ),
                const SizedBox(height: 10),
                _RowCard(
                  icon: Icons.add_business_outlined,
                  label: 'Crear nuevo colegio',
                  description: 'Registrar un colegio con su director',
                  bgColor: const Color(0xFFD1FAE5),
                  iconColor: const Color(0xFF059669),
                  onTap: () => onNavigate(2),
                ),
              ],

              // ── Director ──────────────────────────────────────────────
              if (role == 'director') ...[
                const _SectionLabel('GESTIÓN'),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _GridCard(
                      icon: Icons.menu_book_outlined,
                      label: 'Materias',
                      bgColor: const Color(0xFFEDE9FE),
                      iconColor: const Color(0xFF7C3AED),
                      onTap: () => onNavigate(1),
                    ),
                    _GridCard(
                      icon: Icons.person_outline,
                      label: 'Profesores',
                      bgColor: const Color(0xFFDBEAFE),
                      iconColor: const Color(0xFF2563EB),
                      onTap: () => onNavigate(2),
                    ),
                    _GridCard(
                      icon: Icons.class_outlined,
                      label: 'Cursos',
                      bgColor: const Color(0xFFD1FAE5),
                      iconColor: const Color(0xFF059669),
                      onTap: () => onNavigate(3),
                    ),
                    _GridCard(
                      icon: Icons.account_tree_outlined,
                      label: 'Paralelos',
                      bgColor: const Color(0xFFFEE2E2),
                      iconColor: const Color(0xFFDC2626),
                      onTap: () => onNavigate(4),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _RowCard(
                  icon: Icons.domain_outlined,
                  label: 'Mi Colegio',
                  description: 'Logo, nombre y configuración',
                  bgColor: const Color(0xFFFEF3C7),
                  iconColor: const Color(0xFFD97706),
                  onTap: () => onNavigate(5),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Logo del colegio en el hero card
  Widget _buildHeroLogo(
      String? role, TenantViewModel tenantVM, String name) {
    final logoUrl =
        role == 'director' ? tenantVM.currentTenant?.logoUrl : null;

    if (logoUrl != null && logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          logoUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _avatarFallback(name),
        ),
      );
    }
    return _avatarFallback(name);
  }

  Widget _avatarFallback(String name) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(name),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    return p[0].isNotEmpty ? p[0][0].toUpperCase() : '?';
  }
}

// ── Tarjeta fila completa ─────────────────────────────────────────────────────
class _RowCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _RowCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tarjeta grid 2×2 ──────────────────────────────────────────────────────────
class _GridCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _GridCard({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Ver todos',
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF4F46E5).withOpacity(0.8),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 9,
                      color: const Color(0xFF4F46E5).withOpacity(0.8),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets pequeños ──────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF9CA3AF),
        letterSpacing: 1.0,
      ),
    );
  }
}