part of string_matching.instructions;

class OneOrMoreInstruction extends UnaryInstruction {
  OneOrMoreInstruction(Instruction instruction) : super(instruction);

  InstructionTypes get type => InstructionTypes.ONE_OR_MORE;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitOneOrMore(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return this;
  }
}
