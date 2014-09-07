part of string_matching.instructions;

class ZeroOrMoreInstruction extends UnaryInstruction {
  ZeroOrMoreInstruction(Instruction instruction) : super(instruction);

  InstructionTypes get type => InstructionTypes.ZERO_OR_MORE;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitZeroOrMore(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return this;
  }
}
