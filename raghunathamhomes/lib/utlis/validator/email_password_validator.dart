class Validator {
  static String? validateEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,6}$');
    if (!emailRegExp.hasMatch(email)) return 'Invalid email format';
    return null;
  }

  static String? validatePassword(String password) {
    final passRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$');
    if (!passRegExp.hasMatch(password)) return 'Password must be at least 8 chars, contain upper/lower letter and a number';
    return null;
  }
}