part of string_matching.interpreter_class_generator;

class DecoderNotPredicateGenerator extends DecoderGenerator {
  static const String NAME = "_notPredicate";

  static const String _CH = GlobalNaming.CH;

  static const String _CURSOR = GlobalNaming.CURSOR;

  static const String _DECODE = MethodDecodeGenerator.NAME;

  static const String _INPUT_LEN = GlobalNaming.INPUT_LEN;

  static const String _RESULT = GlobalNaming.RESULT;

  static const String _SUCCESS = GlobalNaming.SUCCESS;

  static const String _TESTING = GlobalNaming.TESTING;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
void $NAME(int cp) {
  var ch = $_CH;
  var cursor = $_CURSOR;
  var testing = $_TESTING;
  $_TESTING = $_INPUT_LEN + 1;
  $_DECODE({{DATA}});
  $_TESTING = testing;
  $_CURSOR = cursor;
  $_CH = ch;
  $_SUCCESS = !$_SUCCESS;   
}
''';

  DecoderNotPredicateGenerator(InterpreterClassGenerator interpreterClassGenerator) : super(interpreterClassGenerator) {
    addTemplate(_TEMPLATE, _template);
  }

  InstructionTypes get instructionType => InstructionTypes.NOT_PREDICATE;

  String get name => NAME;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("DATA", dataFromCode("cp"));
    return block.process();
  }
}
