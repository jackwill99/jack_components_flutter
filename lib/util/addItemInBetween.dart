// ignore_for_file: file_names

extension ListUtils<T> on List<T> {
  List<T> addItemInBetween<A extends T>(A item) => isEmpty
      ? this
      : (fold([], (r, element) => [...r, element, item])..removeLast());
}
