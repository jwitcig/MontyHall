import Foundation

typealias Doors = [Int]
typealias InitialCorrect = Int
typealias SwitchedCorrect = Int

enum Winner {
    case stayed, switched
}

struct MontyHall {
    let trials: Int
    
    init(trials: Int = 100) {
        self.trials = trials
    }
    
    // Generates random set of doors, one with the prize behind it
    private func randomDoors() -> Doors {
        var doors = [0, 0, 0]
        doors[randomGuess()] = 1
        return doors
    }
    
    // Generates random pick between doors: 0, 1, or 2
    private func randomGuess() -> Int {
        return Int(arc4random() % 3)
    }
    
    // Determines if the supplied guess was correct
    private func isCorrect(guess: Int, forDoors doors: [Int]) -> Bool {
        return doors[guess] == 1
    }
    
    // Executes a single trial
    private func executeTrial() -> Winner {
        let doors = randomDoors()
        let initialGuess = randomGuess()
        
        var remaining: Doors = [0, 1, 2] // given the 3 starting doors
        remaining.remove(at: initialGuess) // remove the one you picked
        for door in remaining where doors[door] == 0 {          // identify an empty door
            remaining.remove(at: remaining.index(of: door)!)    // 'show' it to the player - remove it as an option
            break
        }
        
        let switchedGuess = remaining[0] // the remaining door is the door you can switch to
        
        let shouldSwitch = Int(arc4random() % 2) == 0 // random decision to switch, 0 or 1
        
        if shouldSwitch {
            if isCorrect(guess: switchedGuess, forDoors: doors) {
                return .switched
            } else {
                return .stayed
            }
        } else {
            if isCorrect(guess: initialGuess, forDoors: doors) {
                return .stayed
            } else {
                return .switched
            }
        }
    }
    
    func exectute() -> (Int, Int) {
        var initialCorrects = 0
        var switchedCorrects = 0
        
        for _ in 0..<trials {
            if executeTrial() == .stayed {
                initialCorrects += 1
            } else {
                switchedCorrects += 1
            }
        }
        return (initialCorrects, switchedCorrects)
    }
}

let monty = MontyHall(trials: 100)
let (initialCorrects, switchedCorrects) = monty.exectute()

let initialCorrectPercentage = Float(initialCorrects) / Float(monty.trials) * 100
let switchedCorrectPercentage = Float(switchedCorrects) / Float(monty.trials) * 100

print("Initial pick was correct \(initialCorrectPercentage)% of the time.")
print("Switched pick was correct \(switchedCorrectPercentage)% of the time.")

