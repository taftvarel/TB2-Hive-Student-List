import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:contoh_hive/model/person.dart';

class UpdatePersonForm extends StatefulWidget {
  final int index;
  final Person person;

  const UpdatePersonForm({
    required this.index,
    required this.person,
  });

  @override
  _UpdatePersonFormState createState() => _UpdatePersonFormState();
}

class _UpdatePersonFormState extends State<UpdatePersonForm> {
  final _personFormKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _countryController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;

  late final Box box;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  // Update info of people box
  _updateInfo() {
    Person newPerson = Person(
      name: _nameController.text,
      country: _countryController.text,
      phoneNumber: int.parse(_phoneNumberController.text),
      email: _emailController.text,
    );
    box.putAt(widget.index, newPerson);
    print('Info updated in box!');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box('peopleBox');
    _nameController = TextEditingController(text: widget.person.name);
    _countryController = TextEditingController(text: widget.person.country);
    _phoneNumberController =
        TextEditingController(text: widget.person.phoneNumber.toString());
    _emailController = TextEditingController(text: widget.person.email);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _personFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            validator: _fieldValidator,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _countryController,
            validator: _fieldValidator,
            decoration: InputDecoration(labelText: 'NIM'),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.number,
            validator: _fieldValidator,
            decoration: InputDecoration(labelText: 'Phone Number'),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _emailController,
            validator: _fieldValidator,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_personFormKey.currentState!.validate()) {
                    _updateInfo();
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(195, 30), // Adjust the width and height as needed
                  backgroundColor: Colors.white60, // Set the background color to grey
                ),
                child: Text(
                  'UPDATE',
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
                  fixedSize: Size(90, 30), // Adjust the width and height as needed
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
