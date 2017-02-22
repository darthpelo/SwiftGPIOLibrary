#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import SwiftyGPIO

extension GPIOLib {
  internal struct Constant {
      static let milliseconds: UInt32 = 1000
  }

  internal func GPIOs(for board: SupportedBoard) -> [GPIOName: GPIO] {
      return SwiftyGPIO.GPIOs(for: board)
  }
}

extension Optional {
	// `then` function executes the closure if there is some value
	func then(_ handler: (Wrapped) -> Void) {
		switch self {
		case .some(let wrapped): return handler(wrapped)
		case .none: break
		}
	}
}
