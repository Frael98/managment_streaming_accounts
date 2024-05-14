abstract class Entity {
  String? state;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  Entity({this.state, this.createdAt, this.updatedAt, this.deletedAt});
}
