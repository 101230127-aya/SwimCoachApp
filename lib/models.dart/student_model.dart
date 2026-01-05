enum Strength { weak, medium, strong }

const strengthName = {
  'weak': Strength.weak,
  'medium': Strength.medium,
  'strong': Strength.strong,
};

class StudentModel {
  final int id;
  final String name;
  final Strength strength;
  final int classId;

  StudentModel({
    required this.id,
    required this.name,
    required this.strength,
    required this.classId,
  });
  Map<String, Object?> get studentMap {
    return {
      'id': id == 0 ? null : id, // Auto-increment if id is 0
      'name': name,
      'strength': strength.name,
      'classId': classId,
    };
  }
}
