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