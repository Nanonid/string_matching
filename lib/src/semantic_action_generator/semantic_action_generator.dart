part of string_matching.semantic_action_generator;

class SemanticActionGenerator extends UnifyingInstructionVisitor<Instruction> {
  static const String _ACTION = MethodActionGenerator.NAME;

  Map<String, List<String>> _methods;

  Map<int, List<String>> _states;

  Set<Instruction> _visited;

  void generate(Instruction instruction, Map<String, List<String>> methods) {
    if (instruction == null) {
      throw new ArgumentError("instruction: $instruction");
    }

    if (methods == null) {
      throw new ArgumentError("methods: $methods");
    }

    _methods = methods;
    _states = <int, List<String>>{};
    _visited = new Set<Instruction>();
    instruction.accept(this);
    var generator = new MethodActionGenerator(_states);
    _methods[_ACTION] = generator.generate();
  }

  Instruction visitSequence(SequenceInstruction instruction) {
    var instructions = instruction.instructions;
    var length = instruction.instructions.length;
    for (var i = 0; i < length; i++) {
      _generate(instructions[i], i);
    }

    return instruction.accept(this);
  }

  Instruction visitSequenceElement(SequenceElementInstruction instruction) {
    _generate(instruction, null);
    return instruction.accept(this);
  }

  Instruction visitInstruction(Instruction instruction) {
    if (_visited.contains(instruction)) {
      return instruction;
    }

    _visited.add(instruction);
    return instruction.accept(this);
  }

  void _generate(Instruction instruction, int position) {
    var action = instruction.action;
    if (action == null) {
      return;
    }

    var address = instruction.address;
    var name = "${_ACTION}${address}";
    var generator = new MethodActionEntryGenerator(name, action, position);
    _methods[name] = generator.generate();
    _states[address] = null;
  }

}
