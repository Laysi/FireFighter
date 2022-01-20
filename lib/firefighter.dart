library firefighter;

import 'package:cloud_firestore/cloud_firestore.dart'
    show CollectionReference, DocumentReference, GetOptions, Query;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reflectable/reflectable.dart';

// Annotate with this class to enable reflection.
class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, newInstanceCapability,
            declarationsCapability); // Request the capability to invoke methods.
}

const _reflector = Reflector();
const fireData = _reflector;

T initializeFromJson<T>(Map<String, dynamic> data) =>
    (_reflector.reflectType(T) as ClassMirror).newInstance('fromJson', [data])
        as T;

typedef JsonMapper = Map<String, dynamic> Function(Map<String, dynamic>);

Map<String, dynamic> defaultMapper(Map<String, dynamic> data) => data;

abstract class FireSerializable {
  Map<String, dynamic> toJson();
}

extension CollectionReferenceExtension<T> on CollectionReference<T> {
  CollectionReference<R> as<R extends FireSerializable>(
          {JsonMapper from = defaultMapper, JsonMapper to = defaultMapper}) =>
      withConverter<R>(
          fromFirestore: (snapshot, options) =>
              initializeFromJson<R>(from(snapshot.data()!)),
          toFirestore: (value, options) => to(value.toJson()));
}

extension DocumentReferenceExtension<T> on DocumentReference<T> {
  DocumentReference<R> as<R extends FireSerializable>(
          {JsonMapper from = defaultMapper, JsonMapper to = defaultMapper}) =>
      withConverter<R>(
        fromFirestore: (snapshot, options) =>
            initializeFromJson<R>(from(snapshot.data()!)),
        toFirestore: (value, options) => to(value.toJson()),
      );

  Future<DocumentSnapshot<T>> getCacheFirst() async {
    try {
      return await get(const GetOptions(source: Source.cache));
    } on FirebaseException {
      return await get();
    }
  }

  Future<DocumentSnapshot<R>> getAs<R extends FireSerializable>(
      [GetOptions? options]) async {
    return as<R>().get(options);
  }
}

extension QueryExtension on Query {
  Query<T> as<T extends FireSerializable>(
          {JsonMapper from = defaultMapper, JsonMapper to = defaultMapper}) =>
      withConverter<T>(
        fromFirestore: (snapshot, options) =>
            initializeFromJson<T>(from(snapshot.data()!)),
        toFirestore: (value, options) => to(value.toJson()),
      );
}
