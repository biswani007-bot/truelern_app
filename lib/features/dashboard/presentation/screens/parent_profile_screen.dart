import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';

/// Parent Profile Screen — PURE FRONTEND PRESENTATION ONLY.
///
/// Figma Source of Truth: Parent(full app)_TreLern, Frame 76:1711.
///
/// STRICT RULES:
/// - NO backend calls. NO API fetches. NO ref.watch/listen.
/// - ALL data is statically from Figma Node 76:1711.
/// - Name: "PPs Mercer", Email: "alex.mercer@truelern.com"
/// - Account Overview: My Profile · My Child · Security & Privacy · Invoices
/// - Delete Account danger row.
/// - The ParentShellScreen provides the bottom navigation (single navbar).
///   This screen itself does NOT render any bottom nav.
class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  // ── Figma static data (Node 76:1726 / 76:1728) ────────────────────────────
  static const _name = 'PPs Mercer';
  static const _email = 'alex.mercer@truelern.com';

  // ── Menu items (Nodes 76:1742 → 76:1773) ────────────────────────────────
  static const _menuItems = [
    _MenuItem(label: 'My Profile', icon: Icons.person_outline_rounded),
    _MenuItem(label: 'My Child', icon: Icons.child_care_rounded),
    _MenuItem(label: 'Security & Privacy', icon: Icons.lock_outline_rounded),
    _MenuItem(label: 'Invoices', icon: Icons.receipt_long_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('parent_profile_screen'),
      // No AppBar here — the shell screen suppresses its AppBar for this tab
      // and we build a custom one embedded in the body below.
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        key: const Key('profile_scroll_view'),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero Header Area (Node 76:1712) ──────────────────────────
            _buildHeroHeader(context),

            // ── Main Content Surface (Node 76:1735/76:1736) ──────────────
            _buildContentSurface(context),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Hero Header — dark gradient background (#0F172A → #1E3A8A),
  /// TopAppBar, avatar circle with edit badge, name and email.
  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 96),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F172A), // #0F172A
            Color(0xFF1E3A8A), // #1E3A8A
          ],
        ),
      ),
      child: Column(
        children: [
          // TopAppBar row (Node 76:1714)
          _buildTopAppBar(context),

          const SizedBox(height: 24),

          // Avatar + name + email (Node 76:1723/1724)
          _buildAvatarBlock(),
        ],
      ),
    );
  }

  /// TopAppBar: hamburger left, "Profile" center (24px Bold white),
  /// edit button right (blue bg, pencil icon, rounded-8).
  Widget _buildTopAppBar(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hamburger — Node 76:1715
          InkWell(
            key: const Key('profile_menu_button'),
            borderRadius: BorderRadius.circular(999),
            onTap: () => Scaffold.maybeOf(context)?.openDrawer(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 15),
              child: _HamburgerIcon(color: Colors.white),
            ),
          ),

          // "Profile" title — Node 76:1718/76:1719
          Text(
            'Profile',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 32 / 24,
            ),
          ),

          // Edit button — Node 76:1720 (blue bg, pencil icon)
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            decoration: BoxDecoration(
              color: const Color(0x660037B1), // rgba(0,55,177,0.4)
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Avatar block: circular photo with white border, blue edit badge,
  /// name below, email below that.
  Widget _buildAvatarBlock() {
    return Column(
      children: [
        // Avatar container (Node 76:1729/76:1730)
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // White circle avatar (96×96)
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Container(
                  color: const Color(0xFFE2E8F0),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 52,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),

            // Blue edit badge (Node 76:1732) — bottom-right
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E4ED8),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 13,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Name — "PPs Mercer" (Node 76:1726) — 24px SemiBold white
        Text(
          _name,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 32 / 24,
          ),
        ),

        const SizedBox(height: 4),

        // Email (Node 76:1728) — 14px Regular white 80% opacity
        Text(
          _email,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.8),
            height: 20 / 14,
          ),
        ),
      ],
    );
  }

  /// White card surface overlapping the hero by 32px (Node 76:1736).
  /// Contains "Account Overview" heading, menu list card, and Delete Account row.
  Widget _buildContentSurface(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -32),
      child: Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A0F172A),
              blurRadius: 25,
              offset: Offset(0, 20),
            ),
            BoxShadow(
              color: Color(0x1A0F172A),
              blurRadius: 10,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Account Overview" heading (Node 76:1739/76:1740)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Account Overview',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                  height: 28 / 20,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Menu items card (Node 76:1741)
            _buildMenuCard(context),

            const SizedBox(height: 24),

            // Delete Account row (Node 76:1776)
            _buildDeleteAccountRow(context),
          ],
        ),
      ),
    );
  }

  /// White bordered card with 4 menu items and dividers between them.
  Widget _buildMenuCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0x4DC4C5D7), // rgba(196,197,215,0.3)
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A), // rgba(15,23,42,0.05)
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_menuItems.length, (index) {
          final item = _menuItems[index];
          final isLast = index == _menuItems.length - 1;
          return Column(
            children: [
              _buildMenuItem(context, item),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0x33C4C5D7), // rgba(196,197,215,0.2)
                  indent: 0,
                  endIndent: 0,
                ),
            ],
          );
        }),
      ),
    );
  }

  /// Single menu list item: icon left (in a rounded square bg),
  /// label (16px Medium #1F2937), chevron right.
  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return InkWell(
      key: Key('profile_menu_${item.label.toLowerCase().replaceAll(' ', '_')}'),
      onTap: () {
        if (item.label == 'My Child') {
          // Navigate to My Child screen
          GoRouter.of(context).go(AppRoutePaths.myChildren);
        } else if (item.label == 'Security & Privacy') {
          // Navigate to Security & Privacy screen
          GoRouter.of(context).push(AppRoutePaths.parentSecurityPrivacy);
        } else if (item.label == 'Invoices') {
          // Navigate to Invoices screen
          GoRouter.of(context).push(AppRoutePaths.parentInvoices);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.label} coming soon.'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Icon container (Figma shows a rounded square icon bg)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: const Color(0xFF475569),
              ),
            ),

            const SizedBox(width: 16),

            // Label
            Expanded(
              child: Text(
                item.label,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                  height: 24 / 16,
                ),
              ),
            ),

            // Chevron right (Node 76:1748 / similar)
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  /// Delete Account danger row (Node 76:1776).
  /// Background: rgba(255,218,214,0.2), border: rgba(255,218,214,0.5), radius 12.
  /// Red trash icon, "Delete Account" in red (#EF4444), chevron right.
  Widget _buildDeleteAccountRow(BuildContext context) {
    return InkWell(
      key: const Key('delete_account_button'),
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'This action is irreversible. Are you sure you want to delete your account?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0x33FFDAD6), // rgba(255,218,214,0.2)
          border: Border.all(
            color: const Color(0x80FFDAD6), // rgba(255,218,214,0.5)
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Red trash icon
            const Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: Color(0xFFEF4444),
            ),

            const SizedBox(width: 16),

            // "Delete Account" label
            Expanded(
              child: Text(
                'Delete Account',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFEF4444),
                  height: 24 / 16,
                ),
              ),
            ),

            // Chevron right (also red in Figma)
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFFEF4444),
            ),
          ],
        ),
      ),
    );
  }
}

/// Menu item descriptor.
class _MenuItem {
  const _MenuItem({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

/// Custom hamburger/menu icon (3 horizontal lines) — matching Figma Node 76:1716.
class _HamburgerIcon extends StatelessWidget {
  const _HamburgerIcon({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Line(color: color),
          _Line(color: color, width: 14),
          _Line(color: color),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.color, this.width = 18});
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1.5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
