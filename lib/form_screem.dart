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
  final genderController = TextEditingController();
  final hobbyController = TextEditingController();
  final ageController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isDataChaned = false;
  Future<void> addItem() async {
    await SQLHelper.createItem(nameController.text, hobbyController.text,
        genderController.text, ageController.text);
    isDataChaned = true;
    refreshData();
  }

  void cleartextField() {
    nameController.clear();
    genderController.clear();
    hobbyController.clear();
    ageController.clear();
  }

  void populateFeilds() async {
    var temp = await SQLHelper.getItem(widget.itemId);
    debugPrint(temp.toString());
    nameController.text = temp[0]['name'];
    genderController.text = temp[0]['gender'];
    hobbyController.text = temp[0]['hobby'];
    ageController.text = temp[0]['age'];
  }

  void updateUserData(int id) async {
    await SQLHelper.updateItem(id, nameController.text, hobbyController.text,
        genderController.text, ageController.text);
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
              //  print('Ne Id::::::::::$')
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
            children: [
              CustomFormField(
                  fieldNmae: 'Name',
                  text: 'Enter Your Name',
                  controller: nameController),
              CustomFormField(
                  fieldNmae: 'Gender',
                  text: 'Enter Your Gender',
                  controller: genderController),
              CustomFormField(
                  fieldNmae: 'Hobby',
                  text: 'Enter Your Hobby',
                  controller: hobbyController),
              CustomFormField(
                  fieldNmae: 'Age',
                  text: 'Enter Your Age',
                  controller: ageController),
              ElevatedButton(
                  onPressed: () async {
                    //isDataChaned = true;
                    if (formKey.currentState!.validate()) {
                      if (widget.itemId >= 0) {
                        updateUserData(widget.itemId);
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
