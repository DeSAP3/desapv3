import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DengueCaseCard extends StatelessWidget {
  final String dCaseID;
  final String patientName;
  final int patientAge;
  final DateTime dateRPD;
  final String officerName;
  final String status;

  const DengueCaseCard({
    super.key,
    required this.dCaseID,
    required this.patientName,
    required this.patientAge,
    required this.dateRPD,
    required this.officerName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dengue ID: $dCaseID", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text("Patient Name: $patientName",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text("Patient Age: $patientAge",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text("Date Reported: $dateRPD",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text("Officer Report: $officerName",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text("Status: $status",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
