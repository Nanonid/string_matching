part of string_matching.instructions;

class EmptyInstruction extends Instruction {
  int get size => Instruction.MIN_SIZE;

  InstructionTypes get type => InstructionTypes.EMPTY;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitEmpty(this);
  }
}
