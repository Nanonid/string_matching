part of string_matching.instructions;

class OrderedChoiceInstruction extends Instruction {
  static const int FLAG_IS_OPTIONAL = 1;

  static const int STRUCT_ORDERED_CHOICE_FLAG = 0;

  static const int STRUCT_ORDERED_CHOICE_INSTRUCTIONS = 1;

  static const int STRUCT_ORDERED_CHOICE_TRANSITIONS = 2;

  static const int SIZE_OF_STRUCT_ORDERED_CHOICE = 3;

  static const int STRUCT_TRANSITION_START = 0;

  static const int STRUCT_TRANSITION_END = 1;

  static const int STRUCT_TRANSITION_INTSRUCTIONS = 2;

  static const int SIZE_OF_STRUCT_TRANSITION = 3;

  List<Instruction> instructions;

  SparseList<List<Instruction>> transitions;

  bool isOptional;

  OrderedChoiceInstruction(this.instructions, this.transitions, this.isOptional) {
    if (transitions == null) {
      throw new ArgumentError("transitions: $transitions");
    }

    if (isOptional == null) {
      throw new ArgumentError("isOptional: $isOptional");
    }
  }

  int get size => Instruction.MIN_SIZE + 1;

  InstructionTypes get type => InstructionTypes.ORDERED_CHOICE;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitOrderedChoice(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return this;
  }
}
