

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
    id: obj['id'],
    name: obj['name'],
    votes: obj['votes']
  );


}