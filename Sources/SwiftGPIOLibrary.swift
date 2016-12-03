#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

import SwiftyGPIO

fileprivate func GPIOs(for board: SupportedBoard) -> [GPIOName: GPIO] {
  return SwiftyGPIO.GPIOs(for: board)
}

public func setupOUT(ports: [GPIOName], for board: SupportedBoard) -> [GPIOName: GPIO] {
  let gpios = GPIOs(for: board)
  var result: [GPIOName: GPIO] = [:]
  for key in ports {
    if let gpio = gpios[key] {
      gpio.direction = .OUT
      gpio.value = 0
      result[key] = gpio
    }
  }

  return result
}
