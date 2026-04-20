import 'package:first_project/models/sign_up_model.dart';
import 'package:first_project/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_project/screens/home_screen.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  SignUpModel model = SignUpModel();

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
              "Sign Up",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),

          const SizedBox(height: 10),

          Center(
            child: Text(
              "Hi! welcome back ,You've been missed",
              style: TextStyle(color: subTextColor),
            ),
          ),

          const SizedBox(height: 30),

          Text("Full Name", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: textColor)),
          const SizedBox(height: 5),
          TextField(
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: "Enter your Full name",
              hintStyle: TextStyle(color: subTextColor),
              filled: true, fillColor: cardColor,
              border: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
            ),
          ),

          const SizedBox(height: 10),

          Text("Email", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: textColor)),
          const SizedBox(height: 5),
          TextField(
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: "Enter your email",
              hintStyle: TextStyle(color: subTextColor),
              filled: true, fillColor: cardColor,
              border: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
            ),
          ),

          const SizedBox(height: 10),

          Text("Password", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: textColor)),
          const SizedBox(height: 5),
          TextField(
            obscureText: model.isPasswordHidden,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: "Enter your password",
              hintStyle: TextStyle(color: subTextColor),
              filled: true, fillColor: cardColor,
              border: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
              suffixIcon: IconButton(
                icon: Icon(model.isPasswordHidden ? Icons.visibility_off : Icons.visibility, color: subTextColor),
                onPressed: () { setState(() { model.isPasswordHidden = !model.isPasswordHidden; }); },
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: textColor)),
          const SizedBox(height: 5),
          TextField(
            obscureText: model.isPasswordHidden1,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: "Confirm your password",
              hintStyle: TextStyle(color: subTextColor),
              filled: true, fillColor: cardColor,
              border: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
              suffixIcon: IconButton(
                icon: Icon(model.isPasswordHidden1 ? Icons.visibility_off : Icons.visibility, color: subTextColor),
                onPressed: () { setState(() { model.isPasswordHidden1 = !model.isPasswordHidden1; }); },
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: Divider(thickness: 1, color: borderColor)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("Or", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
              ),
              Expanded(child: Divider(thickness: 1, color: borderColor)),
            ],
          ),

          const SizedBox(height: 20),

          Center(
            child: RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: textColor),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignIn()));
                      },
                      child: Text("LogIn", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
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