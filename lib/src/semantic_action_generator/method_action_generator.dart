part of string_matching.semantic_action_generator;

class MethodActionGenerator extends MethodGenerator {
  static const String NAME = '_action';

  static const String _CP = "cp";

  static const String _VALUE = "v";

  static const String _TEMPLATE = "TEMPLATE";

  static final String _template = '''
dynamic {{NAME}}(int $_CP, $_VALUE) {
  {{#STATES}}
  throw new StateError("Instruction at address $_CP nas no semantic action.");  
}
''';

  final Map<int, List<String>> states;

  MethodActionGenerator(this.states) {
    if (name == null) {
      throw new ArgumentError("name: $name");
    }

    if (states == null) {
      throw new ArgumentError("states: $states");
    }

    addTemplate(_TEMPLATE, _template);
  }

  String get name => NAME;

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    var stateMachine = new StateMachineGenerator("$_CP", states);
    block.assign("#STATES", stateMachine.generate());
    return block.process();
  }
}
