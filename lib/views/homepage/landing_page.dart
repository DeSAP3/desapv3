import "package:desapv3/viewmodels/auth_notifier.dart";
import "package:desapv3/viewmodels/cup_viewmodel.dart";
import "package:desapv3/viewmodels/navigation_link.dart";
import "package:desapv3/reuseable_widget/app_drawer.dart";
import "package:desapv3/viewmodels/user_viewmodel.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:logger/logger.dart";
import 'package:fl_chart/fl_chart.dart';
import "package:provider/provider.dart";

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserViewModel>(context, listen: false).fetchCurrentUser();
      Provider.of<CupViewModel>(context, listen: false).fetchCups();
    });
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final logger = Logger();

  final List<FlSpot> chartData = [
    FlSpot(30, 25),
    FlSpot(31, 50),
    FlSpot(32, 78),
    FlSpot(33, 102),
    FlSpot(34, 150),
  ];

  @override
  Widget build(BuildContext context) {
    final cupProvider = Provider.of<CupViewModel>(context, listen: false);
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final userProvider = Provider.of<UserViewModel>(context, listen: false);

    userProvider.currentUser = authNotifier.user;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Dashboard Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              logger.d("Logging out");
              await userProvider.signOut(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 8),
                  ],
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toString(),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval:
                                1, // ensures spacing between whole numbers
                            getTitlesWidget: (value, meta) {
                              if (value % 1 == 0) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(fontSize: 12),
                                );
                              } else {
                                return const SizedBox
                                    .shrink(); // hide non-whole numbers
                              }
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: chartData,
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: EdgeInsets.all(8),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('Ovitraps Active',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text('3',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('Total Egg Count',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Consumer<CupViewModel>(
                            builder: (context, cupProvider, _) {
                              return Text("${cupProvider.calcTotalEgg()}",
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void toastErrorPopUp(String eMsg) {
    Fluttertoast.showToast(
        msg: eMsg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM_RIGHT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
        timeInSecForIosWeb: 2);
  }
}
