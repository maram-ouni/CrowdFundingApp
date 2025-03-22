
// import 'package:collective/screens/HomeScreen.dart';
// import 'package:collective/widgets/appBarGoBack.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:io';




// class CreateCampScreen extends StatefulWidget {
//   static String routeName = '/createCampScreen';

//   @override
//   _CreateCampScreenState createState() => _CreateCampScreenState();
// }

// class _CreateCampScreenState extends State<CreateCampScreen> {
//   String token = "";
//   File? _image; 
//   String _imagePath = "";
//   final picker = ImagePicker();

//   TextEditingController campNameController = TextEditingController();
//   TextEditingController campEquityController = TextEditingController();
//   TextEditingController campTargetController = TextEditingController();
//   TextEditingController campDescriptionController = TextEditingController();
//   TextEditingController longDescriptionController = TextEditingController();
//   TextEditingController campCategoryController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   final campNameValidator = MultiValidator([
//     RequiredValidator(errorText: 'Camp name is required'),
//   ]);

//   final campEquityValidator = MultiValidator([
//     RequiredValidator(errorText: 'Equity is required'),
//   ]);

//   final campTargetValidator = MultiValidator([
//     RequiredValidator(errorText: 'Target is required'),
//   ]);

//   final campCategoryValidator = MultiValidator([
//     RequiredValidator(errorText: 'Category is required'),
//   ]);

//   final campDescriptionValidator = MultiValidator([
//     RequiredValidator(errorText: 'Description is required'),
//     MaxLengthValidator(116, errorText: 'Description cannot be longer than 116 characters.')
//   ]);

//   @override
//   void dispose() {
//     campNameController.dispose();
//     campEquityController.dispose();
//     campTargetController.dispose();
//     campDescriptionController.dispose();
//     campCategoryController.dispose();
//     super.dispose();
//   }

//   Future<void> getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         _imagePath = pickedFile.path;
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   void createCampMethod() {
//     if (_formKey.currentState!.validate() && _image != null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.white,
//         duration: Duration(days: 1),
//         padding: EdgeInsets.only(top: 300, bottom: 150, left: 30, right: 30),
//         content: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: Text(
//                 "Creating camp",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
//               ),
//             ),
//             SpinKitFadingCube(
//               color: Theme.of(context).primaryColor,
//               size: 30.0,
//             ),
//           ],
//         ),
//       ));

//       createCamp(
//         token,
//         campNameController.text,
//         int.parse(campEquityController.text),
//         int.parse(campTargetController.text),
//         campDescriptionController.text,
//         campCategoryController.text,
//         _imagePath,
//       ).then((data) {
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         print(data);

//         if (data['result'] == true) {
//           Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Theme.of(context).primaryColor,
//             padding: EdgeInsets.all(20),
//             content: Text(
//               "Camp created successfully",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18),
//             ),
//           ));
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.red,
//             padding: EdgeInsets.all(20),
//             content: Text(
//               "There was a problem creating the camp",
//               textAlign: TextAlign.center,
//             ),
//           ));
//         }
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Please complete all fields and select an image."),
//       ));
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     setToken();
//   }

//   Future<void> setToken() async {
//     final prefValue = await SharedPreferences.getInstance();
//     token = prefValue.getString('token') ?? "";
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(55),
//           child: AppBarGoBack(),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Center(
//                 child: _image == null
//                     ? Image.asset(
//                         'assets/images/Create.png',
//                         height: 225,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       )
//                     : Image.file(
//                         _image!,
//                         height: 225,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//               ),
//               Container(
//                 height: 452,
//                 margin: EdgeInsets.only(left: 20, right: 20),
//                 child: Form(
//                   key: _formKey,
//                   child: ListView(
//                     children: [
//                       buildTextField(
//                         label: 'Camp name',
//                         controller: campNameController,
//                         validator: campNameValidator,
//                       ),
//                       buildTextField(
//                         label: 'Category',
//                         controller: campCategoryController,
//                         validator: campCategoryValidator,
//                       ),
//                       buildTextField(
//                         label: 'Description',
//                         controller: campDescriptionController,
//                         validator: campDescriptionValidator,
//                       ),
//                       buildTextField(
//                         label: 'Equity',
//                         controller: campEquityController,
//                         validator: campEquityValidator,
//                         keyboardType: TextInputType.number,
//                       ),
//                       buildTextField(
//                         label: 'Target',
//                         controller: campTargetController,
//                         validator: campTargetValidator,
//                         keyboardType: TextInputType.number,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _image == null
//                               ? Text(
//                                   'Please select a camp image',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15,
//                                       color: Theme.of(context).primaryColor),
//                                 )
//                               : ElevatedButton(
//                                   onPressed: createCampMethod,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 2),
//                                         child: Text(
//                                           'Create camp',
//                                           style: TextStyle(fontSize: 18),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     minimumSize: Size(210, 45),
//                                     backgroundColor: Theme.of(context).primaryColor,
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(50),
//                                     ),
//                                   ),
//                                 ),
//                           Container(
//                             margin: EdgeInsets.only(top: 20, bottom: 20),
//                             child: ElevatedButton(
//                               onPressed: getImage,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 0),
//                                     child: Icon(
//                                       Icons.image,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: Size(90, 45),
//                                 backgroundColor: Theme.of(context).primaryColor,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField({
//     required String label,
//     required TextEditingController controller,
//     required MultiValidator validator,
//     TextInputType? keyboardType,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(top: 12),
//       child: TextFormField(
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: Colors.grey[50],
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide(color: Colors.grey, width: 1),
//           ),
//         ),
//         controller: controller,
//         validator: validator,
//         keyboardType: keyboardType,
//       ),
//     );
//   }

//   Future<Map<String, dynamic>> createCamp(
//     String token,
//     String name,
//     int equity,
//     int target,
//     String description,
//     String category,
//     String imagePath,
//   ) async {
//     final response = await http.post(
//       Uri.parse('http://192.168.1.18:8080/api/createCamp'),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//       body: {
//         'name': name,
//         'equity': equity.toString(),
//         'target': target.toString(),
//         'description': description,
//         'category': category,
//         'image': imagePath,
//       },
//     );

//     return json.decode(response.body);
//   }
// }
import 'package:collective/screens/HomeScreen.dart';
import 'package:collective/widgets/appBarGoBack.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateCampScreen extends StatefulWidget {
  static String routeName = '/createCampScreen';

  @override
  _CreateCampScreenState createState() => _CreateCampScreenState();
}

class _CreateCampScreenState extends State<CreateCampScreen> {
  String token = "";
  File? _image;
  String _imagePath = "";
  final picker = ImagePicker();

  TextEditingController campNameController = TextEditingController();
  TextEditingController campEquityController = TextEditingController();
  TextEditingController campTargetController = TextEditingController();
  TextEditingController campDescriptionController = TextEditingController();
  TextEditingController longDescriptionController = TextEditingController();
  TextEditingController campCategoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final campNameValidator = MultiValidator([RequiredValidator(errorText: 'Camp name is required')]);
  final campEquityValidator = MultiValidator([RequiredValidator(errorText: 'Equity is required')]);
  final campTargetValidator = MultiValidator([RequiredValidator(errorText: 'Target is required')]);
  final campCategoryValidator = MultiValidator([RequiredValidator(errorText: 'Category is required')]);
  final campDescriptionValidator = MultiValidator([
    RequiredValidator(errorText: 'Description is required'),
    MaxLengthValidator(116, errorText: 'Description cannot be longer than 116 characters.')
  ]);

  @override
  void dispose() {
    campNameController.dispose();
    campEquityController.dispose();
    campTargetController.dispose();
    campDescriptionController.dispose();
    campCategoryController.dispose();
    super.dispose();
  }

  Future<void> getImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _imagePath = pickedFile.path;
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> createCampMethod() async {
      // final image = _image; // Créer une variable locale pour éviter le problème

    if (_formKey.currentState!.validate() && _image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          duration: Duration(days: 1),
          padding: EdgeInsets.only(top: 300, bottom: 150, left: 30, right: 30),
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Creating camp",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
                ),
              ),
              SpinKitFadingCube(
                color: Theme.of(context).primaryColor,
                size: 30.0,
              ),
            ],
          ),
        ),
      );

      try {
        final data = await createCamp(
          token,
          campNameController.text,
          int.parse(campEquityController.text),
          int.parse(campTargetController.text),
          campDescriptionController.text,
          campCategoryController.text,
          _imagePath,
        );

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (data['result'] == true) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(20),
              content: Text(
                "Camp created successfully",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              padding: EdgeInsets.all(20),
              content: Text(
                "There was a problem creating the camp",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      } catch (e) {
        print("Error creating camp: $e");
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            padding: EdgeInsets.all(20),
            content: Text(
              "An error occurred while creating the camp.",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please complete all fields and select an image.")));
    }
  }

  @override
  void initState() {
    super.initState();
    setToken();
  }

  Future<void> setToken() async {
    final prefValue = await SharedPreferences.getInstance();
    token = prefValue.getString('token') ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBarGoBack(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: _image == null
                    ? Image.asset('assets/images/Create.png', height: 225, width: double.infinity, fit: BoxFit.cover)
                    : Image.file(_image!, height: 225, width: double.infinity, fit: BoxFit.cover),
              ),
              Container(
                height: 452,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      buildTextField(label: 'Camp name', controller: campNameController, validator: campNameValidator),
                      buildTextField(label: 'Category', controller: campCategoryController, validator: campCategoryValidator),
                      buildTextField(label: 'Description', controller: campDescriptionController, validator: campDescriptionValidator),
                      buildTextField(label: 'Equity', controller: campEquityController, validator: campEquityValidator, keyboardType: TextInputType.number),
                      buildTextField(label: 'Target', controller: campTargetController, validator: campTargetValidator, keyboardType: TextInputType.number),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _image == null
                              ? Text('Please select a camp image', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).primaryColor))
                              : ElevatedButton(
                                  onPressed: createCampMethod,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Padding(padding: const EdgeInsets.only(top: 2), child: Text('Create camp', style: TextStyle(fontSize: 18)))]
                                  ),
                                  style: ElevatedButton.styleFrom(minimumSize: Size(210, 45), backgroundColor: Theme.of(context).primaryColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                                ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: ElevatedButton(
                              onPressed: getImage,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.image)],
                              ),
                              style: ElevatedButton.styleFrom(minimumSize: Size(90, 45), backgroundColor: Theme.of(context).primaryColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                            ),
                          ),
                        ],
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

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required MultiValidator validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }

  Future<Map<String, dynamic>> createCamp(
    String token,
    String name,
    int equity,
    int target,
    String description,
    String category,
    String imagePath,
  ) async {
    try {
      imagePath = imagePath.replaceAll("\\", "/");
      final response = await http.post(
        Uri.parse('http://192.168.1.18:8080/api/createCamp'),
        headers: {'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
              'x-api-key': '8\$dsfsfgreb6&4w5fsdjdjkje#\$54757jdskjrekrm@#\$@\$%&8fdddg*&*ffdsds',

},
        body:jsonEncode( {
          'token': token,
          'camp_name': name,
          'camp_equity': equity.toString(),
          'camp_target': target.toString(),
          'camp_description': description,
          'long_description': description,
          'category': category,
          'camp_image': imagePath,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
print(
          response.body
        );

        throw Exception('Failed to create camp');
      }
    } catch (e) {
      print("Error making API call: $e");
      throw Exception('Error creating camp');
    }
  }
// Future<Map<String, dynamic>> createCamp(
//   String token,
//   String name,
//   int equity,
//   int target,
//   String description,
//   String category,
//   File imageFile, // Change ici : on prend un fichier, pas un chemin
// ) async {
//   try {
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('http://192.168.1.18:8080/api/createCamp'),
//     );

//     // Ajout des headers
//     request.headers.addAll({
//       'Authorization': 'Bearer $token',
//     });

//     // Ajout des champs normaux
//     request.fields.addAll({
//       'camp_name': name,
//       'camp_equity': equity.toString(),
//       'camp_target': target.toString(),
//       'camp_description': description,
//       'long_description': description,
//       'category': category,
//     });

//     // Ajout du fichier image
//     request.files.add(
//       await http.MultipartFile.fromPath('camp_image', imageFile.path, ),
//     );

//     // Exécuter la requête
//     var response = await request.send();
//     var responseData = await response.stream.bytesToString();

//     if (response.statusCode == 200) {
//       return json.decode(responseData);
//     } else {
//       throw Exception('Failed to create camp');
//     }
//   } catch (e) {
//     print("Error making API call: $e");
//     throw Exception('Error creating camp');
//   }
// }

}
