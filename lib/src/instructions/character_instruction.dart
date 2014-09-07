part of string_matching.instructions;

class CharacterInstruction extends Instruction {
  static const int STRUCT_CHARACTER_RUNE = 0;

  static const int STRUCT_CHARACTER_STRING = 1;

  static const int SIZE_OF_STRUCT_CHARACTER = 2;

  String character;

  CharacterInstruction(this.character) {
    if (character == null || character.length != 1) {
      throw new ArgumentError("character: $character");
    }
  }

  int get size => Instruction.MIN_SIZE + 1;

  InstructionTypes get type => InstructionTypes.CHARACTER;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitCharacter(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return this;
  }
}
