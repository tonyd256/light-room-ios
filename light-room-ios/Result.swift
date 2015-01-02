import Argo
import LlamaKit

func >>-<A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
  return a.flatMap(f)
}

func <^><A, B>(f: A -> B, a: Result<A>) -> Result<B> {
  return a.map(f)
}

func <*><A, B>(f: Result<A -> B>, a: Result<A>) -> Result<B> {
  switch f {
  case let .Success(fx): return a.map(fx.unbox)
  case let .Failure(e): return failure(e)
  }
}

func toResult<T>(t: T?) -> Result<T> {
  switch t {
  case let .Some(x): return success(x)
  case .None: return failure()
  }
}
