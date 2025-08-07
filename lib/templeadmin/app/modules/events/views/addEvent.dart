import 'dart:io';

import 'package:admin/superadmin/shared/Constants/appcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/Constants/Appcolors.dart';

class AddEventsScreen extends StatefulWidget {
  final String templeId;
  const AddEventsScreen({super.key, required this.templeId});

  @override
  _AddEventsScreenState createState() => _AddEventsScreenState();
}

class _AddEventsScreenState extends State<AddEventsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  late TextEditingController _eventNameController;
  late TextEditingController _festivalNameController;
  late TextEditingController _eventDateController;

  List<XFile> _selectedImages = [];
  List<String> _imageUrls = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController();
    _festivalNameController = TextEditingController();
    _eventDateController = TextEditingController();
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
  Future<void> _pickDate(BuildContext context) async {
    // Show date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      // Format the date to a string and set it to the controller
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      _eventDateController.text = formattedDate;
    }
  }


  Future<void> _uploadImages() async {
    setState(() => _isUploading = true);
    _imageUrls = [];

    try {
      for (var xFile in _selectedImages) {
        final ref = _storage
            .ref()
            .child('Events/${DateTime.now().millisecondsSinceEpoch}.jpg');

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

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image');
      return;
    }

    try {
      setState(() => _isUploading = true);

      // Parse the event date from the controller and convert to Timestamp
      DateTime eventDate = DateFormat('yyyy-MM-dd').parse(_eventDateController.text);
      Timestamp timestamp = Timestamp.fromDate(eventDate);

      final newEvent = {
        'eventName': _eventNameController.text,
        'festivalName': _festivalNameController.text,
        'photos': _imageUrls,
        'templeId': widget.templeId,
        'date_time': timestamp, // Use the parsed timestamp here
      };


      final templeDocRef =
          await _firestore.collection('events').add(newEvent);



      Get.back();
      Get.snackbar('Success', 'Event added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save event: $e');
      print(e.toString());
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Event'),
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
                                controller: _eventNameController,
                                decoration: InputDecoration(
                                  labelText: 'Event Name',
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Appcolors.yellow2)),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _festivalNameController,
                                decoration: InputDecoration(
                                  labelText: 'Festival Name',
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Appcolors.yellow2)),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _eventDateController,
                                decoration: InputDecoration(
                                  labelText: 'Event Date',
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent)),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => _pickDate(context), // Show date picker
                                  ),
                                ),
                                validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                                readOnly: true, // Make it read-only to prevent manual input
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Event Images:",
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
                                onPressed: _saveEvent,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Appcolor.appColor,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: Text(
                                  'Save Event',
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
    super.dispose();
    _eventNameController.dispose();
    _festivalNameController.dispose();
    _eventDateController.dispose();
  }
}
