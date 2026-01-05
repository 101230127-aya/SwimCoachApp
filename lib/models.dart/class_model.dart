enum ClassType {
  beginner,
  intermediate,
  advanced,
}
const classTypeName = {
  'beginner': ClassType.beginner,
  'intermediate': ClassType.intermediate,
  'advanced': ClassType.advanced,
};
class ClassModel {
   int id;
  final String name;
  final ClassType type; 

  ClassModel({
    required this.id,
    required this.name,
    required this.type,
  });

   Map<String, Object?> get classMap {
    return {
      'id': id == 0 ? null : id, // Auto-increment if id is 0
      'name': name,
      'type': type.name,
    };
   }
}
