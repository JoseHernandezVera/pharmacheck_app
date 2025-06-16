class User {
  String name;
  String email;
  String birthdate;
  String phone;
  String imageUrl;

  User({
    required this.name,
    required this.email,
    required this.birthdate,
    required this.phone,
    this.imageUrl = 'assets/images/perfil.jpg',
  });

  factory User.guest() {
    return User(
      name: 'Usuario Invitado',
      email: 'invitado@example.com',
      birthdate: '01/01/2000',
      phone: '0000000000',
    );
  }
}