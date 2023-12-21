import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:contoh_hive/model/person.dart';

class AddPersonForm extends StatefulWidget {
  const AddPersonForm({Key? key}) : super(key: key);

  @override
  _AddPersonFormState createState() => _AddPersonFormState();
}

class _AddPersonFormState extends State<AddPersonForm> {
  final _nameController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  final _personFormKey = GlobalKey<FormState>();
  late final Box box;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  // Add info to people box
  _addInfo() async {
    Person newPerson = Person(
      name: _nameController.text,
      country: _countryController.text,
      phoneNumber: int.parse(_phoneNumberController.text),
      email: _emailController.text,
    );
    box.add(newPerson);
    print('Info added to box!');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box('peopleBox');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _personFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              isDense: true,
            ),
            validator: _fieldValidator,
          ),
          TextFormField(
            controller: _countryController,
            decoration: InputDecoration(
              labelText: 'NIM',
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              isDense: true,
            ),
            validator: _fieldValidator,
          ),
          TextFormField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              isDense: true,
            ),
            validator: _fieldValidator,
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              isDense: true,
            ),
            validator: _fieldValidator,
          ),
          SizedBox(height: 8.0), // Add a small space between form fields and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_personFormKey.currentState!.validate()) {
                    _addInfo();
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(140, 30), // Adjust the width and height as needed
                  backgroundColor: Colors.white60, // Set the background color to grey
                ),
                child: Text(
                  'CREATE',
                  style: TextStyle(
                    color: Colors.black, // Set the text color to black
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cancel button action
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(140, 30), // Adjust the width and height as needed
                  backgroundColor: Colors.white60, // Set the background color to grey
                ),
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.black, // Set the text color to black
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
              ),
            ],
          ),



        ],
      ),
    );
  }
}
