part of string_matching.instructions;

class LiteralInstruction extends Instruction {
  static const int STRUCT_LITERAL_RUNES = 0;

  static const int STRUCT_LITERAL_STRING = 1;

  static const int SIZE_OF_STRUCT_LITERAL = 2;

  String string;

  LiteralInstruction(this.string) {
    if (string == null) {
      throw new ArgumentError("string: $string");
    }
  }

  int get size => Instruction.MIN_SIZE + 1;

  InstructionTypes get type => InstructionTypes.LITERAL;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitLiteral(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return this;
  }
}
