part of string_matching.decoder_generators;

class OrderedChoiceDecoderGenerator extends DecoderGenerator {
  static const String NAME = "_orderedChoice";

  static const String _CH = GlobalNaming.CH;

  static const String _DATA = GlobalNaming.DATA;

  static const String _DECODE = GlobalNaming.DECODE;

  static const String _EOF = GlobalNaming.EOF;

  static const String _RESULT = GlobalNaming.RESULT;

  static const String _SUCCESS = GlobalNaming.SUCCESS;

  static const int _FLAG_IS_ALWAYS_OPTIONAL = OrderedChoiceInstruction.FLAG_IS_ALWAYS_OPTIONAL;

  static const int _FLAG_IS_ALWAYS_ZERO_OR_MORE = OrderedChoiceInstruction.FLAG_IS_ALWAYS_ZERO_OR_MORE;

  static const int _OFFSET_FLAG = OrderedChoiceInstruction.STRUCT_ORDERED_CHOICE_FLAG;

  static const int _OFFSET_INSTRUCTIONS = OrderedChoiceInstruction.STRUCT_ORDERED_CHOICE_INSTRUCTIONS;

  static const int _OFFSET_TRANSITIONS = OrderedChoiceInstruction.STRUCT_ORDERED_CHOICE_TRANSITIONS;

  static const int _STRUCT_TRANSITION_START = OrderedChoiceInstruction.STRUCT_TRANSITION_START;

  static const int _STRUCT_TRANSITION_END = OrderedChoiceInstruction.STRUCT_TRANSITION_END;

  static const int _STRUCT_TRANSITION_INSTRUCTIONS = OrderedChoiceInstruction.STRUCT_TRANSITION_INTSRUCTIONS;

  static const int _SIZE_OF_STRUCT_TRANSITION = OrderedChoiceInstruction.SIZE_OF_STRUCT_TRANSITION;

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
void $NAME(int cp) {
  var offset = {{OFFSET}};   
  List transitions = $_DATA[offset + $_OFFSET_TRANSITIONS];  
  List<int> instructions;  
  for (var i = 0; i < transitions.length; i++) {
    List transition = transitions[i];
    if ($_CH >= transition[$_STRUCT_TRANSITION_START]) {
      if ($_CH <= transition[$_STRUCT_TRANSITION_END]) {      
        instructions = transition[$_STRUCT_TRANSITION_INSTRUCTIONS];         
        break;
      }
    } else {
      break;
    }
  }  
  if (instructions == null) {
    if($_CH == $_EOF) {      
      instructions = $_DATA[offset + $_OFFSET_INSTRUCTIONS];
    } else {
      var flag = $_DATA[offset + $_OFFSET_FLAG];
      if (flag & $_FLAG_IS_ALWAYS_OPTIONAL != 0) {
        if (flag & $_FLAG_IS_ALWAYS_ZERO_OR_MORE != 0) {
           $_RESULT = [];
        } else {
           $_RESULT = null;
        }        
        $_SUCCESS = true;      
      } else {
        $_RESULT = null;
        $_SUCCESS = false;
      }
      // TODO: failure
      // TODO: !!!Expectations!!!
      {{#FAILURE}}
      return;
    }
  }
  var index = 0;
  var count = instructions.length - 1;
  while (true) {
    $_DECODE(instructions[index++]);
    if ($_SUCCESS) {
      break;
    } else if (count-- == 0) {
      $_RESULT = null;
      $_SUCCESS = false;      
      // TODO: failure
      // TODO: !!!Expectations!!!
      {{#FAILURE}}
      break;       
    }  
  }
}
''';

  OrderedChoiceDecoderGenerator() {
    addTemplate(_TEMPLATE, _template);
  }

  InstructionTypes get instructionType => InstructionTypes.ORDERED_CHOICE;

  String get name => NAME;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("OFFSET", dataFromCode("cp"));
    // TODO: !!!Expectations!!!
    block.assign("#FAILURE", unexpected());
    return block.process();
  }
}
