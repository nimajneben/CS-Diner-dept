import 'package:flutter/material.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> with SingleTickerProviderStateMixin{
  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Pending'),
    Tab(text: 'Under Review'),
    Tab(text: 'Closed')
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Complaints'),
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs,
          )
      )

      ,
    );
  }
}
