import 'package:first_project/models/sign_in_model.dart';
import 'package:first_project/screens/sign_up_screen.dart';
import 'package:first_project/utils/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:first_project/screens/home_screen.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  SignInModel model = SignInModel();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE2E8F0) : Colors.black;
    final subTextColor = isDark ? const Color(0xFF94A3B8) : Colors.grey;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const SizedBox(height: 80),
          Center(
            child: Text(
              "Sign In",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Center(
            child: Text(
              "Hi! welcome back, You've been missed",
              style: TextStyle(color: subTextColor),
            ),
          ),

          const SizedBox(height: 40),

          Text(
            "Email",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            style: TextStyle(color: textColor),
            controller: emailController,
            decoration: InputDecoration(
              hintText: "Enter your email",
              hintStyle: TextStyle(color: subTextColor),
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Password",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            obscureText: model.isPasswordHidden,
            controller: passwordController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: "Enter your password",
              hintStyle: TextStyle(color: subTextColor),
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  model.isPasswordHidden
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: subTextColor,
                ),
                onPressed: () {
                  setState(() {
                    model.isPasswordHidden = !model.isPasswordHidden;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              const Spacer(),
              Text(
                "Forget password?",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  showTopSnackBar(context, "Please enter email and password");
                  return;
                } else if (emailController.text == "ayat@gmail.com" &&
                    passwordController.text == "123456") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  showTopSnackBar(context, "Invalid email or password");
                }
              },
              child: const Text(
                "Log In",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(child: Divider(thickness: 1, color: borderColor)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Or",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ),
              Expanded(child: Divider(thickness: 1, color: borderColor)),
            ],
          ),

          const SizedBox(height: 25),

          Center(
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: textColor),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
