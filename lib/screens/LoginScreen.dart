import 'package:shared_preferences/shared_preferences.dart';
import 'package:distribook/api/impl/auth.dart';
import 'package:distribook/api/index.dart';
import 'package:distribook/components/CustomButton.dart';
import 'package:distribook/components/CustomText.dart';
import 'package:distribook/components/CustomTextField.dart';
import 'package:distribook/components/Navbar.dart';
import 'package:distribook/components/Snackbar.dart';
import 'package:distribook/constants/index.dart';
import 'package:distribook/exceptions/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:distribook/requests/login_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _databaseController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  bool isLoadingLogin = false;
  bool showAdvanced = false;

  @override
  void initState() {
    super.initState();
    loadSavedSettings();
  }

  void loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _databaseController.text = prefs.getString('db') ?? 'hrm';
      _urlController.text =
          prefs.getString('base_url') ?? 'http://145.223.21.247:6311';
    });
  }

  void performLogin(String username, String password, String database) async {
    try {
      await httpClient.setBaseUrl(_urlController.text);

      LoginRequest loginRequest = LoginRequest(
          email: username, password: password);

      bool isSuccess = await processLogin(context, loginRequest);
      if (!mounted) return;
      if (!isSuccess) {
        showErrorSnackbar(context, "Gagal login");
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Navbar()));
        showSuccessSnackbar(context, "Selamat datang");
      }
    } catch (error, stackTrace) {
      String errorMessage = ErrorHandler.handleError(error);
      showErrorSnackbar(context, errorMessage);
      ErrorHandler.logError(error, stackTrace, context: 'GET /some-endpoint');
    } finally {
      setState(() {
        isLoadingLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Image.asset(
                    'assets/logo/edistri.png',
                    width: MediaQuery.of(context).size.width * 0.10,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/welcome illustration.svg',
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const SizedBox(height: 24),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: CustomText(
                      text: "Masuk",
                      textStyle: TextStyle(
                          fontSize: TITLE_FONTSIZE,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  child: CustomText(
                      text:
                          "Aplikasi yang dapat memudahkan anda dalam mengelola data karyawan di Spread, mulai dari data karyawan, data absensi, data cuti, data penggajian, dan data lainnya."),
                  margin: EdgeInsets.only(bottom: 24, top: 12),
                ),
                CustomTextField(
                  labelText: 'Email',
                  controller: _usernameController,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  labelText: 'Password',
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                // if (showAdvanced) ...[
                //   CustomTextField(
                //     labelText: 'Database',
                //     controller: _databaseController,
                //     obscureText: false,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Database is required';
                //       }
                //       return null;
                //     },
                //   ),
                //   CustomTextField(
                //     labelText: 'URL',
                //     controller: _urlController,
                //     obscureText: false,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'URL is required';
                //       }
                //       return null;
                //     },
                //   ),
                // ],
                // TextButton(
                //   onPressed: () {
                //     setState(() {
                //       showAdvanced = !showAdvanced;
                //     });
                //   },
                //   child: Text(showAdvanced ? 'Hide Advanced' : 'Show Advanced'),
                // ),
                SizedBox(height: 12),
                CustomButton(
                  text: isLoadingLogin ? '...' : 'Login',
                  onPressed: () {
                    if (isLoadingLogin || !_formKey.currentState!.validate())
                      return;
                    setState(() {
                      isLoadingLogin = true;
                    });
                    performLogin(_usernameController.text,
                        _passwordController.text, _databaseController.text);
                  },
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
