library firefighter;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firefighter_annotation/firefighter_annotation.dart';


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
