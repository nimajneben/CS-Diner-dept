import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manju_three/Manager/manager_approval.dart';
import 'package:manju_three/Manager/manager_decision.dart'; 
import 'package:manju_three/Manager/dispute_verdict.dart'; 

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MANJU Ramen Shop'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade100,
        elevation: 5.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text('Hi, Manager', style: TextStyle(fontSize: 24)),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Customer Management'),
                  subtitle: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    children: <Widget>[
                      _buildGridItem('Customer Registration', context),
                      _buildGridItem('De-register customers', context),
                      _buildGridItem('Compliments', context),
                      _buildGridItem('Complaints', context), 
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Staff Management'),
                  subtitle: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    children: <Widget>[
                      _buildGridItem('Hire', context),
                      _buildGridItem('Fire', context),
                      _buildGridItem('Manage Salary', context),
                      _buildGridItem('Promote', context),
                      _buildGridItem('Demote', context),
                      _buildGridItem('Dispute Verdict', context), 
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == 'Customer Registration') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagerApproval()),
          );
        } else if (title == 'Complaints') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagerDecision()), 
          );
        } else if (title == 'Dispute Verdict') { // Navigate to the DisputeVerdict screen when this option is selected
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DisputeVerdict()),
          );
        } else {
          print('$title clicked');
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
