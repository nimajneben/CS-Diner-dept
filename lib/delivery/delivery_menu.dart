import 'package:flutter/material.dart';
import 'package:manju_three/delivery/delivery_orders.dart';
import 'package:manju_three/pages/surfer_home.dart';
import 'package:manju_three/Importer/complaints_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

// TODO: Retreive Username
// String _getUserName() {
//   String un = 'Username';
//   var snapshot =
//       DatabaseFunctions().getChefName(FirebaseAuth.instance.currentUser!.uid);
//   snapshot.then(
//     (value) {
//       un = value.;
//     },
//   );
//   return un;
// }

class DeliveryMainScreen extends StatefulWidget {
  const DeliveryMainScreen({super.key});

  @override
  State<DeliveryMainScreen> createState() => _DeliveryMainScreenState();
}

class _DeliveryMainScreenState extends State<DeliveryMainScreen> {
  int currentPageIndex = 0;

  static const double cardHeight = 100.0;
  static const double cardWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        // Navigation bar
        bottomNavigationBar: NavigationBar(
          destinations: const <Widget>[
            NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: 'Dashboard'),
            NavigationDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person),
                label: 'Profile')
          ],
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
        ),
        appBar: AppBar(
          title: Text('Hi, Deliveryperson Username'),
        ),
        body: <Widget>[
          GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                InkWell(
                    child: const Card(
                        child: SizedBox(
                            width: cardWidth,
                            height: cardHeight,
                            child: Center(child: Text('View Pending Orders')))),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DeliveryOrderScreen()));
                    }),
                InkWell(
                    child: const Card(
                      child: SizedBox(
                          width: cardWidth,
                          height: cardHeight,
                          child: Center(child: Text('View Complaints'))),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ComplaintScreen()));
                    }),
                const Card(
                    child: SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: Center(child: Text('Complaint Form')))),
                const Card(
                    child: SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: Center(child: Text('Dispute Complaints')))),
              ]),
          Center(
              child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("images/profile1.jpg"),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Name: ${'John Doe'}",
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Email: ${'john@johm.com'}",
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text('Sign Out'),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SurferHome()),
                      (route) => false);
                },
              )
            ],
          ))
        ][currentPageIndex]);
  }
}
