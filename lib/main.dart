import 'package:flutter/material.dart';
import 'package:flutter_application_1/form_screem.dart';
import 'package:flutter_application_1/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _dataListFuture = [];
  bool _ascendingOrder = true;

  @override
  void initState() {
    super.initState();
    setListData();
  }

  setListData() async {
    _dataListFuture = await SQLHelper.getItems();

    setState(() {});
  }

  void toggleSortOrder() {
    setState(() {
      _ascendingOrder = !_ascendingOrder;
      List<Map<String, dynamic>> sortedList = List.from(_dataListFuture);
      sortedList.sort((a, b) {
        final int ageA = int.parse(a['age']);
        final int ageB = int.parse(b['age']);
        return _ascendingOrder ? ageA.compareTo(ageB) : ageB.compareTo(ageA);
      });
      _dataListFuture = sortedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: TextButton(onPressed: (){
            toggleSortOrder();
          }, child: Text(_ascendingOrder ? 'Asc.' : 'Dsc.',style: Theme.of(context).textTheme.bodyLarge,)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const FormScreen()))
                    .then((value) async {
                  if (value) {
                    await setListData();
                   
                  }
                });
              },
              icon: const Icon(Icons.add, size: 35),
            ),
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(15),
              color: Colors.blue.shade300,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Name: ${_dataListFuture[index]['name']}',
                    ),
                    CustomText(
                        text: 'Gender: ${_dataListFuture[index]['gender']}'),
                    CustomText(text: 'Age: ${_dataListFuture[index]['age']}'),
                    CustomText(
                        text: 'Hobby: ${_dataListFuture[index]['hobby']}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () async {
                              await SQLHelper.deleteItem(
                                  _dataListFuture[index]['id']);

                              await setListData();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => FormScreen(
                                          itemId: _dataListFuture[index]
                                              ['id'])))
                                  .then((value) async {
                                if (value) {
                                  await setListData();
                                  // setState(() {});
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: _dataListFuture.length,
        ));
  }
}

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
        maxLines: 1);
  }
}
