import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rwanda Internet Prediction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();
  final _cellularController = TextEditingController();
  final _broadbandController = TextEditingController();

  String? _result;
  bool _isError = false;
  bool _isLoading = false;

  static const String _apiUrl =
      'https://linear-regression-model-2-f5pb.onrender.com/predict';

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _result = null;
      _isError = false;
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'year': int.parse(_yearController.text),
          'cellular_subscription': double.parse(_cellularController.text),
          'broadband_subscription': double.parse(_broadbandController.text),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _result =
              '${data['predicted_internet_users'].toString()} users';
          _isError = false;
        });
      } else {
        setState(() {
          _result = data['detail'] ?? 'An error occurred. Please try again.';
          _isError = true;
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Failed to connect to the server. Check your internet connection.';
        _isError = true;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _cellularController.dispose();
    _broadbandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.wifi, color: Colors.white, size: 40),
                    const SizedBox(height: 12),
                    const Text(
                      'Rwanda Internet\nUsers Predictor',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the values below to predict internet usage',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Form card
              Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Prediction Inputs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildLabel('Year', '1998 – 2025'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _yearController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                              hintText: 'e.g. 2020',
                              prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Year is required';
                              final val = int.tryParse(v);
                              if (val == null) return 'Enter a valid year';
                              if (val < 1998 || val > 2025) return 'Year must be between 1998 and 2025';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildLabel('Cellular Subscription', '0.0 – 5.0'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _cellularController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              hintText: 'e.g. 0.75',
                              prefixIcon: Icon(Icons.smartphone_outlined, size: 20),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Cellular subscription is required';
                              final val = double.tryParse(v);
                              if (val == null) return 'Enter a valid number';
                              if (val < 0.0 || val > 5.0) return 'Value must be between 0.0 and 5.0';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildLabel('Broadband Subscription', '0.0 – 5.0'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _broadbandController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              hintText: 'e.g. 0.30',
                              prefixIcon: Icon(Icons.router_outlined, size: 20),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Broadband subscription is required';
                              final val = double.tryParse(v);
                              if (val == null) return 'Enter a valid number';
                              if (val < 0.0 || val > 5.0) return 'Value must be between 0.0 and 5.0';
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _predict,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1565C0),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Predict',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Result area
              if (_result != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _isError
                          ? const Color(0xFFFFF3F3)
                          : const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isError
                            ? const Color(0xFFFFCDD2)
                            : const Color(0xFFBBDEFB),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _isError ? Icons.error_outline : Icons.check_circle_outline,
                          color: _isError
                              ? const Color(0xFFD32F2F)
                              : const Color(0xFF1565C0),
                          size: 32,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _isError ? 'Error' : 'Predicted Internet Users',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _isError
                                ? const Color(0xFFD32F2F)
                                : const Color(0xFF1565C0),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _result!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _isError ? 14 : 22,
                            fontWeight: FontWeight.bold,
                            color: _isError
                                ? const Color(0xFFD32F2F)
                                : const Color(0xFF1A1A2E),
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

  Widget _buildLabel(String label, String range) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A2E),
          ),
        ),
        Text(
          range,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
