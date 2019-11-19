import 'package:bottom_dialog/model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(BottomSheetDialogApp());

class BottomSheetDialogApp extends StatelessWidget {
  static final title = 'Bottom Sheet Modal Dialog';
  @override
  Widget build(BuildContext context) {
    // The ScopedModel widget here simply inserts the SheetModel into context so it is findable
    return ScopedModel<SheetModel>(
      model: SheetModel(),
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ScaffoldThatTriggersDialog(title: title),
      ),
    );
  }
}

/// For the dialog to work, there must be a scaffold ancestor where showModalBottomSheet is used.
/// It took me a while to figure out that isScrollControlled was a thing -- so use that param
/// along with making sure that the child component (from the builder function) is a scrollable
/// widget like SingleChildScrollView.
class ScaffoldThatTriggersDialog extends StatelessWidget {
  final String title;
  ScaffoldThatTriggersDialog({this.title});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Show The Dialog'),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => BottomSheetDialogContainer());
              },
            ),
            Text('Model Value: ${SheetModel.reactive(context).value}'),
          ],
        ),
      ),
    );
  }
}

/// This is a container pattern for showing bottom sheet dialogs that will scroll to remain
/// visible in case the user's soft keyboard is used. You could use any child in place of the
/// TextInputDialog that is used here.
class BottomSheetDialogContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: TextInputDialog(
          setValue: (v) => SheetModel.reactive(context).value = v,
        ),
      ),
    );
  }
}

/// This is the dialog's main content. It doesn't know about scrolling, or scaffolds, or any of
/// that. The only hint of layout awareness it has is the MainAxisSize.min part, which keeps it
/// compact. It is also why I use SizedBox instead of Spacer.
///
/// The prop passed in (setValue) could easily be summoned up with SheetModel.reactive(context) but
/// I chose to decouple it from a specific model, and passing in the setValue function instead.
class TextInputDialog extends StatelessWidget {
  final Function(String) setValue;

  TextInputDialog({@required this.setValue});

  @override
  Widget build(BuildContext context) {
    final textCtrl = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8),
        Text('Enter a value'),
        SizedBox(height: 8),
        TextField(
          controller: textCtrl,
        ),
        SizedBox(height: 8),
        RaisedButton(
          child: Text('OK'),
          onPressed: () {
            setValue(textCtrl.text);
            Navigator.of(context).pop();
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
