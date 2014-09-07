part of string_matching.interpreter_class_generator;

class MethodDecodeGenerator extends TemplateGenerator {
  static const String NAME = "_decode";

  static const String _CODE = GlobalNaming.CODE;

  static const String _OP = "op";

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
void $NAME(int cp) {
  var $_OP = $_CODE[cp];
  {{#STATES}}
  throw new StateError("Unknown instrcution $_OP");    
}
''';

  final InterpreterClassGenerator interpreterClassGenerator;

  List<DecoderGenerator> _generators;

  MethodDecodeGenerator(this.interpreterClassGenerator, List<DecoderGenerator> generators) {
    if (interpreterClassGenerator == null) {
      throw new ArgumentError("interpreterClassGenerator: $interpreterClassGenerator");
    }

    if (generators == null) {
       throw new ArgumentError("generators: $generators");
    }

    addTemplate(_TEMPLATE, _template);
    _generators = generators;
  }

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    var states = _generateStates();
    var stateMachine = new StateMachineGenerator("$_OP", states);
    stateMachine.generate();
    block.assign("#STATES", stateMachine.generate());
    return block.process();
  }

  // TODO: Default state with "bad state error"
  Map<int, List<String>> _generateStates() {
    var states = <int, List<String>>{};
    for (var generator in _generators) {
      states[generator.instructionType.id] = ["return ${generator.name}(cp);"];
    }

    return states;
  }
}