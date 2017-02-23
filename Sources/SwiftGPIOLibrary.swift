#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import SwiftyGPIO

protocol GPIOable {
  associatedtype Ports
}

public class GPIOLib: GPIOable {
    typealias Ports = [GPIOName: GPIO]

    public class var sharedInstance: GPIOLib {
        struct Singleton {
            static let instance = GPIOLib()
        }
        return Singleton.instance
    }

    fileprivate var board: SupportedBoard?

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

    /// Return the status of a specific GPIO
    ///
    /// - Parameter port: The GPIO
    /// - Returns: The Int that rapresents the GPIO status or nil
    func status(_ port: GPIO?) -> Int? {
        guard let port = port else {
            return nil
        }

        return port.value
    }

    /// Set the value of the ports to 1
    ///
    /// - Parameter ports: The array of ports
    public func switchOn(ports: [GPIOName]) {
        guard let board = board else {
            return
        }

        let gpios = GPIOs(for: board)
        for key in ports {
            if let gpio = gpios[key] {
                gpio.value = 1
            }
        }
    }

    /// Set the value of the ports to 0
    ///
    /// - Parameter ports: The array of ports
    public func switchOff(ports: [GPIOName]) {
        guard let board = board else {
            return
        }

        let gpios = GPIOs(for: board)
        for key in ports {
            if let gpio = gpios[key] {
                gpio.value = 0
            }
        }
    }

    /// Led blink function
    ///
    /// - Parameters:
    ///   - port: The port that controls the Led
    ///   - frequency: The frequency, in milliseconds, between each 1
    public func blink(port: GPIOName, withFrequency frequency: UInt32) {
        guard let board = board else {
            return
        }

        let gpios = GPIOs(for: board)
        let gpio = gpios[port]
        while true {
            gpio?.value = gpio?.value == 0 ? 1 : 0
            waiting(for: frequency)
        }
    }

    /// Waiting an amount of milliseconds before continue with the process
    ///
    /// - Parameter milliseconds: How many milliseconds wait
    public func waiting(for milliseconds: UInt32) {
        usleep(milliseconds * Constant.milliseconds)
    }
}

extension GPIOLib {
  fileprivate struct Constant {
      static let milliseconds: UInt32 = 1000
  }

  fileprivate func GPIOs(for board: SupportedBoard) -> Ports {
      self.board = board
      return SwiftyGPIO.GPIOs(for: self.board)
  }
}
