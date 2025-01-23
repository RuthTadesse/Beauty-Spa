import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../successPage.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final double price;
  final double tax;
  final String selectedSlot;
  final String selectedSpecialist;
  final String selectedCategory;
  final String selectedDate;

  const PaymentPage({
    Key? key,
    required this.price,
    required this.tax,
    required this.selectedSlot,
    required this.selectedSpecialist,
    required this.selectedCategory,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _isLoading = false;

  Future<void> _storeDataInFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'cardNumber': _cardNumberController.text,
        'expiryDate': _expiryDateController.text,
        'cvv': _cvvController.text,
        'specialist': widget.selectedSpecialist,
        'category': widget.selectedCategory,
        'date': widget.selectedDate,
        'slot': widget.selectedSlot,
        'price': widget.price,
        'tax': widget.tax,
        'total': widget.price + widget.tax,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to store data: $e'),
          backgroundColor: Colors.red,
        ),
      );
      throw e;
    }
  }

  bool _isFutureDate(String expiryDate) {
    try {
      final parts = expiryDate.split('/');
      if (parts.length != 2) return false;
      final month = int.parse(parts[0]);
      final year = int.parse('20${parts[1]}');

      if (month < 1 || month > 12) return false;
      final now = DateTime.now();
      final expiry = DateTime(year, month);
      return expiry.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.price + widget.tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 251, 251, 251),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment Summary Section
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(250, 246, 247, 1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color.fromARGB(255, 235, 207, 217),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 226, 138, 176),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Price: \$${widget.price.toStringAsFixed(2)}'),
                          Text('Tax: \$${widget.tax.toStringAsFixed(2)}'),
                          Divider(
                              color: const Color.fromARGB(255, 247, 208, 221)),
                          Text(
                            'Total: \$${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 225, 132, 173),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelAndInput(
                            label: 'First Name',
                            controller: _firstNameController,
                            placeholder: 'Enter your first name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First Name is required';
                              }
                              if (value.length <= 4) {
                                return 'First Name must be more than 4 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildLabelAndInput(
                            label: 'Last Name',
                            controller: _lastNameController,
                            placeholder: 'Enter your last name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last Name is required';
                              }
                              if (value.length <= 4) {
                                return 'Last Name must be more than 4 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildLabelAndInput(
                            label: 'Card Number',
                            controller: _cardNumberController,
                            placeholder: 'XXXX XXXX XXXX XXXX',
                            isCardNumber: true,
                          ),
                          const SizedBox(height: 10),
                          _buildLabelAndInput(
                            label: 'Expiry Date',
                            controller: _expiryDateController,
                            placeholder: 'MM/YY',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Expiry Date is required';
                              }
                              if (!_isFutureDate(value)) {
                                return 'Expiry Date must be in the future';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildLabelAndInput(
                            label: 'CVV',
                            controller: _cvvController,
                            placeholder: '123',
                            isCVV: true,
                          ),
                          const SizedBox(height: 24),

                          // Gradient Proceed Button
                          InkWell(
                            onTap: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await _storeDataInFirebase();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SuccessPage(),
                                    ),
                                  );
                                } catch (e) {
                                  // Error handling is already done in _storeDataInFirebase
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All fields are required'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFD66986),
                                    Color(0xFFED9598),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Proceed to Payment',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLabelAndInput({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    String? Function(String?)? validator,
    bool isCardNumber = false,
    bool isCVV = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: isCardNumber || isCVV ? TextInputType.number : null,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return '$label is required';
                }
                if (isCardNumber && (!RegExp(r'^\d{16}$').hasMatch(value))) {
                  return 'Enter a valid 16-digit card number';
                }
                if (isCVV && (!RegExp(r'^\d{3}$').hasMatch(value))) {
                  return 'Enter a valid 3-digit CVV';
                }
                return null;
              },
        ),
      ],
    );
  }
}
