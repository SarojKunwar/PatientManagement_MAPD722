import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:patient_management/controllers/patient_controller.dart';
import 'package:patient_management/models/patient.dart';
import 'package:patient_management/routes.dart';
import 'package:patient_management/utils/base_url.dart';
import 'package:patient_management/utils/critical.dart';
import 'package:patient_management/utils/shared_prefs.dart';
import 'package:patient_management/widgets/custom_appbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AllPatientsScreen extends StatelessWidget {
  AllPatientsScreen({super.key});

  final patientController = Get.put(PatientController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        'All Patients',
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                Get.toNamed(GetRoutes.addPatient);
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        title: const Text('Logout?'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          ElevatedButton(
                            child: const Text('Yes'),
                            onPressed: () async {
                              await SharedPrefs().removeUser();
                              Get.toNamed(GetRoutes.splash);
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No',
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      );
                    });
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
                  child: const Icon(Icons.logout)),
            ),
          ),
        ],
      ),
      body: GetBuilder<PatientController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (String val) {
                        controller.searchText = val;
                        controller.searchPatients(
                            val, controller.searchCondition);
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Search. . .'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFD9D9D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: DropdownButton(
                      underline: Container(),
                      value: controller.searchCondition,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: controller.conditions.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: TextStyle(
                              color: items == 'Select Condition'
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue == 'Select Condition') return;
                        controller.searchCondition = newValue!;
                        controller.searchPatients(
                            controller.searchText, newValue);
                        controller.update();
                      },
                    ),
                  ),
                  Visibility(
                    visible: controller.searchCondition != 'Select Condition' ||
                        controller.searchText.isNotEmpty,
                    child: InkWell(
                      onTap: () {
                        controller.searchCondition = 'Select Condition';
                        controller.searchText = '';
                        controller.searchPatients('', '');
                        controller.update();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.red,
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
                          'x',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: controller.patientLoading &&
                          controller.allPatients.isEmpty
                      ? const CircularProgressIndicator()
                      : Column(
                          children: controller.filteredPatients
                              .map((e) => Column(
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
                                                        backgroundColor:
                                                            Colors.white,
                                                        surfaceTintColor:
                                                            Colors.white,
                                                        title: const Text(
                                                            'Delete Patient?'),
                                                        content: const Text(
                                                            'Are you sure you want to delete this patient?'),
                                                        actions: [
                                                          ElevatedButton(
                                                            child: const Text(
                                                                'Yes'),
                                                            onPressed:
                                                                () async {
                                                              controller
                                                                  .deletePatient(
                                                                      e.id);
                                                            },
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'No',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              },
                                              backgroundColor:
                                                  const Color(0xFFff0000),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: 'Delete',
                                              flex: 1,
                                            ),
                                            SlidableAction(
                                              onPressed: (a) {
                                                controller.prefillFields(e);
                                                Get.toNamed(
                                                    GetRoutes.addPatient,
                                                    arguments: [e, 'Edit']);
                                              },
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 240, 168, 12),
                                              foregroundColor: Colors.black,
                                              icon: Icons.edit,
                                              label: 'Edit',
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                        child: PatientCard(patient: e),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class PatientCard extends StatelessWidget {
  const PatientCard({super.key, required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final patientController = Get.find<PatientController>();
        patientController.fetchAllPatientRecords(patient.id.toString());
        Get.toNamed(GetRoutes.singlePatient, arguments: patient);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    patient.image!.substring(0, 4) == "http"
                        ? patient.image!
                        : imgUrl + patient.image!,
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 8,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: !isCritical(patient.records!)
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'DOB: ${patient.dob}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Address: ${patient.address}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Ward: ${patient.ward}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
