part of string_matching.state_machine_generator;

class StateMachineGenerator extends TemplateGenerator {
  static const String _TEMPLATE_CASE = "TEMPLATE_CASE";

  static const String _TEMPLATE_SWITCH = "TEMPLATE_SWITCH";

  static final _templateCase = '''
case {{VALUE}}:
  {{#ACTION}}''';

  static final _templateSwitch = '''
switch ({{VARIABLE}}) {
  {{#CASE}}
}''';

  Map<int, List<String>> _actions;

  String _name;

  StateMachineGenerator(String name, Map<int, List<String>> actions) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError("name: $name");
    }

    if (actions == null) {
      throw new ArgumentError("actions: $actions");
    }

    addTemplate(_TEMPLATE_CASE, _templateCase);
    addTemplate(_TEMPLATE_SWITCH, _templateSwitch);
    _actions = actions;
    _name = name;
  }

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE_SWITCH);
    block.assign("VARIABLE", _name);
    var keys = _actions.keys.toList();
    keys.toList().sort((a, b) => a.compareTo(b));
    for (var key in keys) {
      var blockCase = getTemplateBlock(_TEMPLATE_CASE);
      blockCase.assign("VALUE", key);
      blockCase.assign("#ACTION", _actions[key]);
      block.assign("#CASE", blockCase.process());
    }

    return block.process();
  }
}
