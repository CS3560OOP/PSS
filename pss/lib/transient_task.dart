import 'task.dart';

class TransientTask extends Task{
  //class properties
  int _date;

  //class methods (accessors and mutators)
  void setDate(int d){
    _date = d;
  }

  int getDate(){
    return _date;
  }

}