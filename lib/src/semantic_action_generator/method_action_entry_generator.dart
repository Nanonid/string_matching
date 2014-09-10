part of string_matching.semantic_action_generator;

class MethodActionEntryGenerator extends MethodGenerator {
  static const String _VALUES = "v";

  static const String _TEMPLATE = "TEMPLATE";

  static const String _TEMPLATE_SINGLE = "TEMPLATE_SINGLE";

  static const String _TEMPLATE_VARIABLES = "TEMPLATE_VARIABLES";

  static final String _template = '''
dynamic {{NAME}}(List $_VALUES, {{RESULT}}) {
  {{#VARIABLES}}
  {{#ACTION}}
  return {{RESULT}};
}
''';

  static final String _templateSingle = '''
dynamic {{NAME}}(final "\$1", {{RESULT}}) {  
  {{#ACTION}}
  return {{RESULT}};
}
''';

  static final String _templateVariables = '''
  var {{VARIABLES}};  
''';

  List<String> action;

  final String name;

  final int position;

  MethodActionEntryGenerator(this.name, this.action, this.position) {
    if (name == null) {
      throw new ArgumentError("name: $name");
    }

    if (action == null) {
      throw new ArgumentError("action: $action");
    }

    if (position != null && position < 0) {
      throw new ArgumentError("position: $position");
    }

    addTemplate(_TEMPLATE, _template);
    addTemplate(_TEMPLATE_SINGLE, _templateSingle);
    addTemplate(_TEMPLATE_VARIABLES, _templateVariables);
  }

  List<String> generate() {
    if (position == null) {
      return _generateSingle();
    } else {
      return _generate();
    }
  }

  List<String> _generate() {
    var block = getTemplateBlock(_TEMPLATE);
    block.assign("NAME", name);
    block.assign("RESULT", "\$\$");
    block.assign("#ACTION", action);
    block.assign("#VARIABLES", _generateVariables());
    return block.process();
  }

  List<String> _generateSingle() {
    var block = getTemplateBlock(_TEMPLATE_SINGLE);
    block.assign("NAME", name);
    block.assign("RESULT", "\$\$");
    block.assign("#ACTION", action);
    return block.process();
  }

  List<String> _generateVariables() {
    var block = getTemplateBlock(_TEMPLATE_VARIABLES);
    var vars = new List<String>();
    for (var i = 0; i <= position; i++) {
      vars[i] = "\$${i + 1} = _VARIABLES[$i]";
    }

    block.assign("VARIABLES", vars.join(", "));
    return block.process();
  }
}
