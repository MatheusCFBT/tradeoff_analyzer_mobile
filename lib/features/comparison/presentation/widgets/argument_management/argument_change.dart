sealed class ArgumentChange {
  const ArgumentChange();
}

class ArgumentEdited extends ArgumentChange {
  const ArgumentEdited(this.text);
  final String text;
}

class ArgumentRemoved extends ArgumentChange {
  const ArgumentRemoved();
}
