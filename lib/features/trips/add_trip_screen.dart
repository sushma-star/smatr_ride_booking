
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ridebooking/core/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../models/trip_model.dart';
import '../../models/ride_type.dart';
import '../../provider/trip_provider.dart';
import '../../provider/budget_provider.dart';

class AddTripScreen extends ConsumerStatefulWidget {
  final Trip? editTrip;
  const AddTripScreen({super.key, this.editTrip});

  @override
  ConsumerState<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends ConsumerState<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();

  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final fareController = TextEditingController();

  RideType rideType = RideType.mini;
  DateTime selectedDateTime = DateTime.now();

  double _enteredFare = 0;
  bool _isOverLimit = false;
  bool _isNearLimit = false;

  static const Color themeColor = AppColors.primary;

  @override
  void initState() {
    super.initState();
    if (widget.editTrip != null) {
      pickupController.text = widget.editTrip!.pickup;
      dropController.text = widget.editTrip!.drop;
      fareController.text = widget.editTrip!.fare.toString();
      rideType = widget.editTrip!.rideType;
      selectedDateTime = widget.editTrip!.dateTime;
      _enteredFare = widget.editTrip!.fare;
    }
  }

  void _recalculateBudget() {
    final budget = ref.read(budgetProvider);
    final remaining = budget.remainingFor(rideType);

    setState(() {
      _isOverLimit = _enteredFare > remaining;
      _isNearLimit =
          _enteredFare > remaining * 0.8 && _enteredFare <= remaining;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final trip = Trip(
      id: widget.editTrip?.id ?? const Uuid().v4(),
      pickup: pickupController.text.trim(),
      drop: dropController.text.trim(),
      rideType: rideType,
      fare: _enteredFare,
      status: widget.editTrip?.status ?? RideStatus.completed,
      dateTime: selectedDateTime,
    );

    if (widget.editTrip == null) {
      ref.read(tripProvider.notifier).addTrip(trip);
    } else {
     ref.read(tripProvider.notifier).updateTrip(trip);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final budget = ref.watch(budgetProvider);
    final remaining = budget.remainingFor(rideType);

    final cardColor = isDark ? Colors.grey[800]! : AppColors.cardLight;
    final inputFill = isDark ? Colors.grey[700]! : Colors.grey.shade100;
    final textColor = isDark ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? AppColors.black : Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.editTrip == null ? 'Book Ride' : 'Edit Ride'),
        backgroundColor: isDark ? AppColors.black: Colors.grey.shade100,
        foregroundColor: isDark ? AppColors.cardLight: AppColors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 16),
            child: Column(
              children: [
                _routeSection(cardColor, inputFill, textColor),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _rideTypeSection(cardColor, inputFill, textColor),
                        const SizedBox(height: 16),
                        _fareSection(remaining, cardColor, textColor,inputFill),
                        const SizedBox(height: 16),
                        _dateTimeSection(cardColor, textColor),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isOverLimit ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isOverLimit ? Colors.grey : themeColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              widget.editTrip == null ? 'Confirm Booking' : 'Update Ride',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.cardLight,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _routeSection(Color cardColor, Color inputFill, Color textColor) {
    return _cardContainer(
      cardColor: cardColor,
      child: Column(
        children: [
          _routeField(
              controller: pickupController,
              hint: 'Pickup Location',
              icon: Icons.trip_origin,
              color: Colors.green,
              fillColor: inputFill,
              textColor: textColor),
          const SizedBox(height: 12),
          _routeField(
              controller: dropController,
              hint: 'Drop Location',
              icon: Icons.location_on,
              color: Colors.red,
              fillColor: inputFill,
              textColor: textColor),
        ],
      ),
    );
  }

  Widget _rideTypeSection(Color cardColor, Color inputFill, Color textColor) {
    return _cardContainer(
      cardColor: cardColor,
      child: DropdownButtonFormField<RideType>(
        value: rideType,
        decoration: _inputDecoration('Ride Type', fillColor: inputFill),
        items: RideType.values.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type.label, style: TextStyle(color: textColor)),
          );
        }).toList(),
        onChanged: (v) {
          rideType = v!;
          _recalculateBudget();
        },
      ),
    );
  }

  Widget _fareSection(double remaining, Color cardColor, Color textColor,Color inputFill) {
    return _cardContainer(
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: fareController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('Estimated Fare', fillColor: inputFill)
                .copyWith(
              errorText: _isOverLimit
                  ? 'Exceeds remaining budget ₹${remaining.toInt()}'
                  : null,
            ),
            onChanged: (v) {
              _enteredFare = double.tryParse(v) ?? 0;
              _recalculateBudget();
            },
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter fare amount';
              if (_isOverLimit) return 'Over monthly budget';
              return null;
            },
            style: TextStyle(color: textColor),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                _isOverLimit
                    ? Icons.error
                    : _isNearLimit
                    ? Icons.warning
                    : Icons.check_circle,
                color: _isOverLimit
                    ? Colors.red
                    : _isNearLimit
                    ? Colors.orange
                    : Colors.green,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                _isOverLimit
                    ? 'Budget exceeded'
                    : _isNearLimit
                    ? 'Approaching budget limit'
                    : 'Within budget',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _isOverLimit
                      ? Colors.red
                      : _isNearLimit
                      ? Colors.orange
                      : Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Remaining: ₹${remaining.toInt()}',
            style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _dateTimeSection(Color cardColor, Color textColor) {
    return _cardContainer(
      cardColor: cardColor,
      child: ListTile(
        leading: Icon(Icons.schedule, color: textColor),
        title: Text(
          DateFormat('dd MMM yyyy • hh:mm a').format(selectedDateTime),
          style: TextStyle(color: textColor),
        ),
        trailing: TextButton(
          child: const Text('Change'),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              initialDate: selectedDateTime,
            );
            if (date == null) return;

            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(selectedDateTime),
            );
            if (time == null) return;

            setState(() {
              selectedDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
          },
        ),
      ),
    );
  }

  Widget _cardContainer({required Widget child, required Color cardColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _routeField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color color,
    required Color fillColor,
    required Color textColor,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: color),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: textColor),
      validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
    );
  }

  InputDecoration _inputDecoration(String label, {Color? fillColor}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: fillColor ?? Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
