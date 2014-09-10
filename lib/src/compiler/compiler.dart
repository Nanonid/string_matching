part of string_matching.compiler;

class Compiler {
  List<int> _code;

  List _data;

  Map<dynamic, List<int>> _entries;

  void compile(Instruction instruction, List<int> code, List data) {
    if (instruction == null) {
      throw new ArgumentError("instruction: $instruction");
    }

    if (code == null) {
      throw new ArgumentError("code: $code");
    }

    if (data == null) {
      throw new ArgumentError("data: $data");
    }

    _code = code;
    _data = data;
    _entries = <dynamic, List<int>>{};
    _compile(instruction);
  }

  int _compile(Instruction instruction) {
    switch (instruction.type) {
      case InstructionTypes.AND_PREDICATE:
      case InstructionTypes.NOT_PREDICATE:
      case InstructionTypes.ONE_OR_MORE:
      case InstructionTypes.OPTIONAL:
      case InstructionTypes.SEQUENCE_ELEMENT:
      case InstructionTypes.ZERO_OR_MORE:
        return _compileUnary(instruction);
      case InstructionTypes.ANY_CHARACTER:
        return _compileAnyCharacter(instruction);
      case InstructionTypes.CHARACTER:
        return _compileCharacter(instruction);
      case InstructionTypes.CHARACTER_CLASS:
        return _compileCharacterClass(instruction);
      case InstructionTypes.EMPTY:
        return _compileEmpty(instruction);
      case InstructionTypes.LITERAL:
        return _compileLiteral(instruction);
      case InstructionTypes.ORDERED_CHOICE:
        return _compileOrderedChoice(instruction);
      case InstructionTypes.PRODUCTION_RULE:
        return _compileProductionRule(instruction);
      case InstructionTypes.RULE:
        return _compileRule(instruction);
      case InstructionTypes.SEQUENCE:
        return _compileSequence(instruction);
      default:
        throw new StateError("Unknown instruction: $instruction");
    }
  }

  // TODO: Optimize finding and removing data duplication
  int _allocate(List data) {
    if (data == null) {
      throw new ArgumentError("data: $data");
    }

    // var address = _findDuplicate(data);
    var address = _data.length;
    _data.addAll(data);
    return address;
  }

  int _compileAnyCharacter(AnyCharacterInstruction instruction) {
    if (instruction.address != null) {
      return instruction.address;
    }

    var address = _writeInstruction(instruction);
    return address;
  }

  int _compileCharacter(CharacterInstruction instruction) {
    if (instruction.address != null) {
      return instruction.address;
    }

    var address = _writeInstruction(instruction);
    // Data
    var data = new List(CharacterInstruction.SIZE_OF_STRUCT_CHARACTER);
    var character = instruction.character;
    data[CharacterInstruction.STRUCT_CHARACTER_RUNE] = character.runes.toList()[0];
    data[CharacterInstruction.STRUCT_CHARACTER_STRING] = character;
    _code[address + Instruction.OFFSET_DATA] = _allocate(data);
    return address;
  }

  int _compileCharacterClass(CharacterClassInstruction instruction) {
    if (instruction.address != null) {
      return instruction.address;
    }

    var address = _writeInstruction(instruction);
    // Data
    var groups = instruction.ranges.groups;
    var length = groups.length;
    var data = new List(CharacterClassInstruction.SIZE_OF_STRUCT_CHARACTER_CLASS + CharacterClassInstruction.SIZE_OF_STRUCT_RANGE * length);
    data[CharacterClassInstruction.STRUCT_CHARACTER_CLASS_COUNT] = length;
    var i = CharacterClassInstruction.STRUCT_CHARACTER_CLASS_RANGES;
    for (var group in groups) {
      var range = new List<int>(CharacterClassInstruction.SIZE_OF_STRUCT_RANGE);
      data[i + CharacterClassInstruction.STRUCT_RANGE_START] = group.start;
      data[i + CharacterClassInstruction.STRUCT_RANGE_END] = group.end;
      i += CharacterClassInstruction.SIZE_OF_STRUCT_RANGE;
    }

    _code[address + Instruction.OFFSET_DATA] = _allocate(data);
    return address;
  }

  int _compileEmpty(EmptyInstruction instruction) {
    if (instruction.address != null) {
      return instruction.address;
    }

    var address = _writeInstruction(instruction);
    return address;
  }

  int _compileLiteral(LiteralInstruction instruction) {
    if (instruction.address != null) {
      return instruction.address;
    }

    var address = _writeInstruction(instruction);
    // Data
    var string = instruction.string;
    var runes = string.runes.toList();
    var data = new List(LiteralInstruction.SIZE_OF_STRUCT_LITERAL);
    data[LiteralInstruction.STRUCT_LITERAL_RUNES] = runes;
    data[LiteralInstruction.STRUCT_LITERAL_STRING] = string;
    _code[address + Instruction.OFFSET_DATA] = _allocate(data);
    return address;
  }

  int _compileOrderedChoice(OrderedChoiceInstruction instruction) {
    if (instruction.address != null) {
      return instruction.address;
    }

    var address = _writeInstruction(instruction);
    // Data
    var instructions = instruction.instructions;
    var transitions = instruction.transitions.groups;
    var data = new List(OrderedChoiceInstruction.SIZE_OF_STRUCT_ORDERED_CHOICE);
    var structInstructions = new List<int>(instructions.length);
    var structTransitions = new List(transitions.length);
    data[OrderedChoiceInstruction.STRUCT_ORDERED_CHOICE_FLAG] = instruction.isOptional ? 1 : 0;
    data[OrderedChoiceInstruction.STRUCT_ORDERED_CHOICE_INSTRUCTIONS] = structInstructions;
    data[OrderedChoiceInstruction.STRUCT_ORDERED_CHOICE_TRANSITIONS] = structTransitions;
    for (var i = 0; i < instructions.length; i++) {
      structInstructions[i] = _compile(instructions[i]);
    }

    for (var i = 0; i < transitions.length; i++) {
      var transition = transitions[i];
      var instructions = <int>[];
      var structTransition = new List(OrderedChoiceInstruction.SIZE_OF_STRUCT_TRANSITION);
      structTransition[OrderedChoiceInstruction.STRUCT_TRANSITION_START] = transition.start;
      structTransition[OrderedChoiceInstruction.STRUCT_TRANSITION_END] = transition.end;
      structTransition[OrderedChoiceInstruction.STRUCT_TRANSITION_INTSRUCTIONS] = instructions;
      for (var instruction in transition.key) {
        instructions.add(_compile(instruction));
      }

      structTransitions[i] = structTransition;
    }

    _code[address + Instruction.OFFSET_DATA] = _allocate(data);
    return address;
  }

  int _compileProductionRule(ProductionRuleInstruction instruction) {
    if (instruction.address != null) {
      return instruction.address;
    }

    var address = _writeInstruction(instruction);
    // Data
    var data = new List(ProductionRuleInstruction.SIZE_OF_STRUCT_PRODUCTION_RULE);
    data[ProductionRuleInstruction.STRUCT_PRODUCTION_RULE_INSTRUCTION] = _compile(instruction.instruction);
    data[ProductionRuleInstruction.STRUCT_PRODUCTION_RULE_ID] = instruction.id;
    _code[address + Instruction.OFFSET_DATA] = _allocate(data);
    return address;
  }

  int _compileRule(RuleInstruction instruction) {
    if (instruction.address != null) {
      return instruction.address;
    }

    var address = _writeInstruction(instruction);
    // Data
    _code[address + Instruction.OFFSET_DATA] = _compile(instruction.instruction);
    return address;
  }

  int _compileSequence(SequenceInstruction instruction) {
    if (instruction.address != null) {
      return instruction.address;
    }

    var address = _writeInstruction(instruction);
    // Data
    var instructions = instruction.instructions;
    var structInstructions = new List<int>(instructions.length);
    var data = new List(SequenceInstruction.SIZE_OF_STRUCT_SEQUENCE);
    data[SequenceInstruction.STRUCT_SEQUENCE_INSTRUCTIONS] = structInstructions;
    for (var i = 0; i < instructions.length; i++) {
      structInstructions[i] = _compile(instructions[i]);
    }

    _code[address + Instruction.OFFSET_DATA] = _allocate(data);
    return address;
  }

  int _compileUnary(UnaryInstruction instruction) {
    if (instruction.address != null) {
      return instruction.address;
    }

    var address = _writeInstruction(instruction);
    // Data
    _code[address + Instruction.OFFSET_DATA] = _compile(instruction.instruction);
    return address;
  }

  int _findDuplicate(List data) {
    if (data == null) {
      throw new ArgumentError("data: $data");
    }

    var length = data.length;
    if (length == null) {
      throw new StateError("Data has no elements.");
    }

    var first = data.first;
    var entries = _entries[first];
    if (entries == null) {
      entries = <int>[];
      _entries[first] = entries;
      var address = data.length;
      entries.add(address);
      _data.addAll(data);
      return address;
    }

    for (var entry in entries) {
      var found = true;
      for (var i = 0; i < length; i++) {
        if (data[i] != _data[entry]) {
          found = false;
          break;
        }
      }

      if (found) {
        return entry;
      }
    }

    var address = data.length;
    entries.add(address);
    _data.addAll(data);
    return address;
  }

  int _writeInstruction(Instruction instruction) {
    if (instruction.address != null) {
      throw new StateError("Instruction '$instruction' already compiled.");
    }

    var address = _code.length;
    instruction.address = address;
    _code.length += instruction.size;
    _code[address + Instruction.OFFSET_ID] = instruction.type.id;
    return address;
  }
}
