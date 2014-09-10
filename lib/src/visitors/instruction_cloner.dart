part of string_matching.visitors;

class InstructionCloner<T extends Instruction> implements InstructionVisitor<T> {
  Map<Instruction, Instruction> _visited;

  InstructionCloner() {
    _visited = <Instruction, Instruction>{};
  }

  Instruction visitAndPredicate(AndPredicateInstruction instruction) {
    return new AndPredicateInstruction(instruction.instruction.accept(this));
  }

  Instruction visitAnyCharacter(AnyCharacterInstruction instruction) {
    return new AnyCharacterInstruction();
  }

  Instruction visitCharacterClass(CharacterClassInstruction instruction) {
    return new CharacterClassInstruction(instruction.ranges);
  }

  Instruction visitCharacter(CharacterInstruction instruction) {
    return new CharacterInstruction(instruction.character);
  }

  Instruction visitEmpty(EmptyInstruction instruction) {
    return new EmptyInstruction();
  }

  Instruction visitLiteral(LiteralInstruction instruction) {
    return new LiteralInstruction(instruction.string);
  }

  Instruction visitNotPredicate(NotPredicateInstruction instruction) {
    return new NotPredicateInstruction(instruction.instruction.accept(this));
  }

  Instruction visitOneOrMore(OneOrMoreInstruction instruction) {
    return new OneOrMoreInstruction(instruction.instruction.accept(this));
  }

  Instruction visitOptional(OptionalInstruction instruction) {
    return new OptionalInstruction(instruction.instruction.accept(this));
  }

  // TODO: not tested
  Instruction visitOrderedChoice(OrderedChoiceInstruction instruction) {
    var foundInTransitions = new Set<Instruction>();
    // Check integrity
    for (var group in instruction.transitions.groups) {
      for (var instruction in group.key) {
        foundInTransitions.add(instruction);
      }
    }

    for (var instruction in instruction.instructions) {
      if(!foundInTransitions.contains(instruction)) {
        throw new StateError("Broken ordered choice instruction on '$instruction'.");
      }
    }

    var transitions = new SparseList<List<Instruction>>();
    var instructions = <Instruction>[];
    instructions.addAll(instruction.instructions);
    var length = instructions.length;
    var clones = <Instruction, Instruction>{};
    for (var group in instruction.transitions.groups) {
      var transitive = <Instruction>[];
      for (var instruction in group.key) {
        var clone = clones[instruction];
        if(clone == null) {
          clone = instruction.accept(this);
          clones[instruction] = clone;
        }

        for(var i = 0; i < length; i++) {
          if(instructions[i] == instruction) {
            instructions[i] = clone;
          }
        }

        transitive.add(clone);
      }

      transitions.addGroup(new GroupedRangeList<List<Instruction>>(group.start, group.end, transitive));
    }

    return new OrderedChoiceInstruction(instructions, transitions, instruction.isOptional);
  }

  Instruction visitProductionRule(ProductionRuleInstruction instruction) {
    var clone = _visited[instruction];
    if (clone != null) {
      return clone;
    }

    clone = new ProductionRuleInstruction(instruction.id, instruction.name, null);
    _visited[instruction] = clone;
    clone.instruction = instruction.instruction.accept(this);
    return clone;
  }

  Instruction visitRule(RuleInstruction instruction) {
    return new RuleInstruction(instruction.name, instruction.instruction.accept(this));
  }

  Instruction visitSequence(SequenceInstruction instruction) {
    var instructions = <Instruction>[];
    for (var instruction in instruction.instructions) {
      instructions.add(instruction.accept(this));
    }

    return new SequenceInstruction(instructions);
  }

  Instruction visitSequenceElement(SequenceElementInstruction instruction) {
    return new SequenceElementInstruction(instruction.instruction.accept(this));
  }

  Instruction visitZeroOrMore(ZeroOrMoreInstruction instruction) {
    return new ZeroOrMoreInstruction(instruction.instruction.accept(this));
  }
}
