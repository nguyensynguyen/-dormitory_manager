class User {
  int id;
  String userName;
  int birthDay;
  int phone;
  String email;
  String address;
  int idCard;
  int registrationDate;
  int expirationDate;
  int managerId;
  int roomId;
  String password;

  User(
      {this.id,
      this.userName,
      this.email,
      this.phone,
      this.address,
      this.password,
      this.birthDay,
      this.expirationDate,
      this.idCard,
      this.managerId,
      this.registrationDate,
      this.roomId});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      userName: json['user_name'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      password: json['password'],
      birthDay: json['birth_day'],
      expirationDate: json['expiration_date'],
      registrationDate: json['registration_date'],
      managerId: json['manager_id'],
      roomId: json['room_id'],
      idCard: json['id_card']);
}
