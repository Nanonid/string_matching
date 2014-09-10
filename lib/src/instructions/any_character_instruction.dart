part of string_matching.instructions;

class AnyCharacterInstruction extends Instruction {
  int get size => Instruction.MIN_SIZE;

  InstructionTypes get type => InstructionTypes.ANY_CHARACTER;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitAnyCharacter(this);
  }
}
