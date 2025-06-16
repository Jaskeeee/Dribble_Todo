class Todo{
  final int id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt
  });

  Todo toggleCompletion(Todo todo){
    return Todo(
      id: id, 
      title: title, 
      isCompleted: isCompleted, 
      createdAt: createdAt
    );
  }
}
