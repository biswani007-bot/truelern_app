import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router/route_paths.dart';

/// Parent Account Settings Screen — PURE STATIC FRONTEND ONLY.
///
/// Figma Source of Truth: `Parent(full app)_TreLern`
/// Frame Name: `Account Settings` (Node `76:1485`, 390xAuto)
///
/// Complete Figma Reproductions:
/// - Exact gradient background: linear-gradient(136.5deg, #F3E8FF, #E0F2FE, #FFFFFF)
/// - Top App Bar with back button and centered "Account Settings" (24px Bold #191C1E)
/// - Profile Header with 96x96 circular avatar, #FAF8FF 4px border, #0037B1 edit pencil badge,
///   "PPs" name (20px SemiBold #1A1B23) and "Student Account" (14px Regular #434655)
/// - PERSONAL section: Name ("PPs Mercher"), Email ("alex@rivers.com"), WhatsApp ("+1 (555) 123-4567")
/// - PREFERENCES section: Notifications (active toggle switch), Language ("English"), Timezone ("GMT-5")
/// - SECURITY section: Login Methods ("WhatsApp, Email")
/// - ACCOUNT section: Privacy Policy
/// - Destructive Actions: "Sign Out" bordered white card and "Delete Account" red text button
/// - Note from Figma: BottomNavBar is suppressed on this screen.
///
/// STRICT RULES:
/// - Zero backend calls / Zero API calls / Zero network requests
/// - Static frontend only
class ParentAccountSettingsScreen extends StatefulWidget {
  const ParentAccountSettingsScreen({super.key});

  @override
  State<ParentAccountSettingsScreen> createState() =>
      _ParentAccountSettingsScreenState();
}

class _ParentAccountSettingsScreenState
    extends State<ParentAccountSettingsScreen> {
  // Local state for Notifications toggle switch (Node 76:1556)
  bool _notificationsEnabled = true;

  // Assets extracted directly from Figma Node 76:1485
  static const _avatarImg = 'assets/images/account_avatar.png';
  static const _svgBack = 'assets/icons/account_back.svg';
  static const _svgEditPencil = 'assets/icons/account_edit_pencil.svg';
  static const _svgNameUser = 'assets/icons/account_name_user.svg';
  static const _svgChevronRight = 'assets/icons/account_chevron_right.svg';
  static const _svgEmail = 'assets/icons/account_email.svg';
  static const _svgWhatsapp = 'assets/icons/account_whatsapp.svg';
  static const _svgNotifications = 'assets/icons/account_notifications.svg';
  static const _svgLanguage = 'assets/icons/account_language.svg';
  static const _svgTimezone = 'assets/icons/account_timezone.svg';
  static const _svgLoginMethods = 'assets/icons/account_login_methods.svg';
  static const _svgPrivacy = 'assets/icons/account_privacy.svg';
  static const _svgSignOut = 'assets/icons/account_sign_out.svg';
  static const _svgDelete = 'assets/icons/account_delete.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('parent_account_settings_screen'),
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.8, -0.8),
            end: Alignment(0.8, 0.8),
            colors: [
              Color(0xFFF3E8FF), // rgb(243, 232, 255) - lavender
              Color(0xFFE0F2FE), // rgb(224, 242, 254) - light sky blue
              Color(0xFFFFFFFF), // rgb(255, 255, 255) - white
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Top App Bar (Node 76:1486) ─────────────────────────
              _buildTopAppBar(context),

              // ── Scrollable Body ─────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  key: const Key('account_settings_scroll_view'),
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 896),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Profile Header (Node 76:1493) ───────────────
                          _buildProfileHeader(),

                          const SizedBox(height: 24),

                          // ── PERSONAL Section (Node 76:1505) ──────────────
                          _buildSectionHeader('PERSONAL'),
                          const SizedBox(height: 12),
                          _buildPersonalCard(),

                          const SizedBox(height: 24),

                          // ── PREFERENCES Section (Node 76:1545) ───────────
                          _buildSectionHeader('PREFERENCES'),
                          const SizedBox(height: 12),
                          _buildPreferencesCard(),

                          const SizedBox(height: 24),

                          // ── SECURITY Section (Node 76:1583) ──────────────
                          _buildSectionHeader('SECURITY'),
                          const SizedBox(height: 12),
                          _buildSecurityCard(context),

                          const SizedBox(height: 24),

                          // ── ACCOUNT Section (Node 76:1599) ───────────────
                          _buildSectionHeader('ACCOUNT'),
                          const SizedBox(height: 12),
                          _buildAccountCard(context),

                          const SizedBox(height: 12),

                          // ── Destructive Actions (Node 76:1612) ───────────
                          _buildDestructiveActions(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Top App Bar (Node 76:1486)
  /// Height 64px, rgba(250,248,255,0.8) with backdrop shadow, back button on left, centered title.
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xCCFAF8FF), // rgba(250, 248, 255, 0.8)
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000), // 0px 1px 2px rgba(0,0,0,0.05)
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered Title (Node 76:1490/76:1491)
          Center(
            child: Text(
              'Account Settings',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF191C1E),
                height: 32 / 24,
              ),
            ),
          ),

          // Left Back Button (Node 76:1487/76:1488)
          Positioned(
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('account_settings_back_button'),
                borderRadius: BorderRadius.circular(9999),
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    _svgBack,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Profile Header (Node 76:1493)
  /// Avatar 96x96 with border and edit pencil badge, "PPs" name, "Student Account" label.
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar with Edit Badge (Node 76:1498)
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Avatar Image Container (Node 76:1500)
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFAF8FF),
                    width: 4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000), // rgba(0,0,0,0.1)
                      blurRadius: 15,
                      offset: Offset(0, 10),
                      spreadRadius: -3,
                    ),
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    _avatarImg,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Edit Pencil Button (Node 76:1501)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0037B1), // Primary brand blue
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                        spreadRadius: -1,
                      ),
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      _svgEditPencil,
                      width: 13.5,
                      height: 13.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Name "PPs" (Node 76:1494/76:1495)
          Text(
            'PPs',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1B23),
              height: 28 / 20,
            ),
          ),

          const SizedBox(height: 4),

          // Label "Student Account" (Node 76:1496/76:1497)
          Text(
            'Student Account',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF434655),
              height: 20 / 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Header (Node 76:1506, 76:1546, 76:1584, 76:1600)
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: GoogleFonts.hankenGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF434655),
          letterSpacing: 0.7,
          height: 20 / 14,
        ),
      ),
    );
  }

  /// PERSONAL Section Card (Node 76:1508)
  /// Name, Email, WhatsApp rows.
  Widget _buildPersonalCard() {
    return _buildCardContainer(
      children: [
        // Name Row (Node 76:1509)
        _buildSettingsRow(
          iconBg: const Color(0x33DCE1FF), // rgba(220, 225, 255, 0.2)
          iconSvg: _svgNameUser,
          iconWidth: 16,
          iconHeight: 16,
          label: 'Name',
          value: 'PPs Mercher',
          showChevron: true,
          showDivider: true,
        ),

        // Email Row (Node 76:1521)
        _buildSettingsRow(
          iconBg: const Color(0x33DCE1FF), // rgba(220, 225, 255, 0.2)
          iconSvg: _svgEmail,
          iconWidth: 20,
          iconHeight: 16,
          label: 'Email',
          value: 'alex@rivers.com',
          showChevron: true,
          showDivider: true,
        ),

        // WhatsApp Row (Node 76:1533)
        _buildSettingsRow(
          iconBg: const Color(0x3322D3EE), // rgba(34, 211, 238, 0.2)
          iconSvg: _svgWhatsapp,
          iconWidth: 15,
          iconHeight: 22,
          label: 'WhatsApp',
          value: '+1 (555) 123-4567',
          showChevron: true,
          showDivider: false,
        ),
      ],
    );
  }

  /// PREFERENCES Section Card (Node 76:1548)
  /// Notifications (toggle), Language, Timezone.
  Widget _buildPreferencesCard() {
    return _buildCardContainer(
      children: [
        // Notifications Row (Node 76:1549)
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _notificationsEnabled = !_notificationsEnabled;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Icon Box (Node 76:1551)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0x338A4CFC), // rgba(138, 76, 252, 0.2)
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        _svgNotifications,
                        width: 16,
                        height: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Title (Node 76:1555)
                  Expanded(
                    child: Text(
                      'Notifications',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1B23),
                        height: 24 / 16,
                      ),
                    ),
                  ),

                  // Toggle Switch (Node 76:1556)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _notificationsEnabled
                          ? const Color(0xFF0037B1) // Figma blue
                          : const Color(0xFFC4C5D7),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Align(
                      alignment: _notificationsEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const Divider(height: 1, thickness: 1, color: Color(0xFFE8E7F3)),

        // Language Row (Node 76:1559)
        _buildActionRow(
          iconBg: const Color(0xFFE8E7F3),
          iconSvg: _svgLanguage,
          iconWidth: 20,
          iconHeight: 20,
          title: 'Language',
          trailingText: 'English',
          showDivider: true,
        ),

        // Timezone Row (Node 76:1571)
        _buildActionRow(
          iconBg: const Color(0x334F46E5), // rgba(79, 70, 229, 0.2)
          iconSvg: _svgTimezone,
          iconWidth: 20,
          iconHeight: 20,
          title: 'Timezone',
          trailingText: 'GMT-5',
          showDivider: false,
        ),
      ],
    );
  }

  /// SECURITY Section Card (Node 76:1586)
  Widget _buildSecurityCard(BuildContext context) {
    return _buildCardContainer(
      children: [
        _buildSettingsRow(
          iconBg: const Color(0xFFE8E7F3),
          iconSvg: _svgLoginMethods,
          iconWidth: 23,
          iconHeight: 12,
          label: 'Login Methods',
          value: 'WhatsApp, Email',
          showChevron: true,
          showDivider: false,
          onTap: () => context.push(AppRoutePaths.parentLoginMethods),
        ),
      ],
    );
  }

  /// ACCOUNT Section Card (Node 76:1602)
  Widget _buildAccountCard(BuildContext context) {
    return _buildCardContainer(
      children: [
        _buildActionRow(
          iconBg: const Color(0xFFE8E7F3),
          iconSvg: _svgPrivacy,
          iconWidth: 16,
          iconHeight: 20,
          title: 'Privacy Policy',
          showDivider: false,
          onTap: () => context.push(AppRoutePaths.parentSecurityPrivacy),
        ),
      ],
    );
  }

  /// Destructive Actions (Node 76:1612)
  /// "Sign Out" button (Node 76:1613) and "Delete Account" button (Node 76:1617)
  Widget _buildDestructiveActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Sign Out Button (Node 76:1613)
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              key: const Key('account_settings_sign_out_button'),
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showSignOutDialog(context),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFFDAD6),
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000), // 0px 1px 1px rgba(0,0,0,0.05)
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      _svgSignOut,
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFBA1A1A),
                        height: 24 / 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Delete Account Button (Node 76:1617)
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: const Key('account_settings_delete_account_button'),
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showDeleteAccountDialog(context),
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      _svgDelete,
                      width: 16,
                      height: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Delete Account',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xB3BA1A1A), // rgba(186, 26, 26, 0.7)
                        height: 24 / 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card container matching Figma's glassmorphism style:
  /// rgba(255, 255, 255, 0.9), border rgba(255, 255, 255, 0.5), radius 16px, shadow 0px 4px 20px rgba(0,0,0,0.04).
  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xE6FFFFFF), // rgba(255, 255, 255, 0.9)
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0x80FFFFFF), // rgba(255, 255, 255, 0.5)
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  /// Row with Label + Bold Value (Name, Email, WhatsApp, Login Methods)
  Widget _buildSettingsRow({
    required Color iconBg,
    required String iconSvg,
    required double iconWidth,
    required double iconHeight,
    required String label,
    required String value,
    required bool showChevron,
    required bool showDivider,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Icon Box
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        iconSvg,
                        width: iconWidth,
                        height: iconHeight,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Label + Value
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF434655),
                            height: 20 / 14,
                          ),
                        ),
                        Text(
                          value,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1B23),
                            height: 24 / 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chevron Right (Node 76:1519)
                  if (showChevron)
                    SvgPicture.asset(
                      _svgChevronRight,
                      width: 7.4,
                      height: 12,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E7F3)),
      ],
    );
  }

  /// Single-line action row (Language, Timezone, Privacy Policy)
  Widget _buildActionRow({
    required Color iconBg,
    required String iconSvg,
    required double iconWidth,
    required double iconHeight,
    required String title,
    String? trailingText,
    required bool showDivider,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Icon Box
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        iconSvg,
                        width: iconWidth,
                        height: iconHeight,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Title
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1B23),
                        height: 24 / 16,
                      ),
                    ),
                  ),

                  // Trailing text if present
                  if (trailingText != null) ...[
                    Text(
                      trailingText,
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF434655),
                        height: 20 / 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Chevron Right
                  SvgPicture.asset(
                    _svgChevronRight,
                    width: 7.4,
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E7F3)),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Sign Out',
          style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to sign out of your account?',
          style: GoogleFonts.hankenGrotesk(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.hankenGrotesk(color: const Color(0xFF747686)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go(AppRoutePaths.login);
            },
            child: Text(
              'Sign Out',
              style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Account',
          style: GoogleFonts.hankenGrotesk(
            fontWeight: FontWeight.w700,
            color: const Color(0xFFBA1A1A),
          ),
        ),
        content: Text(
          'This action is irreversible. All your data and account information will be permanently removed.',
          style: GoogleFonts.hankenGrotesk(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.hankenGrotesk(color: const Color(0xFF747686)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Delete',
              style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
