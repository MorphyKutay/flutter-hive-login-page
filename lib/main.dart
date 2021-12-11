import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'deneme.dart';

void main() async{
  await Hive.initFlutter();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isCh = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;
  late Box box1;
  @override
  void instate(){
    super.initState();
    createBox();

  }

  void crcreateBox() async{
    box1 = await Hive.openBox('logindata');
    getdata();
  }

  void getdata()async{
    if(box1.get('email')!=null){
      emailController.text  = box1.get('email');
      isCh = true;
      setState(() {

      });
    }if(box1.get('pass')!=null){
      passwordController.text = box1.get('pass');
      isCh = true;
      setState(() {

      });
    }

  }

//-----hive alanı------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBox();
  }

  void createBox() async{
    box1 = await Hive.openBox('database1');
  }
  //-----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade300,
      body: Container(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              box1.put('email', 'kutay@mail.com');
              box1.put('pass', 'kutay');
              print('DATA ADDED');
            }, child: const Text("Add")),

            Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Image.asset(
                'resimler/deneme.jpg',
                height: 200,
                width: 200,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Sign Up',
                      style:
                      TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        // icon: Icon(Icons.mail),
                          prefixIcon: Icon(Icons.mail),
                          suffixIcon: emailController.text.isEmpty
                              ? Text('')
                              : GestureDetector(
                              onTap: () {
                                emailController.clear();
                              },
                              child: Icon(Icons.close)),
                          hintText: 'example@mail.com',
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                              BorderSide(color: Colors.red, width: 1))),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      obscureText: isVisible,
                      controller: passwordController,
                      onChanged: (value) {
                        print(value);
                      },
                      //
                      decoration: InputDecoration(
                        // icon: Icon(Icons.mail),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                isVisible = !isVisible;
                                setState(() {});
                              },
                              child: Icon(isVisible ? Icons.visibility : Icons.visibility_off)),
                          hintText: 'type your password',
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                              BorderSide(color: Colors.red, width: 1))),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          login();
                        if(emailController.text != box1.get('email')){
                          print("yanlıs sifre veya mail adresi");
                        }else if(passwordController.text != box1.get('pass')){
                          print("yanlıs sifre vyea mail adresi");

                        }
                        else{
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomePage()));
    /*showDialog(context: context, builder: (context){
                            return SimpleDialog(
                              title: Text('Your submitted data '),
                              children: [
                            ListTile(
                                  leading: Icon(Icons.mail),
                                  title: Text(emailController.text.toString()),
                                ),
                                ListTile(
                                  leading: Icon(Icons.lock),
                                  title: Text(passwordController.text.toString()),
                                ),
                              ],
                            );
                          });*/

                        }}, child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text('Submit'),

                    )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Remember Me',style: TextStyle(color: Colors.red),),
                        Checkbox(value: isCh,
                            onChanged: (value){
                          isCh =! isCh;
                          setState(() {
                            
                          });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void login(){
  if(isCh){
    box1.put('email',emailController.value.text);
    box1.put('pass', passwordController.value.text);
  }
  }
}
