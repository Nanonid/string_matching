part of string_matching.optimizer;

class Optimizer {
  Instruction optimize(Instruction instruction) {
    if (instruction == null) {
      throw new ArgumentError();
    }

    return instruction;
  }
}
