library firefighter;

import 'package:reflectable/reflectable.dart';

import 'main.reflectable.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(instanceInvokeCapability,invokingCapability, newInstanceCapability,
      declarationsCapability,typingCapability); // Request the capability to invoke methods.
}

const reflector = Reflector();
const reflector2 = Reflector();

@reflector
class DataA<T> {
  String field1;
  int field2;
  T? test;

  DataA({required this.field1, required this.field2});

  Map<String, dynamic> toJson() => {"field1": field1, "field2": field2};

  Type test2<A>() => A;


  DataA.test(Map<String, dynamic> data)
      : field1 = data["field1"],
        field2 = data["field2"],
        test = null;

  DataA.fromJson(Map<String, dynamic> data)
      : field1 = data["field1"],
        field2 = data["field2"];


}

@reflector
class DataB<T> {
  String field1;
  int field2;
  T? test;

  DataB({required this.field1, required this.field2});

  Map<String, dynamic> toJson() => {"field1": field1, "field2": field2};

  Type test2<A>() => A;


  DataB.test(Map<String, dynamic> data)
      : field1 = data["field1"],
        field2 = data["field2"],
        test = null;

  factory DataB.fromJson(Map<String, dynamic> data){
    return DataB(
      field1 : data["field1"],
      field2 : data["field2"],
    );
  }

}

T initializeFromJson<T>(Map<String,dynamic> data)=>(reflector.reflectType(T) as ClassMirror).newInstance('fromJson', [data]) as T;


Type testGeneric<T>(T data)=>returnGeneric<T>();
Type returnGeneric<T>()=>T;

void printWrapperGeneric<T>(Wrapper<T> wrapper)=>printGeneric<T>();
void printGeneric<T>()=>print(T);


@reflector
var functionA = (String data)=>null;

@reflector
void functionB(String data)=>null;

@reflector
class Wrapper<T>{}

void main(List<String> arguments) {
  print(testGeneric(String));

  initializeReflectable();
  print('Hello world!');
  ClassMirror test = reflector.reflectType(DataA) as ClassMirror;
  print(test.newInstance('fromJson', [
    <String, dynamic>{'field1': 'test', 'field2': 233}
  ]));
  var dataA = test.newInstance('fromJson', [
    <String, dynamic>{'field1': 'test', 'field2': 233}
  ]);
  print('initializeFromJson');
  print(initializeFromJson<DataA>(
      <String, dynamic>{'field1': 'test', 'field2': 233}));
  print(initializeFromJson<DataB>(
      <String, dynamic>{'field1': 'test', 'field2': 233}));
  // test.declarations
  print(test);

  print(reflector.reflect(dataA));

  // print(reflector.reflect(functionB));
  // print(reflector.reflect(functionA));

  dynamic wrapperA = Wrapper<String>();
  dynamic wrapperB = Wrapper<int>();
  var wrapperC = Wrapper<DataA<String>>();
  Object wrapperD = wrapperC;
  print(wrapperA);
  print(wrapperB);
  print(wrapperC);
  print(wrapperD);


  printWrapperGeneric(wrapperA);
  printWrapperGeneric(wrapperB);
  printWrapperGeneric(wrapperC);
  printWrapperGeneric(wrapperD as Wrapper);


  // print(reflector.reflectType(Wrapper<DataA<String>>));
}

test<T>() {
  var te = T;

  test<T>();
}