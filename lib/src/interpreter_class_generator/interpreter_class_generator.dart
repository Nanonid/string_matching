part of string_matching.interpreter_class_generator;

class InterpreterClassGenerator {
  static const String _ASCII = GlobalNaming.ASCII;

  static const String _CH = GlobalNaming.CH;

  static const String _CACHE = GlobalNaming.CACHE;

  static const String _CACHE_POS = GlobalNaming.CACHE_POS;

  static const String _CACHE_RULE = GlobalNaming.CACHE_RULE;

  static const String _CACHE_STATE = GlobalNaming.CACHE_STATE;

  static const String _CODE = GlobalNaming.CODE;

  static const String _COLUMN = GlobalNaming.COLUMN;

  static const String _CURSOR = GlobalNaming.CURSOR;

  static const String _DATA = GlobalNaming.DATA;

  static const String _EXPECTED = GlobalNaming.EXPECTED;

  static const String _FAILURE_POS = GlobalNaming.FAILURE_POS;

  static const String _FLAG = GlobalNaming.FLAG;

  static const String _INPUT_LEN = GlobalNaming.INPUT_LEN;

  static const String _LINE = GlobalNaming.LINE;

  static const String _RESULT = GlobalNaming.RESULT;

  static const String _RUNES = GlobalNaming.RUNES;

  static const String _SUCCESS = GlobalNaming.SUCCESS;

  static const String _TESTING = GlobalNaming.TESTING;

  final String name;

  List<String> _classLevelCode;

  List<Interpreter> _interpreters;

  Map<int, List<String>> _instructionStates;

  InterpreterClassGenerator(this.name, List<Interpreter> interpreters, {List<String> classLevelCode, bool memoize: false}) {
    if (name == null) {
      throw new ArgumentError("name: $name");
    }

    if (interpreters == null) {
      throw new ArgumentError("interpreters: $interpreters");
    }

    _classLevelCode = classLevelCode;
    _interpreters = interpreters;
    _instructionStates = <int, List<String>>{};
  }

  List<String> generate() {
    var constructors = <String>[];
    var methods = <String>[];
    var properties = <String>[];
    var variables = <String>[];
    _generateVariables(variables);
    _generateDecoders(methods);
    _generateMethods(methods);
    _writeInterpreters(methods, variables);
    var classGenerator = new ClassGenerator(constructors: constructors, methods: methods, name: name, properties: properties, variables: variables);
    return classGenerator.generate();
  }

  void _generateDecoders(List<String> methods) {
    var generators = <DecoderGenerator>[];
    generators.add(new DecoderAndPredicateGenerator(this));
    generators.add(new DecoderAnyCharacterGenerator(this));
    generators.add(new DecoderCharacterClassGenerator(this));
    generators.add(new DecoderCharacterGenerator(this));
    generators.add(new DecoderEmptyGenerator(this));
    generators.add(new DecoderLiteralGenerator(this));
    generators.add(new DecoderNotPredicateGenerator(this));
    generators.add(new DecoderOneOrMoreGenerator(this));
    generators.add(new DecoderOptionalGenerator(this));
    generators.add(new DecoderOrderedChoiceGenerator(this));
    generators.add(new DecoderProductionRuleGenerator(this));
    generators.add(new DecoderRuleGenerator(this));
    generators.add(new DecoderSequenceElementGenerator(this));
    generators.add(new DecoderSequenceGenerator(this));
    generators.add(new DecoderZeroOrMoreGenerator(this));
    for (var generator in generators) {
      methods.addAll(generator.generate());
    }

    var generator = new MethodDecodeGenerator(this, generators);
    var method = generator.generate();
    methods.addAll(method);
  }

  void _generateMethods(List<String> methods) {
    var productionRules = <ProductionRuleInstruction>[];
    for (var interpreter in _interpreters) {
      var resolver = new ProductionRuleFinder(interpreter.instruction);
      // productionRules.addAll(resolver.productionRules.where((r) => r.memoize));
      productionRules.addAll(resolver.productionRules);
    }

    // Cache
    var size = (productionRules.length >> 5) + 1;
    if (size != size << 5) {
      size++;
    }

    var generators = <Generator>[];
    generators.add(new ClassContructorGenerator(name));
    generators.add(new AccessorColumnGenerator());
    generators.add(new AccessorLineGenerator());
    generators.add(new MethodAddToCacheGenerator(size));
    generators.add(new MethodCalculatePosGenerator());
    generators.add(new MethodExpectedGenerator());
    generators.add(new MethodGetFromCacheGenerator());
    generators.add(new MethodFlattenGenerator());
    generators.add(new MethodInterpretGenerator());
    generators.add(new MethodResetGenerator());
    generators.add(new MethodToRunesGenerator());
    generators.add(new MethodToRuneGenerator());
    for (var generator in generators) {
      methods.addAll(generator.generate());
    }
  }

  // TODO:
  void _generateSemanticActions() {
  }

  void _generateVariables(List<String> variables) {
    variables.add('static final List<String> $_ASCII = new List<String>.generate(128, (c) => new String.fromCharCode(c));');
    //
    variables.add('List $_CACHE;');
    variables.add('int $_CACHE_POS;');
    variables.add('List<int> $_CACHE_RULE;');
    variables.add('List<int> $_CACHE_STATE;');
    variables.add('int $_CH;');
    variables.add('List<int> $_CODE;');
    variables.add('int $_COLUMN;');
    variables.add('int $_CURSOR;');
    variables.add('List $_DATA;');
    variables.add('List<String> $_EXPECTED;');
    variables.add('int $_FAILURE_POS;');
    variables.add('int $_FLAG;');
    variables.add('int $_INPUT_LEN;');
    variables.add('int $_LINE;');
    variables.add('Object $_RESULT;');
    variables.add('List<int> $_RUNES;');
    variables.add('bool $_SUCCESS;');
    variables.add('int $_TESTING;');
    variables.add('');
  }

  String _listToString(List list, [String separator = ", "]) {
    var strings = <String>[];
    for (var element in list) {
      if (element is List) {
        strings.add(_listToString(element));
      } else if (element is String) {
        strings.add("\"${escape(element)}\"");
      } else {
        strings.add(element.toString());
      }
    }

    return "[${strings.join(separator)}]";
  }

  void _writeInterpreters(List<String> methods, List<String> variables) {
    for (var interpreter in _interpreters) {
      var compiler = new Compiler();
      var code = <int>[];
      var data = [];
      compiler.compile(interpreter.instruction, code, data);
      var name = camelize(interpreter.name, true);
      var list = <String>[];
      var variable = "List<int> _${name}Code = [${code.join(", ")}];";
      variables.add(variable);
      //
      for (var element in data) {
        if (element is int || element is String || element is List) {
        } else {
          throw new StateError("Unsupported data type '${element.runtimeType}'");
        }
      }

      list = _listToString(data);
      variable = "List<int> _${name}Data = $list;";
      variables.add(variable);
      var method = new MethodParseEntryGenerator(name).generate();
      methods.addAll(method);
    }
  }
}
