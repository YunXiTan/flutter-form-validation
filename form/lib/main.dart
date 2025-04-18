import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Form Validation',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _fullName;
  String? _dob;
  String? _gender;
  double _sliderValue = 5;
  int _stepperValue = 10;
  int _rating = 0;
  bool _agree = false;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  Map<String, bool> _languages = {
    'English': false,
    'Hindi': false,
    'Other': false,
  };

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Form Validation', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    value!.isEmpty ? 'This field cannot be empty.' : null,
                onSaved: (value) => _fullName = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) =>
                    value!.isEmpty ? 'This field cannot be empty.' : null,
                onSaved: (value) => _dob = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gender'),
                value: _gender,
                items: ['Male', 'Female', 'Other']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _gender = value),
                validator: (value) =>
                    value == null ? 'This field cannot be empty.' : null,
              ),
              SizedBox(height: 20),
              Text('Number of Family Members'),
              Slider(
                value: _sliderValue,
                min: 0,
                max: 10,
                divisions: 10,
                label: _sliderValue.round().toString(),
                onChanged: (value) =>
                    setState(() => _sliderValue = value),
              ),
              SizedBox(height: 20),
              Text('Rating'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      _rating > index ? Icons.star : Icons.star_border,
                      color: Colors.purple,
                    ),
                    onPressed: () => setState(() => _rating = index + 1),
                  );
                }),
              ),
              SizedBox(height: 20),
              Text('Stepper'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () =>
                          setState(() => _stepperValue = _stepperValue - 1),
                      icon: Icon(Icons.remove)),
                  Text('$_stepperValue'),
                  IconButton(
                      onPressed: () =>
                          setState(() => _stepperValue = _stepperValue + 1),
                      icon: Icon(Icons.add)),
                ],
              ),
              SizedBox(height: 20),
              Text('Languages you know'),
              ..._languages.keys.map((lang) => CheckboxListTile(
                    title: Text(lang),
                    value: _languages[lang],
                    onChanged: (val) =>
                        setState(() => _languages[lang] = val!),
                  )),
              SizedBox(height: 20),
              Text('Signature'),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  color: Colors.white,
                ),
                child: Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.clear, color: Colors.red),
                    label: Text('Clear', style: TextStyle(color: Colors.red)),
                    onPressed: () => _signatureController.clear(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Rate this site'),
              Row(
                children: List.generate(5, (index) =>
                    Icon(Icons.star, color: Colors.purple)),
              ),
              CheckboxListTile(
                title: Text('I have read and agree to the terms and conditions'),
                value: _agree,
                onChanged: (val) => setState(() => _agree = val!),
              ),
              if (!_agree)
                Text(
                  'You must accept terms and conditions to continue',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _agree) {
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Form Submitted')),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      _signatureController.clear();
                      setState(() {
                        _agree = false;
                        _rating = 0;
                        _sliderValue = 5;
                        _stepperValue = 10;
                        _gender = null;
                        _languages.updateAll((key, value) => false);
                      });
                    },
                    child: Text('Reset'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
