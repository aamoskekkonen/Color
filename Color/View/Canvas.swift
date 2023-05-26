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
            initialPointDiameter: 15.0)
    }
    
    var body: some View {
        ForEach(vm.data) { colorRepresentationData in
            let color = colorRepresentationData.color
            let point = colorRepresentationData.point
            let diameter = colorRepresentationData.diameter
            Circle()
                .foregroundColor(color.displayP3)
                .frame(width: diameter, height: diameter)
                .position(point)
            
        }
    }
}

struct Canvas_Previews: PreviewProvider {
    static var previews: some View {
        Canvas(defaultWidth: 350)
    }
}
