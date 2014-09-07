part of string_matching.instructions;

class SequenceElemenInstruction extends UnaryInstruction {
  static const int OFFSET_INSTRUCTION = 0;

  SequenceElemenInstruction(Instruction instruction) : super(instruction);

  InstructionTypes get type => InstructionTypes.SEQUENCE_ELEMENT;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitSequenceElement(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return this;
  }
}
