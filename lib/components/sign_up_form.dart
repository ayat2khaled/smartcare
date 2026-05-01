import 'package:first_project/models/sign_up_model.dart';
import 'package:first_project/providers/auth_provider.dart';
import 'package:first_project/screens/home_screen.dart';
import 'package:first_project/screens/sign_in_screen.dart';
import 'package:first_project/utils/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_project/providers/rewards_provider.dart';
import 'package:first_project/providers/order_provider.dart';
import 'package:first_project/providers/booking_provider.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  SignUpModel model = SignUpModel();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProvider.signUp(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      showTopSnackBar(context, error);
    } else {
      // Load user specific data
      final email = authProvider.userEmail;
      final rewardsProvider = Provider.of<RewardsProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

      await rewardsProvider.loadForUser(email);
      await orderProvider.loadForUser(email);
      await bookingProvider.loadForUser(email);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    }
  }

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
              "Create your account to get started",
              style: TextStyle(color: subTextColor),
            ),
          ),

          const SizedBox(height: 30),

          Text("Full Name", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: textColor)),
          const SizedBox(height: 5),
          TextField(
            controller: nameController,
            style: TextStyle(color: textColor),
            textInputAction: TextInputAction.next,
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
            controller: emailController,
            style: TextStyle(color: textColor),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
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
            controller: passwordController,
            obscureText: model.isPasswordHidden,
            style: TextStyle(color: textColor),
            textInputAction: TextInputAction.next,
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
            controller: confirmPasswordController,
            obscureText: model.isPasswordHidden1,
            style: TextStyle(color: textColor),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSignUp(),
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
              onPressed: _isLoading ? null : _handleSignUp,
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 18)),
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