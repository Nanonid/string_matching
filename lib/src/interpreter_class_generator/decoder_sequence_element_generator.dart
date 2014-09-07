part of string_matching.interpreter_class_generator;

class DecoderSequenceElementGenerator extends DecoderGenerator {
  static const String NAME = "_sequenceElement";

  static const String _DECODE = MethodDecodeGenerator.NAME;

  static const String _RESULT = GlobalNaming.RESULT;

  static const String _SUCCESS = GlobalNaming.SUCCESS;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
void $NAME(int cp) {   
  $_DECODE({{DATA}});
  if (!$_SUCCESS) {
    return;
  }
  // TODO: Action goes here
}
''';

  DecoderSequenceElementGenerator(InterpreterClassGenerator interpreterClassGenerator) : super(interpreterClassGenerator) {
    addTemplate(_TEMPLATE, _template);
  }

  InstructionTypes get instructionType => InstructionTypes.SEQUENCE_ELEMENT;

  String get name => NAME;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("DATA", dataFromCode("cp"));
    return block.process();
  }
}
