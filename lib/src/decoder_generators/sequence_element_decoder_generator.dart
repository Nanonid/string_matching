part of string_matching.decoder_generators;

class SequenceElementDecoderGenerator extends DecoderGenerator {
  static const String NAME = "_sequenceElement";

  static const String _ACTION = GlobalNaming.ACTION;

  static const String _DATA = GlobalNaming.DATA;

  static const String _DECODE = GlobalNaming.DECODE;

  static const String _RESULT = GlobalNaming.RESULT;

  static const String _SUCCESS = GlobalNaming.SUCCESS;

  static const int _OFFSET_FLAG = SequenceElementInstruction.STRUCT_SEQUENCE_ELEMENT_FLAG;

  static const int _OFFSET_INSTRUCTION = SequenceElementInstruction.STRUCT_SEQUENCE_ELEMENT_INSTRUCTION;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
void $NAME(int cp) {
  var offset = {{OFFSET}};
  cp = $_DATA[offset + $_OFFSET_INSTRUCTION];    
  $_DECODE(cp);
  if (!$_SUCCESS) {
    return;
  }
  if ($_DATA[offset + $_OFFSET_FLAG] & 1 != 0) {
    $_RESULT = $_ACTION(cp, $_RESULT); 
  }
}
''';

  SequenceElementDecoderGenerator() {
    addTemplate(_TEMPLATE, _template);
  }

  InstructionTypes get instructionType => InstructionTypes.SEQUENCE_ELEMENT;

  String get name => NAME;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("OFFSET", dataFromCode("cp"));
    return block.process();
  }
}
