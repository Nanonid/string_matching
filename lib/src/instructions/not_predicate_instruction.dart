part of string_matching.instructions;

class NotPredicateInstruction extends UnaryInstruction {
  NotPredicateInstruction(Instruction instruction) : super(instruction);

  InstructionTypes get type => InstructionTypes.NOT_PREDICATE;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitNotPredicate(this);
  }
}
