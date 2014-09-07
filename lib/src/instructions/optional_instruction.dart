part of string_matching.instructions;

class OptionalInstruction extends UnaryInstruction {
  OptionalInstruction(Instruction instruction) : super(instruction);

  InstructionTypes get type => InstructionTypes.OPTIONAL;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitOptional(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return this;
  }
}
