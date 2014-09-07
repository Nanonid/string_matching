part of string_matching.interpreter;

class Interpreter {
  final String name;

  final Instruction instruction;

  Interpreter(this.name, this.instruction) {
    if (name == null) {
      throw new ArgumentError("name: $name");
    }

    if (instruction == null) {
      throw new ArgumentError("instruction: $instruction");
    }
  }
}
