import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import
'package:contoh_hive/screens/update_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import
'package:contoh_hive/screens/add_screen.dart';
class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() =>
      _InfoScreenState();
}
class _InfoScreenState extends
State<InfoScreen> {
  late final Box contactBox;
// Delete info from people box
  _deleteInfo(int index) {
    contactBox.deleteAt(index);
    print('Item deleted from box at index:$index');
    }
  @override
  void initState() {
    super.initState();
// Get reference to an already opened box
    contactBox = Hive.box('peopleBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddScreen(),
              ),
            ),
        child: Icon(Icons.add),
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
              itemCount: box.length,
              itemBuilder: (context, index) {
                var currentBox = box;
                var personData =
                currentBox.getAt(index)!;

                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateScreen(
                        index: index,
                        person: personData,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(personData.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NIM: ${personData.country}'),
                            Text('Phone: ${personData.phoneNumber ?? "N/A"}'),
                            Text('Email: ${personData.email ?? "N/A"}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _deleteInfo(index),
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 8), // Add some space between buttons
                            IconButton(
                              onPressed: () {
                                // Handle edit button press (navigate to the edit screen)
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => UpdateScreen(
                                      index: index,
                                      person: personData,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
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


              },
            );
          }
        },
      ),
    );
  }
}