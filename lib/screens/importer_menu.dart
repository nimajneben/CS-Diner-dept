import 'package:flutter/material.dart';
import 'package:manju_three/screens/importer_import_screen.dart';
import 'package:manju_three/screens/complaints_screen.dart';
import 'package:manju_three/screens/importer_ingredients_view.dart';

class ImporterMainScreen extends StatefulWidget {
  const ImporterMainScreen({super.key, required this.title});
  final String title;

  @override
  State<ImporterMainScreen> createState() => _ImporterMainScreenState();
}

class _ImporterMainScreenState extends State<ImporterMainScreen> {
  int currentPageIndex = 0;
  String profileName = 'User';

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
          title: Text('Hi, Importer $profileName'),
        ),
        body: GridView.count(
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
                          child: Center(child: Text('Food Purchases')))),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder:
                            (context) => const ImporterImportScreen()));
                  }),
              InkWell(
                  child: const Card(
                      child: SizedBox(
                          width: cardWidth,
                          height: cardHeight,
                          child: Center(child: Text('Query Inventory')))),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder:
                            (context) => const ImporterIngredientsView()));
                  }),
              InkWell(
                child: const Card(
                  child: SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: Center(child: Text('View Complaints'))),
                ),
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) => const ComplaintScreen()));
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
            ]));
  }
}
