part of string_matching.instructions;

class ProductionRuleInstruction extends Instruction {
  static const int STRUCT_PRODUCTION_RULE_INSTRUCTION = 0;

  static const int STRUCT_PRODUCTION_RULE_ID = 1;

  static const int SIZE_OF_STRUCT_PRODUCTION_RULE = 2;

  int id;

  Instruction instruction;

  final bool memoize;

  String name;

  ProductionRuleInstruction(this.id, this.name, this.instruction, {this.memoize: false}) {
    if (memoize == null) {
      throw new ArgumentError("memoize: $memoize");
    }
  }

  int get size => Instruction.MIN_SIZE + 1;

  InstructionTypes get type => InstructionTypes.PRODUCTION_RULE;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitProductionRule(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return instruction.accept(visitor);
  }
}
