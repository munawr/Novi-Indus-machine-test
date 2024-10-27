import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/register_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Patient'),
        backgroundColor: const Color.fromARGB(255, 115, 44, 146),
      ),
      body: Consumer<RegisterProvider>(
        builder: (context, provider, _) {
          if (provider.state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPersonalInfoFields(provider),
                  const SizedBox(height: 24),
                  _buildLocationDropdown(provider),
                  const SizedBox(height: 24),
                  _buildBranchDropdown(provider),
                  const SizedBox(height: 24),
                  _buildGenderSpecificTreatments(provider),
                  const SizedBox(height: 24),
                  _buildPaymentDetailsSection(provider, context),
                  const SizedBox(height: 24),
                  _buildSubmitButton(provider, context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoFields(RegisterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: provider.state.name,
          decoration: _inputDecoration('Name'),
          onChanged: (value) => provider.updateField('name', value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: provider.state.executive,
          decoration: _inputDecoration('Executive'),
          onChanged: (value) => provider.updateField('executive', value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: provider.state.phone,
          decoration: _inputDecoration('Phone'),
          keyboardType: TextInputType.phone,
          onChanged: (value) => provider.updateField('phone', value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: provider.state.address,
          decoration: _inputDecoration('Address'),
          onChanged: (value) => provider.updateField('address', value),
        ),
      ],
    );
  }

  // Helper method to create a consistent InputDecoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: const Color.fromARGB(255, 34, 11, 39)), // Purple label
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: const Color.fromARGB(255, 34, 11, 39)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: const Color.fromARGB(255, 34, 11, 39), width: 1.5),
      ),
      border: const OutlineInputBorder(),
    );
  }

  Widget _buildLocationDropdown(RegisterProvider provider) {
    return DropdownButtonFormField<Location>(
      value: provider.state.selectedLocation,
      decoration: _inputDecoration('Location'),
      items: Location.values.map((location) {
        return DropdownMenuItem(
          value: location,
          child: Text(location.toString().split('.').last),
        );
      }).toList(),
      onChanged: (value) => provider.updateField('selectedLocation', value),
      validator: (value) {
        if (value == null) {
          return 'Please select a location';
        }
        return null;
      },
    );
  }

  Widget _buildBranchDropdown(RegisterProvider provider) {
    return DropdownButtonFormField<String>(
      value: provider.state.selectedBranch.isNotEmpty
          ? provider.state.selectedBranch
          : null,
      decoration: _inputDecoration('Branch'),
      items: provider.state.branches
          .map((branch) {
            return DropdownMenuItem(
              value: branch.id.toString(),
              child: Text(branch.name ?? 'Unknown Branch'),
            );
          })
          .toSet()
          .toList(),
      onChanged: (value) => provider.updateField('selectedBranch', value),
      validator: (value) {
        if (value == null) {
          return 'Please select a branch';
        }
        return null;
      },
    );
  }

  Widget _buildGenderSpecificTreatments(RegisterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender-Specific Treatments',
            style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTreatmentCheckboxList(provider, 'Male Treatments',
            provider.state.selectedMaleTreatments, Gender.Male),
        _buildTreatmentCheckboxList(provider, 'Female Treatments',
            provider.state.selectedFemaleTreatments, Gender.Female),
      ],
    );
  }

  Widget _buildTreatmentCheckboxList(RegisterProvider provider, String title,
      List<String> selectedTreatments, Gender gender) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.state.treatments.length,
          itemBuilder: (context, index) {
            final treatment = provider.state.treatments[index];
            final isSelected =
                selectedTreatments.contains(treatment.id.toString());

            return CheckboxListTile(
              title: Text(treatment.name ?? 'Unknown Treatment'),
              value: isSelected,
              onChanged: (bool? value) {
                provider.updateTreatments(
                  gender == Gender.Male
                      ? (isSelected
                          ? (selectedTreatments..remove(treatment.id))
                          : (selectedTreatments..add(treatment.id.toString())))
                      : selectedTreatments,
                  gender == Gender.Female
                      ? (isSelected
                          ? (selectedTreatments..remove(treatment.id))
                          : (selectedTreatments..add(treatment.id.toString())))
                      : selectedTreatments,
                );
              },
              activeColor: const Color.fromARGB(255, 46, 14, 52), 
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsSection(
      RegisterProvider provider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: provider.state.totalAmount.toString(),
          decoration: _inputDecoration('Total Amount'),
          keyboardType: TextInputType.number,
          onChanged: (value) => provider.updateField(
              'totalAmount', double.tryParse(value) ?? 0.0),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: provider.state.discountAmount.toString(),
          decoration: _inputDecoration('Discount Amount'),
          keyboardType: TextInputType.number,
          onChanged: (value) => provider.updateField(
              'discountAmount', double.tryParse(value) ?? 0.0),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: provider.state.advanceAmount.toString(),
          decoration: _inputDecoration('Advance Amount'),
          keyboardType: TextInputType.number,
          onChanged: (value) => provider.updateField(
              'advanceAmount', double.tryParse(value) ?? 0.0),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: provider.state.balanceAmount.toString(),
          decoration: _inputDecoration('Balance Amount'),
          keyboardType: TextInputType.number,
          readOnly: true,
        ),
        const SizedBox(height: 16),
        _buildPaymentMethodDropdown(provider),
        const SizedBox(height: 16),
        _buildDateTimeField(provider, context),
      ],
    );
  }

  Widget _buildPaymentMethodDropdown(RegisterProvider provider) {
    return DropdownButtonFormField<PaymentMethod>(
      value: provider.state.selectedPaymentMethod,
      decoration: _inputDecoration('Payment Method'),
      items: PaymentMethod.values.map((method) {
        return DropdownMenuItem(
          value: method,
          child: Text(method.toString().split('.').last),
        );
      }).toList(),
      onChanged: (value) =>
          provider.updateField('selectedPaymentMethod', value),
    );
  }

  Widget _buildDateTimeField(RegisterProvider provider, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(now.year - 1),
          lastDate: DateTime(now.year + 1),
        );

        if (selectedDate != null) {
          final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
          provider.updateField('dateAndTime', formattedDate);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          initialValue: provider.state.dateAndTime,
          decoration: _inputDecoration('Date and Time'),
          onChanged: (value) => provider.updateField('dateAndTime', value),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(RegisterProvider provider, BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.purple[700],
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    onPressed: () async {
      try {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            );
          },
        );

        // Register patient
        await provider.registerPatient();
        
        // Close loading dialog
        Navigator.pop(context);

        final error = provider.state.error;
        if (error != null) {
          _showErrorMessage(context, error);
        } else {
          // Generate PDF after successful registration
          await provider.generateAndDownloadPDF();
          
          // Show success message with custom dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600]),
                    const SizedBox(width: 8),
                    const Text('Success'),
                  ],
                ),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patient registered successfully!'),
                    SizedBox(height: 8),
                    Text('PDF has been generated and saved.',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Optionally navigate back or to another screen
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        // Close loading dialog if open
        if (context.mounted) {
          Navigator.pop(context);
          _showErrorMessage(context, 'An unexpected error occurred: $e');
        }
      }
    },
    child: const Text('Register'),
  );
}

void _showErrorMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[600]),
            const SizedBox(width: 8),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
}
