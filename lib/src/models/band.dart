

class Band{
  
  String id;
  String name;
  int votes;

  Band({
    this.id = '',
    this.name = '',
    this.votes = 0,
  });

  //tipo de constructor - regresa nueva instancia de clase
  // factory Band.fromMap( Map<String, dynamic> obj){
  //   return Band();
  // }
  factory Band.fromMap( Map<String, dynamic> obj) 
  => Band(
    id: obj.containsKey('id') ? obj['id'] : 'no-id',
    name: obj.containsKey('name') ? obj['name'] : 'no-name',
    votes: obj.containsKey('votes') ? obj['votes'] :  'no-votes'
  );


}