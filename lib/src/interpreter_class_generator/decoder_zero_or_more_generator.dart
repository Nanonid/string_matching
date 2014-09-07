part of string_matching.interpreter_class_generator;

class DecoderZeroOrMoreGenerator extends DecoderGenerator {
  static const String NAME = "_zeroOrMore";

  static const String _DECODE = MethodDecodeGenerator.NAME;

  static const String _INPUT_LEN = GlobalNaming.INPUT_LEN;

  static const String _RESULT = GlobalNaming.RESULT;

  static const String _SUCCESS = GlobalNaming.SUCCESS;

  static const String _TESTING = GlobalNaming.TESTING;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
void $NAME(int cp) {    
  cp = {{DATA}};
  var testing = $_TESTING;
  $_TESTING = $_INPUT_LEN + 1;
  $_DECODE(cp);
  if (!$_SUCCESS) {
    $_TESTING = testing;
    $_SUCCESS = true;
    return;  
  }
  var elements = [$_RESULT];
  while(true) {
    $_TESTING = $_INPUT_LEN + 1;
    $_DECODE(cp);
    if (!$_SUCCESS) {
      break;
    }
    elements.add($_RESULT);    
  }
  $_TESTING = testing;
  $_RESULT = elements;
  $_SUCCESS = true;      
}
''';

  DecoderZeroOrMoreGenerator(InterpreterClassGenerator interpreterClassGenerator) : super(interpreterClassGenerator) {
    addTemplate(_TEMPLATE, _template);
  }

  InstructionTypes get instructionType => InstructionTypes.ZERO_OR_MORE;

  String get name => NAME;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("DATA", dataFromCode("cp"));
    return block.process();
  }
}
