import 'package:flutter_test/flutter_test.dart';

import 'package:HealthGuard/helper/validation_tool.dart';

void main(){
  test('Empty Email Test', (){
    var result = validateEmail('');
    expect(result, 'Enter a valid email address');
  });

  test('Invalid Email Test', (){
    var result = validateEmail('abc');
    expect(result, 'Enter a valid email address');
  });

  test('Valid Email Test', (){
    var result = validateEmail('hfyyl2@nottingham.edu.my');
    expect(result, null);
  });

  test('Invalid Phone Number Test', (){
    var result = validateMobile('abvddvd');
    expect(result, "Mobile phone number must contain only digits");
  });

  test('Valid Phone Number Test', (){
    var result = validateMobile('0123456789');
    expect(result, null);
  });

  test('Empty Phone Number Test', (){
    var result = validateMobile('');
    expect(result, "Mobile phone number is required");
  });
}