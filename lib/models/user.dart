


import '../manager/myVoids.dart';

class ScUser {

  String? id;
  String? email;
  String? name ;
  String? pwd;
  String? sex;
  String? joinDate;
  bool? hasPatients;
  String? role;
  String? number;
  String? address;
  String? age;
  String? speciality;
  Map<String,dynamic> health;
  Map<String,dynamic> appointments;
  Map<String,dynamic> notifications;
  String? doctorAttachedID;
  bool verified;
  List<String> patients;




  ScUser({
    this.id = 'no-id',
    this.email = '',
    this.pwd  = '',
    this.name = '',
    this.joinDate = '',
    this.role = '',
    this.number = '',
    this.sex = '',
    this.address = '',
    this.age = '',
    this.verified = false,
    this.notifications = const{},

    this.hasPatients = false,//doc
    this.appointments = const{},//doc
    this.speciality = '',//doc
    this.patients =const [],//doc

    this.health = const{},//pat
    this.doctorAttachedID = '',//pat
  });
}

Future<ScUser> getUserByID(id) async {
  if(id == '') return ScUser();
  final event = await usersColl.where('id', isEqualTo: id).get();
  var doc = event.docs.single;
  return ScUserFromMap(doc);
}
ScUser ScUserFromMap(userDoc){

  ScUser user =ScUser();



  user.email = userDoc.get('email');
  user.name = userDoc.get('name');
  user.id = userDoc.get('id');
  user.doctorAttachedID = userDoc.get('doctorAttachedID');
  user.number = userDoc.get('number');
  user.pwd = userDoc.get('pwd');
  user.age = userDoc.get('age');
  user.sex = userDoc.get('sex');
  user.address = userDoc.get('address');
  user.health = userDoc.get('health');
  user.speciality = userDoc.get('speciality');
  user.role = userDoc.get('role');
  user.verified = userDoc.get('verified');
  user.joinDate = userDoc.get('joinDate');

  List<dynamic> fbList = userDoc.get('patients');
  List<String> fbListString =  [];
  for (var id in fbList) {
    //print('## type ${id}');
    fbListString.add(id.toString());
  }
  user.patients = fbListString;

  user.appointments = userDoc.get('appointments');
  user.notifications = userDoc.get('notifications');
  user.hasPatients = user.patients.isNotEmpty;


  return user;
}

printUser(ScUser user){
  print(
      '#### USER(${user.role}) ####'
          'id: ${user.id} \n'
          'role: ${user.role} \n'
          'doctorAttachedID: ${user.doctorAttachedID} \n'
          'email: ${user.email} \n'
          'name: ${user.name} \n'
          'pwd: ${user.pwd} \n'
          'number: ${user.number} \n'
          'age: ${user.age} \n'
          'sex: ${user.sex} \n'
          'health: ${user.health} \n'
          'speciality: ${user.speciality} \n'
          'verified: ${user.verified} \n'
          'joinDate: ${user.joinDate} \n'
          'patients: ${user.patients} \n'
          'notifications: ${user.notifications} \n'
          'appointments: ${user.appointments} \n'
          'hasPatients: ${user.hasPatients} \n'
  );
}