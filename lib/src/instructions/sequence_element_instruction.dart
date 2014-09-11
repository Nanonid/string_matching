part of string_matching.instructions;

class SequenceElementInstruction extends UnaryInstruction {
  static const int STRUCT_SEQUENCE_ELEMENT_FLAG = 0;

  static const int STRUCT_SEQUENCE_ELEMENT_INSTRUCTION = 1;

  static const int SIZE_OF_STRUCT_SEQUENCE_ELEMENT = 2;

  SequenceElementInstruction(Instruction instruction) : super(instruction);

  InstructionTypes get type => InstructionTypes.SEQUENCE_ELEMENT;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitSequenceElement(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return instruction.accept(visitor);
  }
}
