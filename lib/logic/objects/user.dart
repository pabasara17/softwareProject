class User {
  final String username;
  final String phone;
  final String email;
  final bool isAdmin;

  User(this.username, this.phone, this.email, this.isAdmin);

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'phone': phone,
      'email': email,
      'is_admin': isAdmin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['username'],
      map['phone'],
      map['email'],
      map['is_admin'] ?? false,
    );
  }
}
