library firefighter;

import 'package:cloud_firestore/cloud_firestore.dart' show CollectionReference,DocumentReference;
import 'package:reflectable/reflectable.dart';
// Annotate with this class to enable reflection.
class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, newInstanceCapability,
      declarationsCapability); // Request the capability to invoke methods.
}
const _reflector = Reflector();
const fireData = _reflector;


T initializeFromJson<T>(Map<String,dynamic> data)=>(_reflector.reflectType(T) as ClassMirror).newInstance('fromJson', [data]) as T;




abstract class FireSerializable{
  Map<String,dynamic> toJson();
}

extension CollectionReferenceExtension on CollectionReference{
  CollectionReference<T> as<T extends FireSerializable>()=>withConverter<T>(fromFirestore: (snapshot, options) => initializeFromJson<T>(snapshot.data()!), toFirestore: (value, options) => value.toJson(),);
}

extension DocumentReferenceExtension on DocumentReference{
  DocumentReference<T> as<T extends FireSerializable>()=>withConverter<T>(fromFirestore: (snapshot, options) => initializeFromJson<T>(snapshot.data()!), toFirestore: (value, options) => value.toJson(),);
}
