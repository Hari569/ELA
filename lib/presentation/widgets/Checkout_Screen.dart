import 'package:flutter/material.dart';
import '/models/product.dart';
import '/models/order.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Product> cartItems;
  final double total;

  const CheckoutScreen({Key? key, required this.cartItems, required this.total})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';
  String _paymentMethod = 'Pay on Delivery/Cash on Delivery';
  String _deliveryInstructions = '';
  bool _useGiftCard = false;
  String _promoCode = '';

  // Payment details
  String _cardNumber = '';
  String _cardExpiry = '';
  String _cardCVV = '';
  String _upiId = '';

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      bool orderProcessed = await _processOrder();

      if (orderProcessed) {
        final order = Order(
          id: const Uuid().v4(),
          items: widget.cartItems,
          total: widget.total,
          status: _paymentMethod == 'Pay on Delivery/Cash on Delivery'
              ? 'Pending Payment'
              : 'Paid',
          date: DateTime.now(),
        );

        // Show order confirmation
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Order Confirmed'),
              content: Text(
                  'Your order (ID: ${order.id}) has been placed successfully.\n'
                  'Status: ${order.status}'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<bool> _processOrder() async {
    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Processing your order..."),
            ],
          ),
        );
      },
    );

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    // Close the processing dialog
    Navigator.of(context).pop();

    bool orderProcessed = false;

    switch (_paymentMethod) {
      case 'Pay on Delivery/Cash on Delivery':
        orderProcessed = true; // Always process for COD
        break;
      case 'Credit Card':
      case 'Debit Card':
        orderProcessed = await _processCardPayment();
        break;
      case 'UPI':
        orderProcessed = await _processUPIPayment();
        break;
      default:
        // Handle error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Invalid payment method selected.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
    }

    return orderProcessed;
  }

  Future<bool> _processCardPayment() async {
    // Simulate redirecting to a card payment portal
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${_paymentMethod} Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card Number'),
                onChanged: (value) => _cardNumber = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
                onChanged: (value) => _cardExpiry = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'CVV'),
                onChanged: (value) => _cardCVV = value,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Pay'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<bool> _processUPIPayment() async {
    // Simulate choosing a UPI app
    String? chosenApp = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose UPI App'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'GooglePay'),
              child: const Text('Google Pay'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'PhonePe'),
              child: const Text('PhonePe'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Paytm'),
              child: const Text('Paytm'),
            ),
          ],
        );
      },
    );

    if (chosenApp != null) {
      // Simulate UPI payment in the chosen app
      bool? result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$chosenApp UPI Payment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'UPI ID'),
                  onChanged: (value) => _upiId = value,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Pay'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      return result ?? false;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order now')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _buildShippingInfo(),
            _buildOrderSummary(),
            _buildPaymentMethod(),
            _buildGiftCardPromoCode(),
            _buildDeliveryAddress(),
            _buildDeliveryInstructions(),
            _buildDeliveryDate(),
            _buildItemDetails(),
            _buildTermsAndConditions(),
            _buildPlaceOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping to: $_name',
                style: Theme.of(context).textTheme.subtitle1),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your name' : null,
              onSaved: (value) => _name = value!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    double savings = widget.cartItems.fold(
        0,
        (sum, item) =>
            sum + (item.price * 0.8)); // Assuming 20% discount for example
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Items: ₹${widget.total.toStringAsFixed(2)}'),
            const Text('Delivery: ₹0.00'),
            Text('Order Total: ₹${widget.total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Your Savings: ₹${savings.toStringAsFixed(2)} (20%)',
                style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paying with:'),
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _paymentMethod = newValue!;
                });
              },
              items: <String>[
                'Pay on Delivery/Cash on Delivery',
                'Credit Card',
                'Debit Card',
                'UPI'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (_paymentMethod == 'Pay on Delivery/Cash on Delivery')
              const Text('Cash, UPI and Cards accepted',
                  style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftCardPromoCode() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Add Gift Card or Promo Code'),
              value: _useGiftCard,
              onChanged: (bool? value) {
                setState(() {
                  _useGiftCard = value!;
                });
              },
            ),
            if (_useGiftCard)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Enter code'),
                onSaved: (value) => _promoCode = value ?? '',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deliver to'),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your address' : null,
              onSaved: (value) => _address = value!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInstructions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration:
              const InputDecoration(labelText: 'Add delivery instructions'),
          onSaved: (value) => _deliveryInstructions = value ?? '',
        ),
      ),
    );
  }

  Widget _buildDeliveryDate() {
    final deliveryDate = DateTime.now().add(const Duration(days: 7));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Get it by'),
            Text(
              '${DateFormat('EEEE dd MMM').format(deliveryDate)}',
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const Text('FREE Delivery'),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Arriving ${DateFormat('dd MMM yyyy').format(DateTime.now().add(const Duration(days: 7)))}'),
            ...widget.cartItems.map((item) => ListTile(
                  leading: Image.network(item.imageUrl,
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item.name),
                  subtitle: Text('₹${item.price.toStringAsFixed(2)}'),
                  trailing: const Text('Quantity: 1'),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return const Text(
      'By placing your order, you agree to ELA\'s privacy notice and conditions of use.',
      style: TextStyle(fontSize: 12),
    );
  }

  Widget _buildPlaceOrderButton() {
    return ElevatedButton(
      child: const Text('Place your order'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.green,
      ),
      onPressed: _submitOrder,
    );
  }
}
