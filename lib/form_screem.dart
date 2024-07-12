import 'package:flutter/material.dart';
import 'package:flutter_application_1/form_field.dart';
import 'package:flutter_application_1/sql_helper.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, this.itemId = -1});
  final int itemId; 
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  List<Map<String, dynamic>> dataList = [];
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isDataChaned = false;
  int? _value = 1;
  String? dropDownValue = '0';
  late DateTime userDob;
  List<Map<String, String>> hobbyList = [
    {'title': 'Select a hooby', 'value': '0'},
    {'title': 'Sports', 'value': '1'},
    {'title': 'Video Games', 'value': '2'},
    {'title': 'Advanture', 'value': '3'},
    {'title': 'Music', 'value': '4'},
  ];
 
 // Fuction to calcutale the age of the user from dob.
  String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }
 
 // Fuction to get specific hobby from the hobby list. 
  getHobbyTitle() {
    String? userHobby;
    for (int i = 0; i < hobbyList.length; i++) {
      if (hobbyList[i]['value'] == dropDownValue) {
        userHobby = hobbyList[i]['title'];
      }
    }
    return userHobby;
  }
 
 // Fuvction to get  the selected hobby from the dropdown.
  getDropDownValue() {
    for (int i = 0; i < hobbyList.length; i++) {
      if (hobbyList[i]['value'] == dropDownValue) {
        return hobbyList[i]['value'];
      }
    }
  }
 
 // Function to add new user data
  Future<void> addItem() async {
    await SQLHelper.createItem(nameController.text, getHobbyTitle(),
        _value == 1 ? 'Male' : 'Female', calculateAge(userDob));
    isDataChaned = true;
    refreshData();
  }
 
  void cleartextField() {
    nameController.clear();
    ageController.clear();
  }
 //Function to populate the feilds while updating existing user data.
  void populateFeilds() async {
    var temp = await SQLHelper.getItem(widget.itemId);
    debugPrint(temp.toString());
    nameController.text = temp[0]['name'];
    temp[0]['gender'] == 'Male' ? _value = 1 : _value = 2;
    dropDownValue = getDropDownValue();
    //ageController.text = userDob.toString()
  }

// Function to update user data
  Future<void> updateUserData(int id) async {
    await SQLHelper.updateItem(id, nameController.text, getHobbyTitle(),
        _value == 1 ? 'Male' : 'Female', calculateAge(userDob));
    refreshData();
    isDataChaned = true;
  }

  void refreshData() async {
    final data = await SQLHelper.getItems();
    setState(() {
      dataList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
    if (widget.itemId >= 0) {
      populateFeilds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomFormField(
                  fieldNmae: 'Name',
                  text: 'Enter Your Name',
                  controller: nameController),
              CustomFormField(
                controller: ageController,
                fieldNmae: 'DOB',
                prefixIcon: const Icon(Icons.calendar_month),
                enabled: true,
                reanOnly: true,
                text: 'Select dob',
                ontap: () {
                  showDatePicker(
                          context: context,
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now())
                      .then((value) => setState(() {
                            userDob = value!;
                            ageController.text =
                                '${value.day}/${value.month}/${value.year}';
                          }));
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                width: double.infinity,
                height: 65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.5,
                    )),
                child: DropdownButton<String>(
                    padding: const EdgeInsets.all(15),
                    borderRadius: BorderRadius.circular(10),
                    icon: const Icon(Icons.arrow_drop_down),
                    value: dropDownValue,
                    items: [
                      ...hobbyList.map<DropdownMenuItem<String>>((data) {
                        return DropdownMenuItem<String>(
                          value: data['value'],
                          child: Text(data['title']!),
                        );
                      })
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue!;
                        
                      });
                    }),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 25, top: 10),
                  child: Text('Gender',
                      style: Theme.of(context).textTheme.bodyLarge)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                    const Text('Male'),
                    Radio(
                      value: 2,
                      groupValue: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                    const Text('Female'),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (widget.itemId >= 0) {
                        await updateUserData(widget.itemId);
                      } else {
                        await addItem();
                      }
                      cleartextField();
                    }
                   
                  },
                  child:
                      Text(widget.itemId >= 0 ? 'Update User' : 'Create User'))
            ],
          ),
        ),
      ),
    );
  }
}
