import 'dart:convert';
import 'package:first_project/components/records_card.dart';
import 'package:first_project/models/records_model.dart';
import 'package:first_project/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen>
    with SingleTickerProviderStateMixin {
  List<MedicalRecord> records = [];
  String? _selectedBloodType;
  bool _isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String get _userEmail =>
      Provider.of<AuthProvider>(context, listen: false).userEmail;

  /// Per-user keys so each account has its own data
  String get _recordsKey => 'medical_records_$_userEmail';
  String get _bloodTypeKey => 'blood_type_$_userEmail';

  static const List<String> _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    // We need context for _userEmail, so defer loading.
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ── Data persistence ──────────────────────────────────────────────────

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Blood type
      final bt = prefs.getString(_bloodTypeKey);

      // Records
      final recordsJson = prefs.getStringList(_recordsKey);
      final loaded = <MedicalRecord>[];
      if (recordsJson != null && recordsJson.isNotEmpty) {
        loaded.addAll(recordsJson.map((jsonStr) {
          final map = json.decode(jsonStr);
          return MedicalRecord(
            icon: Icons.description,
            title: map['title'],
            subtitle: map['subtitle'],
          );
        }));
      }

      if (mounted) {
        setState(() {
          _selectedBloodType = bt;
          records = loaded;
          _isLoading = false;
        });
        _fadeController.forward();
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = records
          .map((r) => json.encode({'title': r.title, 'subtitle': r.subtitle}))
          .toList();
      await prefs.setStringList(_recordsKey, encoded);
    } catch (_) {}
  }

  Future<void> _saveBloodType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bloodTypeKey, type);
    if (mounted) setState(() => _selectedBloodType = type);
  }

  // ── Record CRUD ───────────────────────────────────────────────────────

  void _deleteRecord(int index) {
    setState(() => records.removeAt(index));
    _saveRecords();
  }

  void _showCardOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title:
                    Text("Edit Record", style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showRecordFormDialog(index: index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title:
                    Text("Delete Record", style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(ctx);
                  _deleteRecord(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRecordFormDialog({int? index}) {
    final bool isEditing = index != null;
    final titleController = TextEditingController(
        text: isEditing ? records[index].title : '');
    final resultController = TextEditingController(
        text: isEditing ? records[index].subtitle : '');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? "Edit Record" : "Add New Record",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText:
                        "Type of Information (e.g. Doctor visits)",
                    labelStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: resultController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Actual Result",
                    labelStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          resultController.text.isNotEmpty) {
                        setState(() {
                          final newRecord = MedicalRecord(
                            icon: Icons.description,
                            title: titleController.text,
                            subtitle: resultController.text,
                          );
                          if (isEditing) {
                            records[index] = newRecord;
                          } else {
                            records.add(newRecord);
                          }
                        });
                        _saveRecords();
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Confirm",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Blood-type picker ─────────────────────────────────────────────────

  void _showBloodTypePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final primaryColor = Theme.of(context).colorScheme.primary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Blood Type",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _bloodTypes.map((type) {
                  final isSelected = _selectedBloodType == type;
                  return GestureDetector(
                    onTap: () {
                      _saveBloodType(type);
                      Navigator.pop(ctx);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor
                            : (isDark
                                ? const Color(0xFF334155)
                                : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : (isDark
                                  ? const Color(0xFF475569)
                                  : Colors.grey.shade300),
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color:
                                        primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    spreadRadius: 1)
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : textColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor =
        isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context)),
        title: Text("Records",
            style:
                TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: textColor, size: 28),
              onPressed: () => _showRecordFormDialog()),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileHeader(
                        textColor, subTextColor, isDark),
                    const SizedBox(height: 30),
                    if (records.isEmpty)
                      _buildEmptyState(textColor, subTextColor, isDark)
                    else
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount: records.length,
                          itemBuilder: (context, index) =>
                              GestureDetector(
                            onTap: () => _showCardOptions(index),
                            child: RecordCard(record: records[index]),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  // ── Profile header (dynamic name + avatar + blood type picker) ────────

  Widget _buildProfileHeader(
      Color textColor, Color subTextColor, bool isDark) {
    final authProvider = Provider.of<AuthProvider>(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final userName = authProvider.userName.isNotEmpty
        ? authProvider.userName
        : 'User';

    return Column(
      children: [
        // Avatar
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 55,
            backgroundImage: AssetImage(
                'images/WhatsApp Image 2026-03-08 at 2.15.02 AM.jpeg'),
          ),
        ),
        const SizedBox(height: 15),

        // Name
        Text(userName,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor)),
        const SizedBox(height: 8),

        // Blood type chip – tappable
        GestureDetector(
          onTap: _showBloodTypePicker,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _selectedBloodType != null
                  ? primaryColor.withValues(alpha: 0.12)
                  : (isDark
                      ? const Color(0xFF334155)
                      : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _selectedBloodType != null
                    ? primaryColor.withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.water_drop_rounded,
                    size: 18,
                    color: _selectedBloodType != null
                        ? Colors.redAccent
                        : subTextColor),
                const SizedBox(width: 6),
                Text(
                  _selectedBloodType != null
                      ? "Blood Type: $_selectedBloodType"
                      : "Select Blood Type",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _selectedBloodType != null
                        ? textColor
                        : subTextColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 20, color: subTextColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Empty state illustration ──────────────────────────────────────────

  Widget _buildEmptyState(
      Color textColor, Color subTextColor, bool isDark) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.folder_open_rounded,
                  size: 56, color: primaryColor.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 24),
            Text("No Records Yet",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            const SizedBox(height: 8),
            Text(
              "Tap the + button to add your first\nmedical record.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: subTextColor, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}