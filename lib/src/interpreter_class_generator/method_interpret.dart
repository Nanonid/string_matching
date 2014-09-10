part of string_matching.interpreter_class_generator;

class MethodInterpretGenerator extends MethodGenerator {
  static const String NAME = "_interpret";

  static const String _CODE = GlobalNaming.CODE;

  static const String _DATA = GlobalNaming.DATA;

  static const String _DECODE = MethodDecodeGenerator.NAME;

  static const String _RESULT = GlobalNaming.RESULT;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
dynamic $NAME(List<int> code, List data) {
  $_CODE = code;
  $_DATA = data;
  $_DECODE(0);
  return $_RESULT;    
}
''';

  MethodInterpretGenerator() {
    addTemplate(_TEMPLATE, _template);
  }

  String get name => NAME;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    return block.process();
  }
}
