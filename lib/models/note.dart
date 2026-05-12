/// Stores supported note file formats.
abstract class NoteFileFormats {
  static const String document = 'document';
  static const String markdown = 'markdown';
}

/// Stores a single folder node inside the notes tree.
class NoteFolderModel {
  const NoteFolderModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.parentId,
  });

  final String id;
  final String name;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteFolderModel copyWith({
    String? id,
    String? name,
    String? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteFolderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory NoteFolderModel.fromMap(Map<dynamic, dynamic> map) {
    return NoteFolderModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      parentId: map['parentId'] as String?,
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'parentId': parentId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Stores a single note file and its content.
class NoteFileModel {
  const NoteFileModel({
    required this.id,
    required this.title,
    required this.format,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.folderId,
  });

  final String id;
  final String title;
  final String? folderId;
  final String format;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isMarkdown => format == NoteFileFormats.markdown;

  NoteFileModel copyWith({
    String? id,
    String? title,
    String? folderId,
    String? format,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteFileModel(
      id: id ?? this.id,
      title: title ?? this.title,
      folderId: folderId ?? this.folderId,
      format: format ?? this.format,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory NoteFileModel.fromMap(Map<dynamic, dynamic> map) {
    return NoteFileModel(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      folderId: map['folderId'] as String?,
      format: map['format'] as String? ?? NoteFileFormats.document,
      content: map['content'] as String? ?? '',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'folderId': folderId,
      'format': format,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
