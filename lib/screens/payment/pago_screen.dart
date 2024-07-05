import 'package:flutter/material.dart';

class MetodoPagoScreen extends StatefulWidget {
  const MetodoPagoScreen({super.key});

  @override
  State<MetodoPagoScreen> createState() => _MetodoPagoScreenState();
}

class _MetodoPagoScreenState extends State<MetodoPagoScreen> {
  String? _selectedPaymentMethod;
  final _creditCardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  DateTime? _selectedExpiryDate;
  String? _cardType;

  @override
  void dispose() {
    _creditCardNumberController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
      helpText: 'Selecciona la fecha de expiración',
    );
    if (picked != null && picked != _selectedExpiryDate) {
      setState(() {
        _selectedExpiryDate = picked;
      });
    }
  }

  void _identifyCardType(String input) {
    if (input.startsWith(RegExp(r'4'))) {
      _cardType = 'visa';
    } else if (input.startsWith(RegExp(r'5[1-5]'))) {
      _cardType = 'mastercard';
    } else {
      _cardType = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Método de Pago'),
      ),
      body: _selectedPaymentMethod == 'credit_card'
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ingresa los datos de tu tarjeta de crédito',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _creditCardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Número de Tarjeta',
                        border: const OutlineInputBorder(),
                        prefixIcon: _cardType != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/payment/$_cardType.png',
                                  width: 30,
                                  height: 30,
                                ),
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _identifyCardType(value);
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectExpiryDate(context),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: TextEditingController(
                                  text: _selectedExpiryDate == null
                                      ? ''
                                      : '${_selectedExpiryDate!.month}/${_selectedExpiryDate!.year % 100}',
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Fecha de Expiración (MM/AA)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder(),
                              counterText:
                                  '', 
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          String cardNumber = _creditCardNumberController.text;
                          String expiryDate = _selectedExpiryDate != null
                              ? '${_selectedExpiryDate!.month}/${_selectedExpiryDate!.year % 100}'
                              : '';
                          String cvv = _cvvController.text;
                        },
                        child: const Text('Confirmar Pago'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecciona tu método de pago',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: const Text('Tarjeta de Crédito'),
                      trailing: Radio<String>(
                        value: 'credit_card',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_balance_wallet),
                      title: const Text('PayPal'),
                      trailing: Radio<String>(
                        value: 'paypal',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.money),
                      title: const Text('Pago en Efectivo'),
                      trailing: Radio<String>(
                        value: 'cash',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _selectedPaymentMethod != null
                            ? () {
                                if (_selectedPaymentMethod == 'credit_card') {
                                  setState(() {
                                    // Muestra la vista de tarjeta de crédito
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Método de pago seleccionado: $_selectedPaymentMethod')),
                                  );
                                }
                              }
                            : null,
                        child: const Text('Continuar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
