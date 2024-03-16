import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_management/controllers/patient_controller.dart';
import 'package:patient_management/models/patient_records.dart';
import 'package:patient_management/widgets/custom_appbar.dart';
import 'package:patient_management/widgets/custom_button.dart';

class AddPatientRecords extends StatelessWidget {
  AddPatientRecords({super.key});

  final Records? records = Get.arguments != null ? Get.arguments[0] : null;
  final String type = Get.arguments != null ? Get.arguments[1] : 'Add';
  final String id = Get.arguments != null ? Get.arguments[2] : null;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientController>(builder: (controller) {
      return Scaffold(
        appBar: customAppbar('$type Patient Records'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    controller.selectDate(context);
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFD9D9D9),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: controller.selectedDate),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: !controller.patientLoading,
                  controller: controller.bpController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD9D9D9),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Blood Pressure (mmHg)'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: !controller.patientLoading,
                  controller: controller.rrController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD9D9D9),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Respiratory Rate (X/min)'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: !controller.patientLoading,
                  controller: controller.boController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD9D9D9),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Blood Oxygen Rate (X%)'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  enabled: !controller.patientLoading,
                  controller: controller.hrController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD9D9D9),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Heartbeat Rate (X / min)'),
                ),
                const SizedBox(height: 30),
                CustomButton(
                    loading: controller.patientLoading,
                    onPressed: () {
                      if (type == 'Edit') {
                        controller.editPatientRecord(
                            id, records!.id.toString());
                      } else {
                        controller.addPatientRecord(id);
                      }
                    },
                    label: '$type Clinical Record'),
              ],
            ),
          ),
        ),
      );
    });
  }
}
