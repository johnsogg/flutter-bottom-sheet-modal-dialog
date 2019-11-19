import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SheetModel extends Model {
  static SheetModel reactive(BuildContext context) =>
      ScopedModel.of<SheetModel>(context, rebuildOnChange: true);

  String _value;
  String get value => _value;
  set value(String v) {
    _value = v;
    print('set value to $_value');
    notifyListeners();
  }
}
