part of string_matching.instructions;

class OrderedChoiceInstruction extends Instruction {
  static const int FLAG_IS_ALWAYS_OPTIONAL = 1;

  static const int FLAG_IS_ALWAYS_ZERO_OR_MORE = 2;

  static const int STRUCT_ORDERED_CHOICE_FLAG = 0;

  static const int STRUCT_ORDERED_CHOICE_INSTRUCTIONS = 1;

  static const int STRUCT_ORDERED_CHOICE_TRANSITIONS = 2;

  static const int SIZE_OF_STRUCT_ORDERED_CHOICE = 3;

  static const int STRUCT_TRANSITION_START = 0;

  static const int STRUCT_TRANSITION_END = 1;

  static const int STRUCT_TRANSITION_INTSRUCTIONS = 2;

  static const int SIZE_OF_STRUCT_TRANSITION = 3;

  int flag;

  List<Instruction> instructions;

  SparseList<List<Instruction>> transitions;

  OrderedChoiceInstruction(this.instructions, this.transitions, this.flag) {
    if (transitions == null) {
      throw new ArgumentError("transitions: $transitions");
    }

    if (flag == null) {
      throw new ArgumentError("flag: $flag");
    }
  }

  int get size => Instruction.MIN_SIZE + 1;

  InstructionTypes get type => InstructionTypes.ORDERED_CHOICE;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitOrderedChoice(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    var list = <Instruction>[];
    for (var instruction in instructions) {
      list.add(instruction.accept(visitor));
    }

    return list;
  }
}
