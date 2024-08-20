class KValidator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب.';
    }
    return null;
  }

  static String? validateNumber(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال $fieldName.';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return 'من فضلك أدخل رقما صالحا';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الالكتروني مطلوب.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'عنوان البريد الإلكتروني غير صالح.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'الرقم السري يجب الا يقل عن 6 احرف على الاقل.';
    }

    // // Check for uppercase letters
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return "يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل(A-a).";
    // }

    // Check for numbers
    // if (!value.contains(RegExp(r'[0-9]'))) {
    //   return 'يجب ان تحتوي كلمة المرور على الاقل رقما واحدا.';
    // }

    // Check for special characters
    // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return "يجب أن تحتوي كلمة المرور على حرف خاص واحد على الأقل ( ! @ # \$ % & * ).";
    // }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "رقم الهاتف مطلوب.";
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^01\d{9}$');

    if (!phoneRegExp.hasMatch(value)) {
      return "تنسيق رقم الهاتف غير صالح (يجب أن يبدأ بـ 01 ويتكون من 11 رقمًا).";
    }

    return null;
  }

// Add more custom validators as needed for your specific requirements.
}
