part of string_matching.instructions;

class SequenceElementInstruction extends UnaryInstruction {
  SequenceElementInstruction(Instruction instruction) : super(instruction);

  InstructionTypes get type => InstructionTypes.SEQUENCE_ELEMENT;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitSequenceElement(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return instruction.accept(visitor);
  }
}
