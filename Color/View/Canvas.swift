//
//  Canvas.swift
//  Color
//
//  Created by Aamos Kekkonen on 26.5.2023.
//

import SwiftUI

struct Canvas: View {
    @ObservedObject var vm: CanvasViewModel

    init(defaultWidth: CGFloat) {
        self.vm = CanvasViewModel(
            colors: try! FileReader.readColors(),
            initialCanvasWidth: defaultWidth,
            initialPointDiameter: 8.0)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .overlay(Circle().stroke(
                    Color.black,
                    style: StrokeStyle(lineWidth: 2.5)))
                .frame(width: vm.currentCanvasWidth,
                       height: vm.currentCanvasWidth)
            Circle()
                .frame(width: 5.0, height: 5.0)
            ForEach(vm.data) { colorRepresentationData in
                let color = colorRepresentationData.color
                let point = colorRepresentationData.point
                let diameter = colorRepresentationData.diameter
                ZStack {
                    Circle()
                        .foregroundColor(color.displayP3)
                        .frame(width: diameter, height: diameter)
                        .position(point)
                    Text(colorRepresentationData.color.name)
                        .font(.system(size: 11))
                        .position(point)
                        .offset(y: 10.0)
                }
                .onTapGesture {
                    colorRepresentationData.select()
                }
                
            }
        }
        .frame(width: vm.currentCanvasWidth, height: vm.currentCanvasWidth)
    }
}

struct Canvas_Previews: PreviewProvider {
    static var previews: some View {
        Canvas(defaultWidth: 350)
    }
}
