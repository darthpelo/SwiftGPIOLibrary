import Glibc
import SwiftyGPIO
import SwiftGPIOLibrary

enum Command: Int {
case One
case Two
case Blink
case Button
}

guard CommandLine.arguments.count == 2 else {
  print("Usage:  Test VALUE")
  print("VALUE: 0 = yellow led - 1 = green led")
  print("VALUE: 2 = blink - 3 = button input")
  exit(-1)
}

func switchOn(led: Command?) {
  guard let led = led else {
    return
  }

  // Setup pin 20 and 26 as output with value 0
  let list: [GPIOName] = [.P20, .P26]
  let gpios = setupOUT(ports: list, for: .RaspberryPi2)
  // Setup pin 18 as input
  let button = setupIN(ports: [.P18], for: .RaspberryPi2)[.P18]

  switch led {
  case .one:
    print("one")
    gpios[.P20]?.value = 1
    gpios[.P26]?.value = 0
  case .two:
    print("two")
    gpios[.P20]?.value = 0
    gpios[.P26]?.value = 1
  case .blink:
    print("blink")
    while true {
      gpios[.P20]?.value = gpios[.P20]?.value == 0 ? 1 : 0
      gpios[.P26]?.value = gpios[.P20]?.value == 0 ? 1 : 0
      waiting(for: 300)  // 300ms
    }
  case .button:
    print("button")
    var counter = 0
    while counter < 10 {
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
    gpios[.P20]?.value = 0
    gpios[.P26]?.value = 0
  }
}

let led = Int(CommandLine.arguments[1])

switchOn(led: Command(rawValue:led!))
