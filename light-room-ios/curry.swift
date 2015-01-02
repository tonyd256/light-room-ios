func curry<T, U, V>(f: (T, U) -> V) -> T -> U -> V {
  return { t in { f(t, $0) } }
}
