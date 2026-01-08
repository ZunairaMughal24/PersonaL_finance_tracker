class Validators {
  /// For title or text fields
  static String? title(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    if (value.trim().length < 3) {
      return "Minimum 3 characters required";
    }
    return null;
  }

  static String? emptyValidator(String? text) {
    if (text!.isEmpty) {
      return 'Please Fill in the field';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    if (double.tryParse(value) == null) {
      return "Enter a valid number";
    }
    return null;
  }

  static String? category(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select an option";
    }
    return null;
  }

  static String? type(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select an option";
    }
    return null;
  }

  static String? doubleValidator(String? text) {
    if (text!.isEmpty) {
      return 'Please Fill in the field';
    }
    try {
      double.parse(text);
      return null;
    } catch (e) {
      return 'Please enter correct value';
    }
  }

  static String? nameValidator(String? name) {
    if (name!.isEmpty) {
      return 'Please fill in the name';
    }

    if (name.length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (name.length > 30) {
      return 'Name cannot exceed 30 characters';
    }

    return null;
  }

  static String? usernameValidator(String? email) {
    if (email!.isEmpty) {
      return 'Please fill in the username';
    }

    if (email.length < 6) {
      return 'Username must be at least 6 characters';
    }
    return null;
  }

  static String? emailValidator(String? email) {
    if (email!.isEmpty) {
      return 'Please Fill in the email';
    }

    const p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final regExp = RegExp(p);

    if (!regExp.hasMatch(email.trim())) {
      return 'Please Enter Valid Email Address';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password!.isEmpty) {
      return 'Please Fill in the password';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? password,
    String? oldPassword,
  ) {
    if (password!.isEmpty) {
      return 'Please fill in the password';
    }

    if (password != oldPassword) {
      return "Passwords don't match";
    }
    return null;
  }

  static String? lengthValidator(String? field, {int length = 4}) {
    if (field!.isEmpty) {
      return 'Please Fill in the field';
    }

    if (field.length < length) {
      return 'Text must be at least $length characters';
    }
    return null;
  }

  static String? dropDownValidator(String? text, String title) {
    if (text!.isEmpty) {
      return 'Please select the $title';
    }
    return null;
  }
}
