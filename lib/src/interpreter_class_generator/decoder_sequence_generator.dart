part of string_matching.interpreter_class_generator;

class DecoderSequenceGenerator extends DecoderGenerator {
  static const String NAME = "_sequence";

  static const String _CH = GlobalNaming.CH;

  static const String _CURSOR = GlobalNaming.CURSOR;

  static const String _DATA = GlobalNaming.DATA;

  static const String _DECODE = MethodDecodeGenerator.NAME;

  static const String _RESULT = GlobalNaming.RESULT;

  static const String _SUCCESS = GlobalNaming.SUCCESS;

  static const int _OFFSET_INSTRUCTIONS = SequenceInstruction.STRUCT_SEQUENCE_INSTRUCTIONS;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
void $NAME(int cp) {  
  var index = 0;  
  var ch = $_CH; 
  var cursor = $_CURSOR;
  List<int> instructions = $_DATA[{{OFFSET}} + $_OFFSET_INSTRUCTIONS];
  var count = instructions.length;    
  $_DECODE(instructions[index++]);
  if (!$_SUCCESS) {
    return;
  }  
  var elements = new List(count--);
  elements[0] = $_RESULT;
  // TODO: Action goes here  
  while (count-- > 0) {
    $_DECODE(instructions[index]);
    if (!$_SUCCESS) {
      $_CH = ch;
      $_CURSOR = cursor;
      return;
    }
    elements[index++] = $_RESULT;
    // TODO: Action goes here
  }
  $_RESULT = elements;
}
''';

  DecoderSequenceGenerator(InterpreterClassGenerator interpreterClassGenerator) : super(interpreterClassGenerator) {
    addTemplate(_TEMPLATE, _template);
  }

  InstructionTypes get instructionType => InstructionTypes.SEQUENCE;

  String get name => NAME;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("OFFSET", dataFromCode("cp"));
    return block.process();
  }
}
