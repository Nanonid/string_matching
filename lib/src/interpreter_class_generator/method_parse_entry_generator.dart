part of string_matching.interpreter_class_generator;

class MethodParseEntryGenerator extends MethodGenerator {
  static const String _INTERPRET = MethodInterpretGenerator.NAME;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
dynamic parse_{{NAME}}() => $_INTERPRET({{CODE}}, {{DATA}});
''';

  String _name;

  MethodParseEntryGenerator(String name) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError("name: $name");
    }

    _name = name;
    addTemplate(_TEMPLATE, _template);
  }

  String get name => _name;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    var camelCase = camelize(_name, true);
    block.assign("CODE", "_${camelCase}Code");
    block.assign("DATA", "_${camelCase}Data");
    block.assign("NAME", _name);
    return block.process();
  }
}
