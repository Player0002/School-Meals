import 'package:equatable/equatable.dart';

class SchoolModel extends Equatable {
  @override
  List<Object> get props => [status, message];

  final int status;
  final String message;
  final List<SchoolDataModel> models;

  static SchoolModel empty =
      SchoolModel(status: 0, message: "", models: List.empty());

  SchoolModel({this.status, this.message, this.models});

  factory SchoolModel.fromJson(Map<String, dynamic> json) => SchoolModel(
        status: json["status"],
        message: json["message"],
        models: (json["data"]["sc_list"] as List)
            .map((e) => SchoolDataModel.fromJson(e))
            .toList(),
      );
}

class SchoolDataModel extends Equatable {
  @override
  List<Object> get props => [school_name, a_sc_code, sc_code, address];
  final String school_name;
  final String a_sc_code;
  final String sc_code;
  final String address;

  static SchoolDataModel empty = SchoolDataModel(
    school_name: "",
    sc_code: "",
    address: "",
    a_sc_code: "",
  );

  SchoolDataModel({
    this.school_name,
    this.a_sc_code,
    this.sc_code,
    this.address,
  });
  factory SchoolDataModel.fromJson(Map<String, dynamic> json) =>
      SchoolDataModel(
        sc_code: json["sc_code"],
        school_name: json["school_name"],
        a_sc_code: json["a_sc_code"],
        address: json["address"],
      );
}
