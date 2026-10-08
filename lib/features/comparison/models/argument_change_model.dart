sealed class ArgumentChangeModel {
  const ArgumentChangeModel();
}

class ArgumentEditedModel extends ArgumentChangeModel {
  const ArgumentEditedModel(this.text);
  final String text;
}

class ArgumentRemovedModel extends ArgumentChangeModel {
  const ArgumentRemovedModel();
}
