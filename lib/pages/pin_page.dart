import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uas_ambw_c14210254/models/pin.dart';
import 'notes_page.dart';

class PinPage extends StatefulWidget {
  final bool isFirstTime;

  PinPage({required this.isFirstTime});

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _submitPin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var box = await Hive.openBox<Pin>('pinBox');
      if (widget.isFirstTime) {
        var pin = Pin(pin: _pinController.text);
        await box.put('pin', pin);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotesPage()),
        );
      } else {
        var pin = box.get('pin')!;
        if (pin.pin == _pinController.text) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NotesPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect PIN')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFirstTime ? 'Create PIN' : 'Enter PIN'),
      ),
      backgroundColor:  const Color.fromARGB(255, 255, 253, 254),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 100,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.isFirstTime ? 'Create a new PIN' : 'Enter your PIN',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _pinController,
                    decoration: const InputDecoration(
                      labelText: 'PIN',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a PIN';
                      } else if (value.length < 4) {
                        return 'PIN should be at least 4 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitPin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      widget.isFirstTime ? 'Create PIN' : 'Enter PIN',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
