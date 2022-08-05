//
//  ContentView.swift
//  Calculator
//
//  Created by Servontius Turner on 8/5/22.
//

import SwiftUI

let primaryColor = Color.init(red: 45/255, green: 0, blue: 247/255, opacity: 1.0)

struct ContentView: View {
    @State var finalValue:String = "Hello, Calculator!"
    @State var calcExpression: [String] = []
    @State var noBeingEntered: String = ""
    
    let rows = [
        ["7", "8", "9" ,"÷"],
        ["4", "5", "6" ,"x"],
        ["1", "2", "3" ,"-"],
        [".", "0", "=" ,"+"]
    ]
    
    var body: some View {
        VStack {
            
            VStack {
                Text(self.finalValue)
                    .font(Font.custom("HelveticaNeue-Thin", size: 78))
                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                    .foregroundColor(Color.white)
                
                Text(flattenTheExpression(exps: calcExpression))
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .frame(alignment: Alignment.bottomTrailing)
                    .foregroundColor(Color.white)
                
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .background(primaryColor)
            
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(rows, id: \.self) { row in
                    HStack(alignment: .top, spacing: 0) {
                        Spacer(minLength: 13)
                        ForEach(row, id: \.self) { column in
                            Button(action: {
                                if column == "=" {
                                    self.calcExpression = []
                                    self.noBeingEntered = ""
                                    return
                                } else if checkIfOperator(str: column)  {
                                    self.calcExpression.append(column)
                                    self.noBeingEntered = ""
                                } else {
                                    self.noBeingEntered.append(column)
                                    if self.calcExpression.count == 0 {
                                        self.calcExpression.append(self.noBeingEntered)
                                    } else {
                                        if !checkIfOperator(str: self.calcExpression[self.calcExpression.count-1]) {
                                            self.calcExpression.remove(at: self.calcExpression.count-1)
                                        }

                                        self.calcExpression.append(self.noBeingEntered)
                                    }
                                }

                                self.finalValue = processExpression(exp: self.calcExpression)
                                // This code ensures that future operations are done on evaluated result rather than evaluating the expression from scratch.
                                if self.calcExpression.count > 3 {
                                    self.calcExpression = [self.finalValue, self.calcExpression[self.calcExpression.count - 1]]
                                }
                            }, label: {
                                Text(column)
                                    .font(.system(size: getFontSize(btnTxt: column)))
                                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                            })
                            .foregroundColor(Color.white)
                            .background(getBackground(str: column))
                            .mask(CustomShape(radius: 45, value: column))
                        }
                    }
                }
            }
        .background(Color.black)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 414, maxHeight: .infinity, alignment: .topLeading)
    }
    .background(Color.black)
    .edgesIgnoringSafeArea(.all)
    }
}



func flattenTheExpression(exps: [String]) -> String {
    var calExp = ""
    for exp in exps {
        calExp.append(exp)
    }
    
    return calExp
}

struct CustomShape: Shape {
    let radius: CGFloat
    let value: String
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        let topLeftStart = CGPoint(x: rect.minX, y: rect.minY+radius)
        let topLeftCenter = CGPoint(x: rect.minX + radius, y: rect.minY+radius)
        
        path.move(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        
        if value == "÷" || value == "=" {
            path.addLine(to: topLeftStart)
            path.addRelativeArc(center: topLeftCenter, radius: radius, startAngle: Angle.degrees(90), delta: Angle.degrees(180))
        } else {
            path.addLine(to: topLeft)
        }
        
        return path
    }
}


func getBackground(str: String) -> Color {
    if checkIfOperator(str: str) {
        return primaryColor
    }
    return Color.black
}

func getFontSize(btnTxt: String) -> CGFloat {
    if checkIfOperator(str: btnTxt) {
        return 42
    }
    return 24
}

func checkIfOperator(str: String) -> Bool {
    if str == "÷" || str == "x" || str == "+" || str == "=" || str == "-" {
        return true
    }
    return false
}

func processExpression(exp: [String]) -> String {
    if exp.count < 3 {
        return "0.0"
    }
    
    var firstOperand = Double(exp[0])
    var secondOperand = Double("0.0")
    
    let expSize = exp.count
    
    for i in (1...expSize-2) {
        secondOperand = Double(exp[i+1])
        
        switch exp[i] {
        case "+":
            firstOperand! += secondOperand!
        case "-":
            firstOperand! -= secondOperand!
        case "x":
            firstOperand! *= secondOperand!
        case "÷":
            firstOperand! /= secondOperand!
        default:
            print("Skipping the rest")
        }
    }
    
    return String(format: "%.1f", firstOperand!)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
