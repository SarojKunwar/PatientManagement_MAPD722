import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_management/controllers/patient_controller.dart';
import 'package:patient_management/models/patient.dart';
import 'package:patient_management/models/patient_records.dart';
import 'package:patient_management/routes.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:patient_management/utils/base_url.dart';
import 'package:patient_management/utils/critical.dart';

class SinglePatient extends StatelessWidget {
  SinglePatient({super.key});

  Patient patient = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Patient - ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              TextSpan(
                text: !isCritical(patient.records!) ? 'Normal' : 'Critical',
                style: TextStyle(
                  color:
                      !isCritical(patient.records!) ? Colors.green : Colors.red,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: GetBuilder<PatientController>(builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          patient.image!.substring(0, 4) == "http"
                              ? patient.image!
                              : imgUrl + patient.image!,
                          fit: BoxFit.cover,
                          height: 120,
                          width: 120,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GENERAL - ${patient.ward}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            Text(
                              patient.name!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'DOB:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${patient.dob}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Sex:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${patient.gender}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Address:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${patient.address}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  patient.description!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Clinical History',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(GetRoutes.addPatientRecords,
                            arguments: [null, 'Add', patient.id.toString()]);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x30000000),
                              blurRadius: 7.90,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Text(
                          '+',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                if (controller.patientLoading &&
                    controller.patientRecords.isEmpty)
                  const CircularProgressIndicator(),
                if (!controller.patientLoading)
                  ...controller.patientRecords.map(
                    (e) => Column(
                      children: [
                        Slidable(
                          endActionPane: ActionPane(
                            openThreshold: 0.4,
                            extentRatio: 0.7,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (a) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          title: const Text(
                                              'Delete Patient? Records'),
                                          content: const Text(
                                              'Are you sure you want to delete this patient records?'),
                                          actions: [
                                            ElevatedButton(
                                              child: const Text('Yes'),
                                              onPressed: () async {
                                                controller.deletePatientRecords(
                                                    e.id.toString(), context);
                                              },
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            )
                                          ],
                                        );
                                      });
                                },
                                backgroundColor: const Color(0xFFff0000),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                flex: 1,
                              ),
                              SlidableAction(
                                onPressed: (a) {
                                  controller.prefillRecordsFields(e);
                                  Get.toNamed(GetRoutes.addPatientRecords,
                                      arguments: [
                                        e,
                                        'Edit',
                                        patient.id.toString()
                                      ]);
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 240, 168, 12),
                                foregroundColor: Colors.black,
                                icon: Icons.edit,
                                label: 'Edit',
                                flex: 1,
                              ),
                            ],
                          ),
                          child: PatientRecordsCard(records: e),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class PatientRecordsCard extends StatelessWidget {
  const PatientRecordsCard({super.key, required this.records});

  final Records records;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 7.90,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMM dd, yyyy').format(records.date!),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Blood Pressure: ${records.bloodPressure} mmHg',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Respiratory Rate: ${records.respiratoryRate} / min',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Blood Oxygen Rate: ${records.bloodOxygen}%',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Heartbeat Rate: ${records.heartBeat} / min',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
