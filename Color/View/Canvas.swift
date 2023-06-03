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
        let referenceColors = CanvasViewModel.referenceColors + [
            OklchColor(name: "P3 Red", xChromaticity: 0.6737, yChromaticity: 0.3263, luminance: 0.2388),
            OklchColor(name: "P3 Green", xChromaticity: 0.2520, yChromaticity: 0.6927, luminance: 0.6938),
            OklchColor(name: "P3 Blue", xChromaticity: 0.1563, yChromaticity: 0.0512, luminance: 0.0669)]
        self.vm = CanvasViewModel(
            colors: referenceColors + myColors,
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
                                .foregroundColor(color.extendedSRGB)
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
                Rectangle()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(vm.lastClickedColor?.extendedSRGB ?? .black)
                Text(vm.lastClickedColor?.name ?? vm.lastClickedColor?.representativeId ?? "")
                Text("lightness = \(vm.lastClickedColor?.l ?? 0)")
                Text("chromaticity = \(vm.lastClickedColor?.c ?? 0)")
                Text("hue = \(vm.lastClickedColor?.h ?? 0)")
                Text("a = \(vm.lastClickedColor?.a ?? 0)")
                Text("b = \(vm.lastClickedColor?.b ?? 0)")
            }
        }
    }
}

struct Canvas_Previews: PreviewProvider {
    static var previews: some View {
        Canvas(defaultWidth: 350)
    }
}
