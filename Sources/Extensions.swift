#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

extension Optional {
	// `then` function executes the closure if there is some value
	func then(_ handler: (Wrapped) -> Void) {
		switch self {
		case .some(let wrapped): return handler(wrapped)
		case .none: break
		}
	}
}
