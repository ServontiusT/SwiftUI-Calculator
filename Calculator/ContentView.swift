//
//  ContentView.swift
//  Calculator
//
//  Created by Servontius Turner on 8/5/22.
//

import SwiftUI

let primaryColor = Color.init(red: 0, green: 116/255, blue: 178/255, opacity: 1.0)

struct ContentView: View {
    @State var finalValue:String = "Digital Curry Recipe"
    @State var calExpression: [String] = []
    
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
                
                Text(flattenTheExpression(exps: calExpression))
                    .font(Font.custom("HelveticaNeue-Thin", size: 24))
                    .frame(alignment: Alignment.bottomTrailing)
                    .foregroundColor(Color.white)
                
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .background(primaryColor)
            
            
            VStack {
                ForEach(rows, id: \.self) { row in
                    HStack(alignment: .top, spacing: 0) {
                        Spacer(minLength: 13)
                        ForEach(row, id: \.self) { column in
                            Button(action: {
                                
                            }, label: {
                                Text(column)
                                    .font(.system(size: getFontSize(btnTxt: column)))
                                    .frame(idealWidth: 100, maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                            })
                            .foregroundColor(Color.white)
                            .background(getBackground(str: column))
                            .mask(CustomShape(radius: 40, value: column))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
