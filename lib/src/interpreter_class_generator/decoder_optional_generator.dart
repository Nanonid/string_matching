part of string_matching.interpreter_class_generator;

class DecoderOptionalGenerator extends DecoderGenerator {
  static const String NAME = "_optional";

  static const String _DECODE = MethodDecodeGenerator.NAME;

  static const String _SUCCESS = GlobalNaming.SUCCESS;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
void $NAME(int cp) {
  $_DECODE({{DATA}});
  $_SUCCESS = true;
}
''';

  DecoderOptionalGenerator(InterpreterClassGenerator interpreterClassGenerator) : super(interpreterClassGenerator) {
    addTemplate(_TEMPLATE, _template);
  }

  InstructionTypes get instructionType => InstructionTypes.OPTIONAL;

  String get name => NAME;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("DATA", dataFromCode("cp"));
    return block.process();
  }
}
