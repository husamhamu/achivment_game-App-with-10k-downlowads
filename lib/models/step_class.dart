class StepClass {
  String _name = '';
  int _stepsNumber = 0;
  bool _isDone = false;
  bool _updateName = false;

  StepClass(this._name) {
    _stepsNumber++;
  }
  StepClass.dbHelper(this._name, this._isDone) {
    _stepsNumber++;
  }

  void checkStep() {
    this._isDone = !_isDone;
  }

  int get stepsNumber => _stepsNumber;

  String get name => _name;

  bool get isDone => _isDone;

  set stepsNumber(int value) {
    _stepsNumber = value;
  }

  set name(String value) {
    _name = value;
  }

  bool get updateName => _updateName;

  set updateName(bool value) {
    _updateName = value;
  }
}
