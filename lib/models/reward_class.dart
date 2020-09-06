class Reward {
  int _id;
  String _title;
  int points;
  String _filePath;
  bool isBought = false;

  Reward(this._id, this._title, this.points, this._filePath)
      : assert(points != 0),
        assert(_title != null),
        assert(_filePath != null);
  Reward.dbHelper(
      this._id, this.points, this._title, this.isBought, this._filePath)
      : assert(points != 0),
        assert(_title != null),
        assert(_filePath != null);

  String get filePath => _filePath;

  String get title => _title;

  int get id => _id;

  set filePath(String value) {
    _filePath = value;
  }

  set title(String value) {
    _title = value;
  }

  set id(int value) {
    _id = value;
  }
}
