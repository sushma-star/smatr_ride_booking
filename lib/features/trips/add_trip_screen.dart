
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/trip_model.dart';
import '../../models/ride_type.dart';

import 'package:intl/intl.dart';

import '../../provider/trip_provider.dart';


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

  static const Color themeColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    if (widget.editTrip != null) {
      pickupController.text = widget.editTrip!.pickup;
      dropController.text = widget.editTrip!.drop;
      fareController.text = widget.editTrip!.fare.toString();
      rideType = widget.editTrip!.rideType;
      selectedDateTime = widget.editTrip!.dateTime;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final trip = Trip(
      id: widget.editTrip?.id ?? const Uuid().v4(),
      pickup: pickupController.text.trim(),
      drop: dropController.text.trim(),
      rideType: rideType,
      fare: double.parse(fareController.text),
      status: widget.editTrip?.status ?? RideStatus.requested,
      dateTime: selectedDateTime,
    );

    widget.editTrip == null
        ? ref.read(tripProvider.notifier).addTrip(trip)
        : ref.read(tripProvider.notifier).updateTrip(trip);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      appBar: AppBar(
        title: Text(widget.editTrip == null ? 'Book Ride' : 'Edit Ride'),
        elevation: 0,
        backgroundColor:Color(0xFFF3F3F3),
        centerTitle: true,
        foregroundColor: Colors.black,


      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 16),
            child: Column(
              children: [
                _routeSection(),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _rideTypeSection(),
                        const SizedBox(height: 16),
                        _fareSection(),
                        const SizedBox(height: 16),
                        _dateTimeSection(),
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
          color: Colors.grey.shade50,
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
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
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _routeSection() {
    return _cardContainer(
      child: Column(
        children: [
          _routeField(
            controller: pickupController,
            hint: 'Pickup Location',
            icon: Icons.trip_origin,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _routeField(
            controller: dropController,
            hint: 'Drop Location',
            icon: Icons.location_on,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  IconData rideTypeIcon(RideType type) {
    switch (type) {
      case RideType.bike:
        return Icons.two_wheeler;
      case RideType.auto:
        return Icons.local_taxi;
      case RideType.mini:
        return Icons.directions_car;
      case RideType.sedan:
        return Icons.airport_shuttle;
    }
  }

  Widget _rideTypeSection() {
    return _cardContainer(
      child: DropdownButtonFormField<RideType>(
        dropdownColor: Colors.white,
        value: rideType,
        decoration: _inputDecoration('Ride Type', Icons.directions_car),
        items: RideType.values.map((type) {
          return DropdownMenuItem<RideType>(
            value: type,
            child: Row(
              children: [
                Icon(
                  rideTypeIcon(type),
                  size: 20,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 10),
                Text(
                  type.label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (v) => setState(() => rideType = v!),
      ),
    );
  }

  Widget _fareSection() {
    return _cardContainer(
      child: TextFormField(
        controller: fareController,
        keyboardType: TextInputType.number,
        decoration: _inputDecoration('Estimated Fare', Icons.currency_rupee),
        validator: (v) => v == null || v.isEmpty ? 'Enter fare amount' : null,
      ),
    );
  }

  Widget _dateTimeSection() {
    return _cardContainer(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.schedule),
        title: Text(
          DateFormat('dd MMM yyyy • hh:mm a').format(selectedDateTime),
          style: const TextStyle(fontWeight: FontWeight.w600),
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


  Widget _cardContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _routeField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color color,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: color),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
       filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}



