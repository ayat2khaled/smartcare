import 'dart:convert';
import 'package:first_project/components/records_card.dart';
import 'package:first_project/models/records_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  List<MedicalRecord> records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recordsJson = prefs.getStringList('medical_records');
      
      if (recordsJson != null && recordsJson.isNotEmpty) {
        setState(() {
          records.addAll(recordsJson.map((jsonStr) {
            final map = json.decode(jsonStr);
            return MedicalRecord(
              icon: Icons.description, 
              title: map['title'],
              subtitle: map['subtitle'],
            );
          }));
        });
      }
    } catch (_) {}
  }

  Future<void> _saveRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dynamicRecords = records.map((record) => json.encode({
        'title': record.title,
        'subtitle': record.subtitle,
      })).toList();
      await prefs.setStringList('medical_records', dynamicRecords);
    } catch (_) {}
  }

  void _deleteRecord(int index) {
    setState(() {
      records.removeAt(index);
    });
    _saveRecords();
  }

  void _showCardOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: Text("Edit Record", style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(context);
                  _showRecordFormDialog(index: index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text("Delete Record", style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(context);
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
    final titleController = TextEditingController(text: isEditing ? records[index ].title : '');
    final resultController = TextEditingController(text: isEditing ? records[index ].subtitle : '');
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEditing ? "Edit Record" : "Add New Record", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Type of Information (e.g. Doctor visits)",
                    labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: resultController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Actual Result",
                    labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty && resultController.text.isNotEmpty) {
                        setState(() {
                          final newRecord = MedicalRecord(
                            icon: Icons.description,
                            title: titleController.text,
                            subtitle: resultController.text,
                          );
                          if (isEditing) {
                            records[index ] = newRecord;
                          } else {
                            records.add(newRecord);
                          }
                        });
                        _saveRecords();
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Confirm", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor, elevation: 0, centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: textColor), onPressed: () => Navigator.pop(context)),
        title: Text("Records", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: Icon(Icons.add, color: textColor, size: 28), onPressed: () => _showRecordFormDialog()), const SizedBox(width: 8)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(textColor, subTextColor, isDark),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => _showCardOptions(index),
                  child: RecordCard(record: records[index]),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Color textColor, Color subTextColor, bool isDark) {
    return Column(
      children: [
        CircleAvatar(radius: 55, backgroundColor: isDark ? const Color(0xFF334155) : Colors.grey, backgroundImage: const AssetImage('صوره')),
        const SizedBox(height: 15),
        Text("Ahmed Hassan", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 4),
        //Text("Age: 35", style: TextStyle(fontSize: 16, color: subTextColor)),
        Text("Blood Type: A+", style: TextStyle(fontSize: 16, color: subTextColor)),
      ],
    );
  }
}