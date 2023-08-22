import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

Future<List<Data>> fetchData() async {
  // var url = Uri.parse('http://127.0.0.1:8080/customer');
  final response =
      await http.get(new Uri.http("10.22.186.160:8080", "/customer"));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final int id;
  final String name;
  final String birthday;
  final String phoneNumber;
  final String address;

  Data(
      {required this.id,
      required this.name,
      required this.birthday,
      required this.phoneNumber,
      required this.address});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      birthday: json['birthday'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Manager'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('List Customer'),
            const SizedBox(height: 20),
            MyStatefulWidget(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondScreen()),
                );
              },
              child: const Text('Create News Customer'),
            ),
            // Add spacing between the button and other content
          ],
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: DataTable(
              border: TableBorder.all(width: 1),
              columnSpacing: 30,
              columns: const [
                DataColumn(label: Text('ID'), numeric: true),
                DataColumn(label: Text('NAME'), numeric: true),
                DataColumn(label: Text('BIRTHDAY')),
                DataColumn(label: Text('PHONE NUMBER'), numeric: true),
                DataColumn(label: Text('ADDRESS')),
              ],
              rows: List.generate(
                snapshot.data!.length,
                (index) {
                  var data = snapshot.data![index];
                  return DataRow(cells: [
                    DataCell(
                      Text(data.id.toString()),
                    ),
                    DataCell(
                      Text(data.name.toString()),
                    ),
                    DataCell(
                      Text(data.birthday),
                    ),
                    DataCell(
                      Text(data.phoneNumber.toString()),
                    ),
                    DataCell(
                      Text(data.address),
                    ),
                  ]);
                },
              ).toList(),
              showBottomBorder: true,
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Example'),
        ),
        body: CreateCustomerForm());
  }
}

class CreateCustomerForm extends StatefulWidget {
  @override
  _CreateCustomerFormState createState() => _CreateCustomerFormState();
}

class _CreateCustomerFormState extends State<CreateCustomerForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _birthday = '';
  String _phoneNumber = '';
  String _address = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Create a map containing the customer data
      Map<String, dynamic> customerData = {
        'name': _name,
        'birthday': _birthday,
        'phoneNumber': _phoneNumber,
        'address': _address,
      };

      // Convert the map to JSON
      String jsonData = jsonEncode(customerData);

      // Send the POST request to the API
      var apiUrl = Uri.parse('http://10.22.186.160:8080/customer');
      http.Response response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      if (response.statusCode == 201) {
        // Successful creation
        print('Customer created successfully');

        // Navigate to another screen after successful creation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondScreen()),
        );
      } else {
        // Error
        print('Failed to create customer. Status code: ${response.statusCode}');
        // Handle error, show an error message, etc.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Birthday'),
            onChanged: (value) {
              setState(() {
                _birthday = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Phone Number'),
            onChanged: (value) {
              setState(() {
                _phoneNumber = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Address'),
            onChanged: (value) {
              setState(() {
                _address = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Create Customer'),
          ),
        ],
      ),
    );
  }
}



// var apiUrl = Uri.parse('http://10.22.186.160:8080/customer');