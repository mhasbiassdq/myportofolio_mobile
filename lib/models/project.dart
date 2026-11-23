import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Model data Project yang diselaraskan dengan ProjectSerializer pada DRF.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    this.id,
    required this.title,
    required this.description,
    this.category = 'personal',
    this.thumbnail = '',
    this.startedAt,
    this.endedAt,
    this.starCount = 0,
    this.isStarred = false,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String description;

  @JsonKey(defaultValue: 'personal')
  final String category;

  @JsonKey(defaultValue: '')
  final String thumbnail;

  @JsonKey(includeToJson: false)
  final DateTime? startedAt;

  @JsonKey(includeIfNull: false)
  final DateTime? endedAt;

  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;

  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
