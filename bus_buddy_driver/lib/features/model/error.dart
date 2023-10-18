class Error {
  String? message;
  String? code;
  String? timeStamp;
  List<Errors>? errors;

  Error({this.message, this.code, this.timeStamp, this.errors});

  Error.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    timeStamp = json['timeStamp'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    data['timeStamp'] = timeStamp;
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Errors {
  String? key;
  String? message;

  Errors({this.key, this.message});

  Errors.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['message'] = message;
    return data;
  }
}
