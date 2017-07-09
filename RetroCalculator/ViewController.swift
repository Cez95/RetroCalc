//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Chris Olson on 7/9/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var outPutLabel: UILabel!
    var btnSound: AVAudioPlayer! //Holds the sound of the button
    
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty // Sets current value in calculator to empty
    var runningNumber = ""
    var leftValString = ""
    var rightValString = ""
    var newResult = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav") // Loads the button (btn.wav) is the name of the sound file
        
        let soundUrl = URL(fileURLWithPath: path!) // The path to where our sound is located
        
        // If there is no way for sound to play, this statement will accept error and allow calculator to function w/o sound
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundUrl)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
            
        }

    }
    
    // Links the buttons so when they are pressed, the play sound method is called
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        runningNumber += "\(sender.tag)" // Every time a button is pressed, the tag associated will be sent over.
        outPutLabel.text = runningNumber // This appends the new running number to the output label
    }
    
    @IBAction func onDividePressed(sender: Any) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: Any) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: Any) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(sender: Any) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: Any) {
        processOperation(operation: currentOperation)
    }
    
    // This function clears the calculator and sets the display label to 0
    @IBAction func onClearPressed (sender: Any) {
        runningNumber.removeAll()
        leftValString.removeAll()
        rightValString.removeAll()
        currentOperation = Operation.Empty
        outPutLabel.text = "0" //displayStack() // remove !
    }
    
    // This funtion controls playing the sound.
    func playSound () {
        if btnSound.isPlaying { // The if statement stops the sound as soon as it starts
            btnSound.stop()
        }
        btnSound.play() // Actually plays the sound
    }
   
    func processOperation(operation: Operation){
        // Checks to see if a value is in the calcualtor
        if currentOperation != Operation.Empty {
            // Checks to see if a user pressed a number and then pressed another number
            if runningNumber != "" {
                rightValString = runningNumber // Sets the right position or nect number entered to our runningnumber
                runningNumber = ""
                
                // This does all of the math operations
                if currentOperation == Operation.Multiply {
                    newResult = "\(Double(leftValString)! * Double(rightValString)!)"
                } else if currentOperation == Operation.Divide {
                    newResult = "\(Double(leftValString)! / Double(rightValString)!)"
                } else if currentOperation == Operation.Subtract {
                    newResult = "\(Double(leftValString)! - Double(rightValString)!)"
                } else if currentOperation == Operation.Add {
                    newResult = "\(Double(leftValString)! + Double(rightValString)!)"
                }
                
                leftValString = newResult
                outPutLabel.text = newResult
            
            }
            currentOperation = operation
        } else {
            // This is the first time an operator was pressed
            leftValString = runningNumber
            runningNumber = ""
            currentOperation = operation
            
        }
    }
}

