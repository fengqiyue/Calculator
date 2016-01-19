//
//  ViewController.swift
//  ACalculator
//
//  Created by 张旭 on 15/12/20.
//  Copyright © 2015年 cheri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false  //用于检查本次是否是第一次输入
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
  
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOpeartion(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        brain.printAll()//!!!!!!!
    }
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        brain.printAll()//!!!!!!!
    }
    
    @IBAction func clearAll() {
        displayValue = 0
        brain.clearAll()
        brain.printAll()//!!!!!!!!
    }
    
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue   //返回一个Double
        }
        set{  //set方法自带了一个 newValue 变量
            display.text = "\(newValue)" //Double转为String
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
}

