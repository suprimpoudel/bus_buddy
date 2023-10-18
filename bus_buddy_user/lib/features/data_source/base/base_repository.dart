abstract class BaseRepository {
  fromJson<T>(Map<String, dynamic> json);

  fromJsonList<T>(List<dynamic> jsonList);

  T convertToDataClass<T>(Map<String, dynamic> value) {
    if (value["result"] is List<dynamic>) {
      return fromJsonList<T>(value["result"]);
    } else {
      return fromJson<T>(value["result"]);
    }
  }
}
