part of string_matching.instructions;

class SequenceInstruction extends Instruction {
  static const int STRUCT_SEQUENCE_INSTRUCTIONS = 0;

  static const int SIZE_OF_STRUCT_SEQUENCE = 1;

  List<Instruction> instructions;

  SequenceInstruction(this.instructions) {
    if (instructions == null) {
      throw new ArgumentError("instructions: $instructions");
    }
  }

  int get size => Instruction.MIN_SIZE + 1;

  InstructionTypes get type => InstructionTypes.SEQUENCE;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitSequence(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return this;
  }
}
