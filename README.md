<p>
<img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux-only" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-orange.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://raw.githubusercontent.com/uraimo/SwiftyGPIO/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

# SwiftGPIOLibrary

**A work in progress library to speed up your experiment with HW and Swift**
.
The library uses **[SwiftyGPIO](https://github.com/uraimo/SwiftyGPIO)** and its scope is to help you to avoid repetitive operations.

## 📖 How to implement
Use this library in your code it is very simple and it's possible only using [SwiftPM](https://swift.org/package-manager/).
In your `Package.swift` add this line in the **dependencies** section:
```swift
.Package(url: "https://github.com/darthpelo/SwiftGPIOLibrary.git", majorVersion: 0),
```

## ✨ Functions
What can you use right now?

1. Set up multiple pins as *output*, passing only the `GPIOName`
2. Set up multiple pins as *input*, passing only the `GPIOName`
3. Use a waiting function instead of `unsleep(x * 1000)`
4. Switch on multiple pins, passing only the `GPIOName`
5. Switch off multiple pins, passing only the `GPIOName`
6. Led blinking, passing the `GPIOName` and the blink frequency

### 1. Setup some pins as output

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

### 2. Setup some pins as input
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
### 3. Waiting milliseconds
```swift
/// Waiting an amount of milliseconds before continue with the process
///
/// - Parameter milliseconds: How many milliseconds wait
public func waiting(for milliseconds: UInt32) {
    usleep(milliseconds * Constant.ms)
}
```

### 4. Switch On
```swift
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
```

### 5. Switch Off
```swift
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
```
### 6. Led Blink
```swift
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
```
## 🔧 Example

In `Example/TestLibrary` you can find a program to run on your Rasbbery Pi to test SwiftGPIOLibrary.

## 🙏 Credits
This library is leaned on the great job of @uraimo [SwiftyGPIO](https://github.com/uraimo/SwiftyGPIO)
