part of string_matching.instructions;

class AndPredicateInstruction extends UnaryInstruction {
  AndPredicateInstruction(Instruction instruction) : super(instruction);

  InstructionTypes get type => InstructionTypes.AND_PREDICATE;

  Object accept(InstructionVisitor visitor) {
    return visitor.visitAndPredicate(this);
  }

  Object visitChildren(InstructionVisitor visitor) {
    return this;
  }
}
