import 'package:flutter/material.dart';
import 'receipt.dart'; // Import the Receipt widget

class ManagerComplaints extends StatefulWidget {
  const ManagerComplaints({super.key});

  @override
  State<ManagerComplaints> createState() => _ManagerComplaintsState();
}

class _ManagerComplaintsState extends State<ManagerComplaints> {
  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'Customer';
  String _selectedAddress = 'Customer';
  String _selectedAddress2 = 'Customer'; // New dropdown

  // Create TextEditingController objects
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the TextEditingController objects
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(), // Set the lastDate to current date
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
        ));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        backgroundColor: Colors.white ,
        body: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xff1D1617).withOpacity(0.11),
                          blurRadius: 40,
                          spreadRadius: 0.0
                      )
                    ]
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30), // Increase the height here
              Container(
                margin: EdgeInsets.only(left: 20, right: 20), // Adjust the margin here
                child: GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Select Date',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      initialValue: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30), // Add space
              Container(
                margin: EdgeInsets.only(left: 20, right: 20), // Adjust the margin here
                child: DropdownButtonFormField<String>(
                  value: _selectedAddress2,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAddress2 = newValue!;
                    });
                  },
                  items: <String>['Customer', 'Manager', 'Chef', 'Importer', 'Delivery']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30), // Add space
              Text(
                'Complain Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20), // Adjust the top margin here
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xff1D1617).withOpacity(0.11),
                          blurRadius: 40,
                          spreadRadius: 0.0
                      )
                    ]
                ),
                child: TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30), // Add space
              Container(
                margin: EdgeInsets.only(left: 20, right: 20), // Adjust the margin here
                child: DropdownButtonFormField<String>(
                  value: _selectedAddress,
                  decoration: InputDecoration(
                    labelText: 'Address Complain To',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAddress = newValue!;
                    });
                  },
                  items: <String>['Customer', 'Manager', 'Chef', 'Importer', 'Delivery']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30), // Add space
              Container(
                margin: EdgeInsets.only(left: 20, right: 20), // Adjust the margin here
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xff1D1617).withOpacity(0.11),
                          blurRadius: 40,
                          spreadRadius: 0.0
                      )
                    ]
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 10, // Increase maxLines for larger input field
                  decoration: InputDecoration(
                    labelText: 'Please describe the incident in detail',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30), // Add space
              Container(
                height: 60, // Increase the height of the button
                margin: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10), // Adjust the margin here
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _locationController.text.isEmpty ||
                        _descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all the fields')),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => receipt(
                          name: _nameController.text,
                          date: _selectedDate,
                          location: _locationController.text,
                          address: _selectedAddress,
                          address2: _selectedAddress2, // New field
                          description: _descriptionController.text,
                        )),
                      );
                    }
                  },
                  child: Text('Submit', style: TextStyle(fontSize: 20)), // Increase the font size of the button text
                ),
              ),
            ],
          ),
        )
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Complaint Form',
        style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1.0,
      centerTitle: true,
    );
  }
}
