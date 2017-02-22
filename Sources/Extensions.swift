extension GPIOLib {
  fileprivate struct Constant {
      static let milliseconds: UInt32 = 1000
  }

  fileprivate func GPIOs(for board: SupportedBoard) -> [GPIOName: GPIO] {
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
