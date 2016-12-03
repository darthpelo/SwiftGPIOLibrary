#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

import SwiftyGPIO

fileprivate func GPIOs(for board: SupportedBoard) -> [GPIOName: GPIO] {
  return SwiftyGPIO.GPIOs(for: board)
}

public func setupOUT(gpios: [GPIOName], for board: SupportedBoard) -> [GPIOName: GPIO] {
  let list = GPIOs(for: board)

  for key in gpios {
    if let gpio = list[key] {
      gpio.direction = .OUT
      gpio.value = 0
      result[key] = gpio
    }
  }

  return result
}
