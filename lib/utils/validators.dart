String? validateMobile(String? value) {
  if (value == null) {
    return 'Enter phone number';
  }
  if (value.trim().isEmpty) {
    return 'Enter phone number';
  }
  if (value.trim().length != 10) {
    return 'Enter valid 10 digit number';
  }
  return null;
}

String? validateClinicName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Doctor\'s name is required';
  }
  return null;
}

String? validateDoctorName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Clinics\'s name is required';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null) {
    return null;
  }
  if (value.trim().isEmpty) {
    return null;
  }

  if (!RegExp(
          r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
      .hasMatch(value.toLowerCase())) {
    return 'Please enter a valid email (optional)';
  }
  return null;
}

String? validatePincode(String? value) {
  if (value == null) {
    return null;
  }
  if (value.trim().isEmpty) {
    return null;
  }
  if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value)) {
    return 'Please enter a valid 6-digit pincode (optional)';
  }
  return null;
}

String? validateApartment(String? value) {
  if (value == null) {
    return null;
  }
  if (value.trim().isEmpty) {
    return null;
  }
  return null;
}

String? validateCity(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'city is required';
  }
  return null;
}

String? validateAddress(String? value) {
  print(value == null || value.trim().isEmpty);
  if (value == null || value.trim().isEmpty) {
    return 'Address is required';
  }
  return null;
}
