import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../../shared/Constants/Appcolors.dart';


class AddServiceScreen extends StatefulWidget {
  final String templeId;
  const AddServiceScreen({super.key, required this.templeId});

  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  late TextEditingController _serviceNameController;
  late TextEditingController _serviceDesciptionController;


  List<XFile> _selectedImages = [];
  List<String> _imageUrls = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _serviceNameController = TextEditingController();
    _serviceDesciptionController = TextEditingController();

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


  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please select at least one image');
      return;
    }

    try {
      setState(() => _isUploading = true);
      //await _uploadImages();


      final newService = {
        'serviceName': _serviceNameController.text,
        'serviceDesciption': _serviceDesciptionController.text,
        'photos': _imageUrls,
        'templeId': widget.templeId,
        'date_time': FieldValue.serverTimestamp(),
      };

      final templeDocRef = await _firestore.collection('services').add(newService);




      Get.back();
      Get.snackbar('Success', 'Service added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save service: $e');
      print(e.toString());
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Service'),
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
                          controller: _serviceNameController,
                          decoration: InputDecoration(
                            labelText: 'Service Name',
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
                                controller: _serviceDesciptionController,
                                decoration: InputDecoration(
                                  labelText: 'Service Description',
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
                        child: Text(
                          "Service Images:",
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
                          onPressed: _saveService,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolor.appColor,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            'Save Service',
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
  }
}