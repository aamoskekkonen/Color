//
//  Canvas.swift
//  Color
//
//  Created by Aamos Kekkonen on 26.5.2023.
//

import SwiftUI

struct Canvas: View {
    @ObservedObject private var vm: CanvasViewModel
    @State private var layerSliderValue = 5.0
    @State private var isEditing = false

    init(defaultWidth: CGFloat) {
        let myColors = try! FileReader.readColors()
        let referenceColors = CanvasViewModel.referenceColors
        let P3Primaries = [
            OklchColor(name: "P3 Red", xChromaticity: 0.6737, yChromaticity: 0.3263, luminance: 0.2388),
            OklchColor(name: "P3 Green", xChromaticity: 0.2520, yChromaticity: 0.6927, luminance: 0.6938),
            OklchColor(name: "P3 Blue", x: 0.2042, y: 0.0669, z: 1.0352)]
        self.vm = CanvasViewModel(
            colors: P3Primaries,
            initialCanvasWidth: defaultWidth,
            initialPointDiameter: 8.0)
    }
    
    var body: some View {
        VStack {
            Text("\(Int(layerSliderValue))")
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
                    if color.representativeLightness == vm.layer {
                        let point = colorRepresentationData.point
                        let diameter = colorRepresentationData.diameter
                        ZStack {
                            Circle()
                                .foregroundColor(color.color)
                                .frame(width: diameter, height: diameter)
                                .position(point)
                                .onTapGesture {
                                    vm.toggleSelect(color: colorRepresentationData.color)
                                }
                            if vm.hasSelected(color: colorRepresentationData.color) {
                                let label = colorRepresentationData.color.name ?? colorRepresentationData.color.representativeId
                                Text(label)
                                    .font(.system(size: 11))
                                    .position(point)
                                    .offset(y: 10.0)
                            }
                        }
                    }
                    
                }
            }
            .frame(width: vm.currentCanvasWidth, height: vm.currentCanvasWidth)
            Slider(value: Binding<Double>(
                            get: { layerSliderValue },
                            set: { newValue in
                                layerSliderValue = newValue
                                vm.layer = Int(newValue)
                            }
                        ), in: 0...10) { editing in
                            isEditing = editing
                        }
                .padding()
                .frame(maxWidth: 200)
            VStack {
                if vm.lastClickedColor != nil {
                    let color = vm.lastClickedColor!
                    Rectangle()
                        .frame(width: 50.0, height: 50.0)
                        .foregroundColor(color.color)
                    Text(color.name ?? color.representativeId)
                    Text("lightness = \(color.l)")
                    Text("chromaticity = \(color.c)")
                    Text("hue = \(color.h)")
                    Text("a = \(color.a)")
                    Text("b = \(color.b)")
                    Text("sRGB = (\(color.sRGBComponents.red), \(color.sRGBComponents.green), \(color.sRGBComponents.blue))")
                    Text("Display P3 = (\(color.displayP3Components.red), \(color.displayP3Components.green), \(color.displayP3Components.blue))")
                }
                
            }
        }
    }
}

struct Canvas_Previews: PreviewProvider {
    static var previews: some View {
        Canvas(defaultWidth: 350)
    }
}
