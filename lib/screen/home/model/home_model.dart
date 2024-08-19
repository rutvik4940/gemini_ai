class HomeModel
{
  List<candidates>?list=[];

  HomeModel({this.list});

  factory HomeModel.mapToModel(Map m1)
  {
    List l2=m1['candidates'];
    return HomeModel(list: l2.map((e)=>candidates.mapToModel(e)).toList());
  }
}
class candidates{
  Content? content;

  candidates({this.content});

  factory candidates.mapToModel(Map m1)
  {
    return candidates(content: Content.mapToModel(m1['content']));
  }
}
class Content
{
  String?role;

  List<parts>?l1=[];

  Content({this.l1,this.role});

  factory Content.mapToModel(Map m1)
  {
    List l12=m1['parts'];
    return Content(l1:l12.map((e)=>parts.mapToModel(e)).toList(),role: m1['role']);
  }

}
class parts
{
  String?text;

  parts({this.text});

  factory parts.mapToModel(Map m1)
  {
    return parts(text: m1['text']);
  }
}