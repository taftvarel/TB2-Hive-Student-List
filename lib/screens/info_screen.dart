import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:contoh_hive/model/person.dart';
import 'package:contoh_hive/screens/update_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:contoh_hive/utils/add_person_form.dart';
import 'package:contoh_hive/utils/update_person_form.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final Box contactBox;

  _deleteInfo(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this student?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('NO'),
            ),
            TextButton(
              onPressed: () {
                contactBox.deleteAt(index);
                Navigator.of(context).pop();
                print('Item deleted from box at index:$index');
              },
              child: Text('YES'),
            ),
          ],
        );
      },
    );
  }

  _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          title: Text('Create Student'),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          content: Container(
            width: screenWidth * 1.0,
            height: 200.0,
            child: AddPersonForm(),
          ),
        );
      },
    );
  }

  _showEditDialog(BuildContext context, int index, Person personData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          title: Text('Edit Student Information'),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          content: Container(
            width: screenWidth * 1.0,
            height: 340.0,
            child: UpdatePersonForm(index: index, person: personData),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    contactBox = Hive.box('peopleBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.person_add),
        backgroundColor: Colors.pink, // Set the background color to pink
      ),
      body: ValueListenableBuilder(
        valueListenable: contactBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return Center(
              child: Text('Empty'),
            );
          } else {
            return ListView.builder(
              itemCount: box.length + 1, // +1 for the header
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Header
                  return _buildHeader(box.length);
                } else {
                  // List item
                  var currentBox = box;
                  var personData = currentBox.getAt(index - 1)!;

                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateScreen(
                          index: index - 1,
                          person: personData,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            personData.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NIM: ${personData.country}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Email: ${personData.email ?? "N/A"}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Phone: ${personData.phoneNumber ?? "N/A"}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _showEditDialog(context, index - 1, personData),
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _deleteInfo(context, index - 1),
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 15,
                          color: Colors.blue,
                        ),
                      ],
                    ),

                  );
                }
              },
            );
          }
        },
      ),
    );
  }


  Widget _buildHeader(int totalStudents) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Students: $totalStudents Total Subject: 0'),
          // Add any other header information you need
        ],
      ),
    );
  }
}
