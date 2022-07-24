import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_profile_app/views/your_about_ui.dart';
import 'package:my_profile_app/views/your_email_ui.dart';
import 'package:my_profile_app/views/your_name_ui.dart';
import 'package:my_profile_app/views/your_phone_ui.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({Key? key}) : super(key: key);

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  //สร้าง Controller ของแต่ละ TextFild
  TextEditingController yournameCtrl = TextEditingController(text: '');
  TextEditingController yourphoneCtrl = TextEditingController(text: '');
  TextEditingController youremailCtrl = TextEditingController(text: '');
  TextEditingController youraboutCtrl = TextEditingController(text: '');
  
  //สร้าง opject ที่ใ้ชในการเก็บรูป
  File? _image;

  //เมธอดเอารูปจาก camera โดยการเปิดกล้องและถ่ายรูป
  //แล้วบันทึกลง sharedpreferences
  getimageFromCameraAndSaveToSF() async {
    //เปิดกล้องเพื่อถ่ายภาพเพื่อถ่ายรูปเก็บใน pickimage
    XFile? pickImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    //กำหนดที่ที่จะให้แสดงผล
    if (pickImage != null) {
      setState(() {
        _image = File(pickImage.path);
      });
    }

    //บันทึกรูปที่ถ่ายจาก camera ลงเครื่อง
    Directory imageDir = await getApplicationDocumentsDirectory();
    String imagePath = imageDir.path;
    var imageName = basename(pickImage!.path);
    File localImage = await File(pickImage.path).copy('$imagePath/$imageName');

    //บันทึก path รูปที่อยู้่ในเครื่องลง sharedpreferences
    SharedPreferences prefer = await SharedPreferences.getInstance();
    prefer.setString('yourimage', localImage.path);
  }

  //เมธอดเอารูปจาก Gallery โดยการเปิดกล้องและถ่ายรูป
  //แล้วบันทึกลง sharedpreferences
  getimageFromGalleryAndSaveToSF() async {
    //เปิดแกลอรี่เพื่อถ่ายภาพเพื่อถ่ายรูปเก็บใน pickimage
    XFile? pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    //กำหนดที่ที่จะให้แสดงผล
    if (pickImage != null) {
      setState(() {
        _image = File(pickImage.path);
      });
    }

    //บันทึกรูปที่ถ่ายจาก gallery ลงเครื่อง
    Directory imageDir = await getApplicationDocumentsDirectory();
    String imagePath = imageDir.path;
    var imageName = basename(pickImage!.path);
    File localImage = await File(pickImage.path).copy('$imagePath/$imageName');

    //บันทึก path รูปที่อยู้่ในเครื่องลง sharedpreferences
    SharedPreferences prefer = await SharedPreferences.getInstance();
    prefer.setString('yourimage', localImage.path);
  }

  //ตรวจสอบคำที่ต้องการให้แสดง
  check_and_show_data() async {
    SharedPreferences prefer = await SharedPreferences.getInstance();
    //อ่านค่า key ต่างๆจาก SharedPreferences
    bool youraboutkey = prefer.containsKey("yourabout");
    bool youremailkey = prefer.containsKey("youremail");
    bool yournamekey = prefer.containsKey("yourname");
    bool yourphonekey = prefer.containsKey("yourphone");
    bool yourimagekey = prefer.containsKey("yourimage");

    if (youraboutkey == true) {
      setState(() {
        youraboutCtrl.text = prefer.getString('yourabout')!;
      });
    }
    if (youremailkey == true) {
      setState(() {
        youremailCtrl.text = prefer.getString('youremail')!;
      });
    }
    if (yournamekey == true) {
      setState(() {
        yournameCtrl.text = prefer.getString('yourname')!;
      });
    }
    if (yourphonekey == true) {
      setState(() {
        yourphoneCtrl.text = prefer.getString('yourphone')!;
      });
    }
    if (yourimagekey == true) {
      setState(() {
        _image = File(prefer.getString('yourimage')!);
      });
    }
  }

  @override
  void initState() {
    check_and_show_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: Text(
          'My Profile',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image == null
                      ? Container(
                          height: MediaQuery.of(context).size.width * 0.5,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green, //ขอบวงกลม
                              width: 3.0,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/myprofile2.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.width * 0.5,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green, //ขอบวงกลม
                              width: 3.0,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(
                                _image!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  IconButton(
                    onPressed: () {
                      //getimageFromCameraAndSaveToSF();
                      getimageFromGalleryAndSaveToSF();
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      size: MediaQuery.of(context).size.width * 0.08,
                      color: Colors.green[500],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 35.0, //ระยะห่างด้านขวา
                  left: 35.0, //ระยะห่างด้านซ้าย
                ),
                child: TextField(
                  controller: yournameCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    label: Text(
                      'Your name :',
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Your name',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YourNameUI(),
                          ),
                        ).then((value) {
                          check_and_show_data();
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 35.0,
                  left: 35.0,
                ),
                child: TextField(
                  controller: yourphoneCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    label: Text(
                      'Your phone :',
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Your phone',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YourPhoneUI(),
                          ),
                        ).then((value) {
                          check_and_show_data();
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 35.0,
                  left: 35.0,
                ),
                child: TextField(
                  controller: youremailCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    label: Text(
                      'Your email :',
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Your email',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YourEmail(),
                          ),
                        ).then((value) {
                          check_and_show_data();
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 35.0,
                  left: 35.0,
                ),
                child: TextField(
                  controller: youraboutCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    label: Text(
                      'Your about :',
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Your about',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YourAboutUI(),
                          ),
                        ).then((value) {
                          check_and_show_data();
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
