part of string_matching.interpreter_class_generator;

class MethodParseEntryGenerator extends MethodGenerator {
  static const String _DECODE = MethodDecodeGenerator.NAME;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
dynamic parse_{{NAME}}() => $_DECODE({{CP}});
''';

  final ProductionRuleInstruction instruction;

  MethodParseEntryGenerator(this.instruction) {
    if (instruction == null) {
      throw new ArgumentError("instruction: $instruction");
    }

    addTemplate(_TEMPLATE, _template);
  }

  String get name => instruction.name;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    var name = instruction.name;
    block.assign("CP", instruction.address);
    block.assign("NAME", name);
    return block.process();
  }
}
