/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the Diary type in your schema. */
class Diary extends amplify_core.Model {
  static const classType = const _DiaryModelType();
  final String id;
  final String? _title;
  final String? _content;
  final String? _imageKey;
  final amplify_core.TemporalDate? _date;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  DiaryModelIdentifier get modelIdentifier {
      return DiaryModelIdentifier(
        id: id
      );
  }
  
  String? get title {
    return _title;
  }
  
  String get content {
    try {
      return _content!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get imageKey {
    return _imageKey;
  }
  
  amplify_core.TemporalDate get date {
    try {
      return _date!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Diary._internal({required this.id, title, required content, imageKey, required date, createdAt, updatedAt}): _title = title, _content = content, _imageKey = imageKey, _date = date, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Diary({String? id, String? title, required String content, String? imageKey, required amplify_core.TemporalDate date, amplify_core.TemporalDateTime? createdAt}) {
    return Diary._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      title: title,
      content: content,
      imageKey: imageKey,
      date: date,
      createdAt: createdAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Diary &&
      id == other.id &&
      _title == other._title &&
      _content == other._content &&
      _imageKey == other._imageKey &&
      _date == other._date &&
      _createdAt == other._createdAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Diary {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("imageKey=" + "$_imageKey" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Diary copyWith({String? title, String? content, String? imageKey, amplify_core.TemporalDate? date, amplify_core.TemporalDateTime? createdAt}) {
    return Diary._internal(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageKey: imageKey ?? this.imageKey,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt);
  }
  
  Diary copyWithModelFieldValues({
    ModelFieldValue<String?>? title,
    ModelFieldValue<String>? content,
    ModelFieldValue<String?>? imageKey,
    ModelFieldValue<amplify_core.TemporalDate>? date,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt
  }) {
    return Diary._internal(
      id: id,
      title: title == null ? this.title : title.value,
      content: content == null ? this.content : content.value,
      imageKey: imageKey == null ? this.imageKey : imageKey.value,
      date: date == null ? this.date : date.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value
    );
  }
  
  Diary.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _content = json['content'],
      _imageKey = json['imageKey'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'content': _content, 'imageKey': _imageKey, 'date': _date?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'title': _title,
    'content': _content,
    'imageKey': _imageKey,
    'date': _date,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<DiaryModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<DiaryModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final CONTENT = amplify_core.QueryField(fieldName: "content");
  static final IMAGEKEY = amplify_core.QueryField(fieldName: "imageKey");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Diary";
    modelSchemaDefinition.pluralName = "Diaries";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diary.TITLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diary.CONTENT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diary.IMAGEKEY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diary.DATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Diary.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _DiaryModelType extends amplify_core.ModelType<Diary> {
  const _DiaryModelType();
  
  @override
  Diary fromJson(Map<String, dynamic> jsonData) {
    return Diary.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Diary';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Diary] in your schema.
 */
class DiaryModelIdentifier implements amplify_core.ModelIdentifier<Diary> {
  final String id;

  /** Create an instance of DiaryModelIdentifier using [id] the primary key. */
  const DiaryModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'DiaryModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is DiaryModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}