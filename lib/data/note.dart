const String tableNotes = 'notes';

class NoteFields {
  static final List<String>values=[id,isImportant,salePrice];
  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String salePrice = 'salePrice';
}

class Note {
  final int? id;
  final bool isImportant;
  final String salePrice;

  const Note({
    this.id,
    this.isImportant=false,
    required this.salePrice,
  });
  Note copy({
    int? id,
    bool? isImportant,
    String? salePrice,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        salePrice: salePrice ?? this.salePrice,
      );
  static Note fromJson(Map<String,Object?> json)=>Note(
    id: json[NoteFields.id] as int?,
    isImportant: json[NoteFields.isImportant]==1 ,
    salePrice: json[NoteFields.salePrice] as String,
  );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.salePrice: salePrice,
        NoteFields.isImportant: isImportant ? 1 : 0,
      };
}
