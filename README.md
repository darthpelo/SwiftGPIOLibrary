<p>
<img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux-only" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-orange.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://raw.githubusercontent.com/uraimo/SwiftyGPIO/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>

# SwiftGPIOLibrary

**A work in progress library to speed up your experiment with HW and Swift**
.
**This library uses [SwiftyGPIO](https://github.com/uraimo/SwiftyGPIO) and it scope is to help you to avoid repetetive operations**

## Functions
### Setup some pins as output

```swift
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
```
#### Example
```swift
let list: [GPIOName] = [.P20, .P26]
let gpios = setupOUT(ports: list, for: .RaspberryPi2)
gpios[.P20]?.value = 1
gpios[.P26]?.value = 0
```

### Setup some pins as input
```swift
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
```
#### Example
```swift
func a() {
  let button = setupIN(ports: [.P18], for: .RaspberryPi2)[.P18]
  while(counter < 10) {
    guard let value = button?.value else { return }
    if value == 0 {
      counter += 1
      gpios[.P20]?.value = 1
      gpios[.P26]?.value = 1
      waiting(for: 500) // 500ms
    } else {
      gpios[.P20]?.value = 0
      gpios[.P26]?.value = 0
    }
  }
}
```
