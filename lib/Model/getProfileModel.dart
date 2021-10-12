class GetProfileRequest {
  String username;
  String password;
  String role;

  GetProfileRequest({required this.username, required this.password, required this.role});

  factory GetProfileRequest.fromJson(Map<String, dynamic> json) {
    return GetProfileRequest(
      username: json['username'],
      password: json['password'],
      role: json['role'],
    );
  }

  @override
  String toString() {
    return 'GetProfileRequest{username: $username, password: $password, role: $role}';
  }
}

class GetProfileResponse {
  int id;
  String firstName;
  String lastName;
  String contact;
  String address;
  String createdBy;
  String createdDate;
  String modifiedBy;
  String modifiedDate;

  GetProfileResponse(
      {required this.id,
      required this.firstName,
      required this.lastName,
        required  this.contact,
        required this.address,
        required  this.createdBy,
        required  this.createdDate,
        required  this.modifiedBy,
        required  this.modifiedDate});

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) {
    return GetProfileResponse(
      id: json['id'],
      firstName: json['firstName']??"",
      lastName: json['lastName']??"",
      contact: json['contact']??"",
      address: json['address']??"",
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
    );
  }

  @override
  String toString() {
    return 'GetProfileResponse{id: $id, firstName: $firstName, lastName: $lastName, contact: $contact, address: $address, createdBy: $createdBy, createdDate: $createdDate, modifiedBy: $modifiedBy, modifiedDate: $modifiedDate}';
  }
}
