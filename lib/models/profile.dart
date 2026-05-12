/// Stores the local user profile shown in Profile and UserProfile pages.
class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.city,
    required this.avatar,
    required this.avatarBg,
    required this.tags,
    required this.energyLevel,
    required this.mode,
  });

  final String id;
  final String name;
  final String bio;
  final String city;
  final String avatar;
  final String avatarBg;
  final List<String> tags;
  final String energyLevel;
  final String mode;

  ProfileModel copyWith({
    String? id,
    String? name,
    String? bio,
    String? city,
    String? avatar,
    String? avatarBg,
    List<String>? tags,
    String? energyLevel,
    String? mode,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      avatar: avatar ?? this.avatar,
      avatarBg: avatarBg ?? this.avatarBg,
      tags: tags ?? this.tags,
      energyLevel: energyLevel ?? this.energyLevel,
      mode: mode ?? this.mode,
    );
  }

  factory ProfileModel.fromMap(Map<dynamic, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      city: map['city'] as String? ?? '',
      avatar: map['avatar'] as String? ?? '🙂',
      avatarBg: map['avatarBg'] as String? ?? '#6366F1',
      tags: (map['tags'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList(),
      energyLevel: map['energyLevel'] as String? ?? 'steady',
      mode: map['mode'] as String? ?? 'focus',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bio': bio,
      'city': city,
      'avatar': avatar,
      'avatarBg': avatarBg,
      'tags': tags,
      'energyLevel': energyLevel,
      'mode': mode,
    };
  }
}
