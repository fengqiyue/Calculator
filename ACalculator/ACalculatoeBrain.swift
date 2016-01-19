//
//  ACalculatoeBrain.swift
//  ACalculator
//
//  Created by 张旭 on 15/12/21.
//  Copyright © 2015年 cheri. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description:String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol ,_):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }

    }
    
    private var opStack = [Op]()
    
    
    private var knownOps = [String:Op]()
    
    func clearAll() {    //用于实现『C』键
        opStack.removeAll()
    }
    
    func printAll() {  //查看一下栈
        print(opStack)
    }
    
    init() {
        func learnOp(op:Op) {
            knownOps[op.description] = op
        }
        
        knownOps["×"] = Op.BinaryOperation("×", *) //swift 中所有的运算都是函数，有返回值
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)

    }
    
    var program:AnyObject { //PropertyList
        get{
            return opStack.map {$0.description}
        }
        set{
            if let opSymbols = newValue as? Array<String> {
                var newOpstack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpstack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpstack.append(.Operand(operand))
                    }
                }
                opStack = newOpstack

            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) { //ops前有一个缺省的 let
        if !ops.isEmpty{
            var remainingOps = ops  //因为ops前有一个缺省的 let，所以要做一个它的拷贝
            let op = remainingOps.removeLast()
            switch op {
                
            case .Operand(let operand):            //.Operand 是 Op.Operand 的简写
                return (operand, remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps) //Tuple
                if let operand = operandEvaluation.result { //Tuple 的返回值
                    return (operation(operand), operandEvaluation.remainingOps)
                    
                }
                
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                }
            }
            
        }
        return (nil, ops)

    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
     }
    
    func pushOperand(operand:Double) ->Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOpeartion(symbol:String) ->Double? {
        if let Operation = knownOps[symbol] {
            opStack.append(Operation)
        }
        return evaluate()
    }
    
}
