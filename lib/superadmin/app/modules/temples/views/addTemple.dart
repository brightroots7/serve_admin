import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/smtp_server/gmail.dart';
import '../../../../shared/Constants/appcolor.dart';
class AddTempleScreen extends StatefulWidget {
  const AddTempleScreen({super.key});

  @override
  _AddTempleScreenState createState() => _AddTempleScreenState();
}

class _AddTempleScreenState extends State<AddTempleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  late TextEditingController _nameController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late TextEditingController _descController;
  late TextEditingController _typeController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _receipientController;
  List<XFile> _selectedImages = [];
  List<String> _imageUrls = [];
  bool _isUploading = false;

  // final gmailSmtp = gmail(dotenv.env['GMAIL_MAIL']!, dotenv.env['GMAIL_PASSWORD']!);
  final gmailSmtp = gmail(
      const String.fromEnvironment('GMAIL_MAIL'),
      const String.fromEnvironment('GMAIL_PASSWORD')
  );
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _latController = TextEditingController();
    _lngController = TextEditingController();
    _descController = TextEditingController();
    _typeController = TextEditingController(text: 'Must visit');
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _receipientController = TextEditingController();
  }


  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error',
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _latController.text = position.latitude.toStringAsFixed(6);
      _lngController.text = position.longitude.toStringAsFixed(6);
    });
  }

  Future sendEmail() async {
    try {
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      const serviceId = 'service_gv9tdwg';
      const templateId = 'template_k2l0pa3';
      const userId = 'JYrFFIqjMMW3bxpqA';

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "service_id": serviceId,
          "template_id": templateId,
          "user_id": userId,
          "template_params": {
            "user_message": "This is Temple Login Email: ${_emailController.text} "
                "and Password: ${_passwordController.text}\n Hosting URL:https://serveapp-617d9.web.app/#/Login",
            "user_email": _receipientController.text
          }
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // EmailJS returns plain text "OK" on success
        if (response.body == 'OK') {
          print('Email sent successfully');
          return true;
        }
        throw Exception('Unexpected response body: ${response.body}');
      } else {
        throw Exception('Failed to send email: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending email: $e');
      Get.snackbar('Error', 'Failed to send email: $e');
      rethrow;
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles);
      });
    }
  }

  Future<void> _uploadImages() async {
    setState(() => _isUploading = true);
    _imageUrls = [];

    try {
      for (var xFile in _selectedImages) {
        final ref = _storage
            .ref()
            .child('temples/${DateTime.now().millisecondsSinceEpoch}.jpg');

        if (kIsWeb) {
          // For web: read as bytes and upload
          Uint8List bytes = await xFile.readAsBytes();
          await ref.putData(bytes);
        } else {
          // For mobile: upload file directly
          File imageFile = File(xFile.path);
          await ref.putFile(imageFile);
        }

        final url = await ref.getDownloadURL();
        _imageUrls.add(url);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload images: $e');
      print(e.toString());
      setState(() => _isUploading = false);
      rethrow;
    }
    setState(() => _isUploading = false);
  }

  Future<void> _saveTemple() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image');
      return;
    }

    try {
      setState(() => _isUploading = true);

      final emailResult = await sendEmail();
      if (!emailResult) {
        throw Exception('Email sending failed');
      }
      await _uploadImages();


      final newTemple = {
        'temple_name': _nameController.text,
        'desc': _descController.text,
        'lat_lng': GeoPoint(
          double.parse(_latController.text),
          double.parse(_lngController.text),
        ),
        'photos': _imageUrls,
        'type': _typeController.text,
        'temple_admin_email': _emailController.text,
        'temple_admin_password': _passwordController.text,
        'created_at': FieldValue.serverTimestamp(),
      };

      final templeDocRef =
          await _firestore.collection('temples').add(newTemple);

      // Add 'templeId' in the temple data after creation
      await templeDocRef.update({'templeId': templeDocRef.id});

      // Save temple admin details in the 'temple_admin' collection
      final templeAdminData = {
        'email': _emailController.text,
        'password': _passwordController.text,
        'templeId': templeDocRef.id, // Link with the temple
        'temple_admin_uid': templeDocRef.id, // Use the doc ID as UID
      };

      // Add data to 'temple_admin' collection
      await _firestore
          .collection('temple_admin')
          .doc(templeDocRef.id)
          .set(templeAdminData);

      // sendMailFromGmail(_receipientController.text, "Credential Mail",
      //     "This is your Temple Credentials\nEmail: ${_emailController.text} and Password: ${_passwordController.text}");
      Get.back();
      Get.snackbar('Success', 'Temple added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save temple: ${e.toString()}');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Temple'),
      ),
      body: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Temple Name',
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: appcolor.yellow2)),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Temple Admin email',
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: appcolor.yellow2)),
                                      ),
                                      validator: (value) =>
                                          value!.isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _receipientController,
                                      decoration: InputDecoration(
                                        labelText: 'Enter Receipient Email',
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: appcolor.yellow2)),
                                      ),
                                      validator: (value) =>
                                          value!.isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        labelText: 'Temple Admin Password',
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: appcolor.yellow2)),
                                      ),
                                      validator: (value) =>
                                          value!.isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _latController,
                                      decoration: InputDecoration(
                                        labelText: 'Latitude',
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: appcolor.yellow2)),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) return 'Required';
                                        if (double.tryParse(value) == null) {
                                          return 'Invalid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _lngController,
                                      decoration: InputDecoration(
                                        labelText: 'Longitude',
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: appcolor.yellow2)),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) return 'Required';
                                        if (double.tryParse(value) == null) {
                                          return 'Invalid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: _determinePosition,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: appcolor.appColor,
                                      ),
                                      child: const Text(
                                        'Get Current Location',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _descController,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: appcolor.yellow2)),
                                ),
                                maxLines: 3,
                                validator: (value) =>
                                    value!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _typeController,
                                decoration: InputDecoration(
                                  labelText: 'Type',
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: appcolor.yellow2)),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Temple Images:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                              itemCount: _selectedImages.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _selectedImages.length) {
                                  return GestureDetector(
                                    onTap: _pickImages,
                                    child: Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.add_a_photo),
                                    ),
                                  );
                                }
                                return Stack(
                                  children: [
                                    kIsWeb
                                        ? Image.network(
                                            _selectedImages[index].path,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(_selectedImages[index].path),
                                            fit: BoxFit.cover,
                                          ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.red),
                                        onPressed: () => setState(() =>
                                            _selectedImages.removeAt(index)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: _saveTemple,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appcolor.appColor,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: Text(
                                  'Save Temple',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _descController.dispose();
    _typeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
