import 'package:flutter/material.dart';
import 'package:pss/components/dialog_button.dart';
import '../constants.dart';
import 'package:flutter/material.dart';

/// This class renders dialog boxes for creating tasks
class DialogRenderer {
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

  DialogRenderer(this.context);

  var _nameInputField = new TextFormField(
    controller: _nameTextController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(labelText: "Name"),
  );

  Widget createTypeInputField(String typeOfTask) {
    List<String> taskTypes = new List<String>();
    if (typeOfTask.compareTo("anti") == 0) {
      taskTypes = kAntiTaskTypes;
    } else if (typeOfTask.compareTo("trans") == 0) {
      taskTypes = kTransTaskTypes;
    } else {
      taskTypes = kRecurTaskTypes;
    }

    if (typeOfTask == "anti")
      _typeTextController.text = "Cancellation";
    else if (typeOfTask == "trans")
      _typeTextController.text = "Appointment";
    else
      _typeTextController.text = "Class";

    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return FormField<String>(builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'Type',
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: _typeTextController.text,
                  isDense: true,
                  items: taskTypes.map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String type) {
                    setState(() => _typeTextController.text = type);
                  }),
            ),
          );
        });
      },
    );
  }

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
    decoration: InputDecoration(labelText: "Date", helperText: "YYYYMMDD"),
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

  Widget _frequencyDropdown() {
    String selectedValue = "Daily";
    _frequencyTextController.text = "1";
    return StatefulBuilder(
      builder: (context, setState) {
        return FormField<String>(builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'Frequency',
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: selectedValue,
                  isDense: true,
                  items: kFrequencyOptions.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val == "Daily")
                      _frequencyTextController.text = "1";
                    else if (val == "Weekly")
                      _frequencyTextController.text = "7";
                    else
                      _frequencyTextController.text = "30";
                    setState(() => selectedValue = val);
                  }),
            ),
          );
        });
      },
    );
  }

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

  void showTaskTypesDialogBox(Function createTask) {
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
                    createTask("recur");
                  }),
              RaisedButton(
                  color: kTransientTaskColor,
                  child: Text("Transient"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    createTask("trans");
                  }),
              RaisedButton(
                  color: kAntiTaskColor,
                  child: Text("AntiTask"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    createTask("anti");
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

  Future<Map> getNewRecurringTaskData() async {
    // _nameTextController.text = "Fix this";
    // _typeTextController.text = "Class";
    // _startTimeTextController.text = "11.75";
    // _durationTextController.text = "1.75";
    // _startDateTextController.text = "20200220";
    // _endDateTextController.text = "20200224";
    // _frequencyTextController.text = "7";

    final _reccuringTaskDataFields = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _nameInputField,
          createTypeInputField("recur"),
          _startTimeInputField,
          _durationInputField,
          _startDateInputField,
          _endDateInputField,
          _frequencyDropdown()
        ],
      ),
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

  Future<Map> getNewTransientTaskData() async {
    // _nameTextController.text = "Fix this";
    // _typeTextController.text = "Visit";
    // _startTimeTextController.text = "11.75";
    // _durationTextController.text = "1.75";
    // _dateTextController.text = "20200220";

    final _reccuringTaskDataFields = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _nameInputField,
          createTypeInputField("trans"),
          _startTimeInputField,
          _durationInputField,
          _dateInputField
        ],
      ),
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
                  if (_nameTextController.text.isNotEmpty &&
                      _typeTextController.text.isNotEmpty &&
                      _startTimeTextController.text.isNotEmpty &&
                      _durationTextController.text.isNotEmpty &&
                      _dateTextController.text.isNotEmpty) {
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
                  } else {
                    print("Error");
                    showErrorDialog("Please complete form!");
                  }
                }),
          ],
        );
      },
    );
  }

  Future<Map> getNewAntiTaskData() async {
    // _nameTextController.text = "Fix this";
    // _typeTextController.text = "Cancellation";
    // _startTimeTextController.text = "11.75";
    // _durationTextController.text = "1.75";
    // _dateTextController.text = "20200220";
    final _reccuringTaskDataFields = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _nameInputField,
          createTypeInputField("anti"),
          _startTimeInputField,
          _durationInputField,
          _dateInputField
        ],
      ),
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

  Future<Map> showErrorDialog(String msg) async {
    return await showDialog<Map>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error! Cannot Add Task."),
          content: Text("$msg"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          actions: <Widget>[
            new DialogButton(
                label: "Cancel",
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
