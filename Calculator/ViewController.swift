//
//  ViewController.swift
//  Calculator
//
//  Created by Nikita Lukyantsev on 10.07.2022.
//

import UIKit

public enum ActionTag: Int {
    case Plus = 0
    case Minus = 1
    case Multiplication = 2
    case Division = 3
    case GetResult = 4
}

public enum SpecSymbolTag: Int {
    case Point = 0
    case LeftBracket = 1
    case RightBracket = 2
}

class ViewController: UIViewController {
    @IBOutlet weak var expression: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func inputDigit(_ sender: UIButton) {
        if expression.text?.last != ")" {
            expression.text! += "\(sender.tag)"
        }
    }
    
    @IBAction func inputAction(_ sender: UIButton) {
        guard let tag = ActionTag(rawValue: sender.tag),
              let lastSymbol = expression.text?.last,
              lastSymbol.isNumber || lastSymbol == ")"
        else { return }
        
        switch(tag) {
        case .Plus:
            expression.text! += "+"
        case .Minus:
            expression.text! += "-"
        case .Multiplication:
            expression.text! += "*"
        case .Division:
            expression.text! += "/"
        case .GetResult:
            let result = Calculate(expressionStr: expression.text!)
            expression.text = "\(result)"
            break
        }
    }
    
    @IBAction func inputSpec(_ sender: UIButton) {
        guard let tag = SpecSymbolTag(rawValue: sender.tag)
        else { return }
        
        switch(tag) {
        case .Point:
            if expression.text!.isEmpty {
                expression.text! += "0."
            }
            else if let isNum = expression.text?.last?.isNumber, isNum {
                expression.text! += "."
            }
        case .LeftBracket:
            if expression.text!.isEmpty || expression.text!.last == "(" || isActionSymbol(expression.text!.last!) {
                expression.text! += "("
            }
        case .RightBracket:
            if let lastSymbol = expression.text!.last,
                   lastSymbol == ")" || lastSymbol.isNumber {
                
                guard let leftBracketCount = expression.text?.filter({ $0 == "(" }).count,
                      let rightBracketCount = expression.text?.filter({ $0 == ")" }).count,
                      leftBracketCount > rightBracketCount
                else { return }
                
                expression.text! += ")"
            }
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        expression.text = ""
    }
    
    private func isActionSymbol(_ symbol: Character) -> Bool {
        return symbol == "+" || symbol == "-" || symbol == "*" || symbol == "/"
    }
    
    private func Calculate(expressionStr: String) -> Double {
        let mathExpression = NSExpression(format: expressionStr)
        return (mathExpression.expressionValue(with: nil, context: nil) as? Double)!
    }
}

