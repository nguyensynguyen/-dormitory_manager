class Manager{
  int id;
  String managerName;
  String email;
  String address;
  int phone;
  String password;
  Manager({this.id,this.managerName,this.email,this.phone,this.address,this.password});

  factory Manager.fromJson(Map<String,dynamic> json)=> Manager(
id: json['id'],
managerName: json['manager_name'],
email: json['email'],
address: json['address'],
phone: json['phone'],
password: json['password'],
  );
}