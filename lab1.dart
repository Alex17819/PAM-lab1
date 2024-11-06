import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const LoanCalculatorApp());
}

class LoanCalculatorApp extends StatelessWidget {
  const LoanCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoanCalculator(),
    );
  }
}

class LoanCalculator extends StatefulWidget {
  const LoanCalculator({super.key});

  @override
  _LoanCalculatorState createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  double _months = 1;
  double _monthlyPayment = 0.0;
  String _errorMessage = ''; // Variable to store any error messages

  void _calculateLoan() {
    setState(() {
      _errorMessage = ''; // Reset error message before each calculation
    });

    // Check if the input fields are empty
    if (_amountController.text.isEmpty || _interestController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both amount and interest rate.';
      });
      return;
    }

    try {
      // Parse the input values
      double amount = double.parse(_amountController.text);
      double interest = double.parse(_interestController.text);

      // Validate the input values
      if (amount <= 0) {
        setState(() {
          _errorMessage = 'The amount must be greater than zero.';
        });
        return;
      }
      if (interest < 0) {
        setState(() {
          _errorMessage = 'The interest rate cannot be negative.';
        });
        return;
      }

      // Calculate monthly interest rate
      double monthlyInterest = interest / 100 / 12;

      // Handle zero interest rate (no loan interest)
      if (monthlyInterest == 0) {
        _monthlyPayment = amount / _months;
      } else {
        // Calculate monthly payment using the loan formula
        double monthlyPayment = amount * monthlyInterest /
            (1 - pow(1 + monthlyInterest, -_months));

        setState(() {
          _monthlyPayment = monthlyPayment;
        });
      }
    } catch (e) {
      // Catch any parsing errors or calculation errors
      setState(() {
        _errorMessage = 'Invalid input. Please enter valid numbers.';
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Loan Calculator',
        style: GoogleFonts.archivoBlack(
          textStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start, // Ensure children are aligned to the start
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter amount',
              hintText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Enter number of months: ${_months.round()}',
            textAlign: TextAlign.left, // Explicitly set text alignment to left
          ),
          Slider(
            value: _months,
            min: 1,
            max: 60,
            divisions: 59,
            label: _months.round().toString(),
            activeColor: const Color.fromARGB(255, 0, 42, 119), // Set active color to blue
            inactiveColor: const Color.fromARGB(255, 79, 137, 184), // Set inactive color to a lighter blue
            onChanged: (double value) {
              setState(() {
                _months = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _interestController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter % per month',
              hintText: 'Percent',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 0, 42, 119), // Set border color to blue
                ),
              ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
              'You will pay the approximate amount monthly:',
              style: GoogleFonts.archivoBlack(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),
            ),
            Center(
              child: Text(
              '${_monthlyPayment.toStringAsFixed(2)}€',
                style: GoogleFonts.archivoBlack(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 42, 119),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0), // Add top margin of 10
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateLoan,
                  child: const Text('Calculate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 42, 119), // Set background color to blue
                    foregroundColor: Colors.white, // Set text color to white
                    textStyle: const TextStyle(fontSize: 26), // Set text style
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Add border radius
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
