class UpdateProfile {
  String username;
  String firstName;
  String lastName;
  String contact;
  String address;

  UpdateProfile({required this.username,required  this.firstName, required this.lastName,required  this.contact,required  this.address});

  factory UpdateProfile.fromJson(Map<String, dynamic> json) {
    return UpdateProfile(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      contact: json['contact'],
      address: json['address'],
    );
  }

  @override
  String toString() {
    return 'UpdateProfile{username: $username, firstName: $firstName, lastName: $lastName, contact: $contact, address: $address}';
  }
}
