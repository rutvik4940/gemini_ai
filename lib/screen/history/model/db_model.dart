class DbModel
{
  int?id;
  String?text;

  DbModel({this.text,this.id});

  factory DbModel.mapToModel(Map m1)
  {
    return DbModel(text:m1['text'] ,id: m1['id']);
  }
}