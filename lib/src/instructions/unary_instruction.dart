part of string_matching.instructions;

abstract class UnaryInstruction extends Instruction {
  static const int OFFSET_INSTRUCTION = 0;

  Instruction instruction;

  UnaryInstruction(this.instruction) {
    if (instruction == null) {
      throw new ArgumentError("instruction: $instruction");
    }
  }

  int get size => Instruction.MIN_SIZE + 1;
}
