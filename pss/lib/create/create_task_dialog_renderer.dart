import 'package:flutter/material.dart';
import 'package:pss/components/dialog_button.dart';
import 'package:pss/constants.dart';

/// This class renders dialog boxes for creating tasks
class CreateTaskDialogRenderer {
  static final _nameTextController = new TextEditingController();
  static final _typeTextController = new TextEditingController();
  static final _startDateTextController = new TextEditingController();
  static final _startTimeTextController = new TextEditingController();
  static final _durationTextController = new TextEditingController();
  static final _endDateTextController = new TextEditingController();
  static final _frequencyTextController = new TextEditingController();
  static final _dateTextController = new TextEditingController();
  String typeValue = '';

  BuildContext context;
  CreateTaskDialogRenderer(this.context);
  var _nameInputField = new TextFormField(
    controller: _nameTextController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(labelText: "Name"),
  );

  //Creates a dropdown item that displays correctly but is currently non functional
  //because normally the onchanged function would call setState() but that method is not visible from here
  Widget createTypeInputField(String typeOfTask) {
    List<String> taskTypes = new List<String>();
    if (typeOfTask.compareTo("anti") == 0) {
      taskTypes = antiTaskTypes;
    } else if (typeOfTask.compareTo("trans") == 0) {
      taskTypes = transTaskTypes;
    } else if (typeOfTask.compareTo("recur") == 0) {
      taskTypes = recurTaskTypes;
    }
    return FormField<String>(builder: (FormFieldState<String> state) {
      _typeTextController.text =
          _typeTextController.text.isEmpty ? "Class" : _typeTextController.text;
      return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Type',
          ),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
            isDense: true,
            onChanged: (String type) {
              //not sure if it is possible to manually set the text field of a controller
              _typeTextController.text = type;
            },
            value: _typeTextController.text,
            items: taskTypes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )));
    });
  }

  // TODO: turn into dropdown??
  var _typeInputField = new TextFormField(
    controller: _typeTextController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(labelText: "Type"),
  );

  var _startDateInputField = new TextFormField(
    controller: _startDateTextController,
    keyboardType: TextInputType.number,
    decoration:
        InputDecoration(labelText: "Start Date", helperText: "YYYYMMDD"),
  );

  var _endDateInputField = new TextFormField(
    controller: _endDateTextController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(labelText: "End Date", helperText: "YYYYMMDD"),
  );

  var _dateInputField = new TextFormField(
    controller: _dateTextController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(labelText: "End Date", helperText: "YYYYMMDD"),
  );

  var _startTimeInputField = new TextFormField(
    controller: _startTimeTextController,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
        labelText: "Start Time", helperText: "i.e. 13.75 = 1:45 pm"),
  );

  var _durationInputField = new TextFormField(
    controller: _durationTextController,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
        labelText: "Duration", helperText: "i.e. 1.75 = 1 hr 45 min"),
  );

// TODO: turn into dropdown??
  var _frequencyInputField = new TextFormField(
    controller: _frequencyTextController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(labelText: "Frequency"),
  );

  void clearFields() {
    _nameTextController.clear();
    _typeTextController.clear();
    _startDateTextController.clear();
    _startTimeTextController.clear();
    _durationTextController.clear();
    _endDateTextController.clear();
    _frequencyTextController.clear();
    _dateTextController.clear();
  }

  void showTaskTypesDialogBox(
      Function addRecurring, Function addTransient, Function addAntiTask) {
    showDialog<Map>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New Recurring Task:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                  color: kRecurringTaskColor,
                  child: Text("Recurring"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    addRecurring();
                  }),
              RaisedButton(
                  color: kTransientTaskColor,
                  child: Text("Transient"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    addTransient();
                  }),
              RaisedButton(
                  color: kAntiTaskColor,
                  child: Text("AntiTask"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    addAntiTask();
                  })
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        );
      },
    );
  }

  Future<Map> showAddRecurringTaskDialog() async {
    // _nameTextController.text = "Fix this";
    // _typeTextController.text = "Class";
    // _startTimeTextController.text = "11.75";
    // _durationTextController.text = "1.75";
    // _startDateTextController.text = "20200220";
    // _endDateTextController.text = "20200224";
    // _frequencyTextController.text = "7";

    final _reccuringTaskDataFields = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _nameInputField,
        createTypeInputField("recur"),
        _startTimeInputField,
        _durationInputField,
        _startDateInputField,
        _endDateInputField,
        _frequencyInputField
      ],
    );
    return await showDialog<Map>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New Recurring Task:"),
          content: _reccuringTaskDataFields,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          actions: <Widget>[
            new DialogButton(
                label: "Cancel",
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            new DialogButton(
                label: "Add",
                onPressed: () {
                  Navigator.pop(context, {
                    "Name": _nameTextController.text.trim(),
                    "Type": _typeTextController.text.trim(),
                    "StartDate":
                        int.parse(_startDateTextController.text.trim()),
                    "EndDate": int.parse(_endDateTextController.text.trim()),
                    "StartTime":
                        double.parse(_startTimeTextController.text.trim()),
                    "Duration":
                        double.parse(_durationTextController.text.trim()),
                    "Frequency": int.parse(_frequencyTextController.text.trim())
                  });
                  clearFields();
                }),
          ],
        );
      },
    );
  }

  Future<Map> showAddTransientTaskDialog() async {
    // _nameTextController.text = "Fix this";
    // _typeTextController.text = "Visit";
    // _startTimeTextController.text = "11.75";
    // _durationTextController.text = "1.75";
    // _dateTextController.text = "20200220";
    final _reccuringTaskDataFields = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _nameInputField,
        createTypeInputField("trans"),
        _startTimeInputField,
        _durationInputField,
        _dateInputField
      ],
    );
    return await showDialog<Map>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New Transient Task:"),
          content: _reccuringTaskDataFields,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          actions: <Widget>[
            new DialogButton(
                label: "Cancel",
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            new DialogButton(
                label: "Add",
                onPressed: () {
                  Navigator.pop(context, {
                    "Name": _nameTextController.text.trim(),
                    "Type": _typeTextController.text.trim(),
                    "StartTime":
                        double.parse(_startTimeTextController.text.trim()),
                    "Duration":
                        double.parse(_durationTextController.text.trim()),
                    "Date": int.parse(_dateTextController.text.trim()),
                  });
                  clearFields();
                }),
          ],
        );
      },
    );
  }

  Future<Map> showAddAntiTaskDialog() async {
    // _nameTextController.text = "Fix this";
    _typeTextController.text = "Cancellation";
    // _startTimeTextController.text = "11.75";
    // _durationTextController.text = "1.75";
    // _dateTextController.text = "20200220";

    final _reccuringTaskDataFields = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _nameInputField,
        createTypeInputField("anti"),
        _startTimeInputField,
        _durationInputField,
        _dateInputField
      ],
    );
    return await showDialog<Map>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New Anti Task:"),
          content: _reccuringTaskDataFields,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          actions: <Widget>[
            new DialogButton(
                label: "Cancel",
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            new DialogButton(
                label: "Add",
                onPressed: () {
                  Navigator.pop(context, {
                    "Name": _nameTextController.text.trim(),
                    "Type": _typeTextController.text.trim(),
                    "StartTime":
                        double.parse(_startTimeTextController.text.trim()),
                    "Duration":
                        double.parse(_durationTextController.text.trim()),
                    "Date": int.parse(_dateTextController.text.trim()),
                  });
                  clearFields();
                }),
          ],
        );
      },
    );
  }
}
