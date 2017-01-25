#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

import SwiftyGPIO

public class GPIOLib {
  public class var sharedInstance: GPIOLib {
    struct Singleton {
      static let instance = GPIOLib()
    }
    return Singleton.instance
  }
  /// Returns a list of GPIOs configured as output
  ///
  /// - Parameters:
  ///   - ports: The ports to configure as output
  ///   - board: The board name
  /// - Returns: The output ports
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

  /// Returns a list of GPIOs configured as input
  ///
  /// - Parameters:
  ///   - ports: The ports to configure as input
  ///   - board: The board name
  /// - Returns: The input ports
  public func setupIN(ports: [GPIOName], for board: SupportedBoard) -> [GPIOName: GPIO] {
    let gpios = GPIOs(for: board)
    var result: [GPIOName: GPIO] = [:]
    for key in ports {
      if let gpio = gpios[key] {
        gpio.direction = .IN
        result[key] = gpio
      }
    }

    return result
  }

  public func switchOn(ports: [GPIOName], for board: SupportedBoard) {
    let gpios = GPIOs(for: board)
    for key in ports {
      if let gpio = gpios[key] {
        gpio.value = 1
      }
    }
  }

  public func switchOff(ports: [GPIOName], for board: SupportedBoard) {
    let gpios = GPIOs(for: board)
    for key in ports {
      if let gpio = gpios[key] {
        gpio.value = 0
      }
    }
  }

  /// Waiting an amount of milliseconds before continue with the process
  ///
  /// - Parameter milliseconds: How many milliseconds wait
  public func waiting(for milliseconds: UInt32) {
    usleep(milliseconds * Constant.milliseconds)
  }

  private struct Constant {
    static let milliseconds: UInt32 = 1000
  }

  private func GPIOs(for board: SupportedBoard) -> [GPIOName: GPIO] {
    return SwiftyGPIO.GPIOs(for: board)
  }
}
