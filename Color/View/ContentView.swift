//
//  ContentView.swift
//  Color
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = MainViewModel()
    var body: some View {
        GeometryReader { bounds in
            VStack {
                Spacer()
                Canvas(defaultWidth: bounds.size.width)
                Spacer()
            }
        }
        .background(Color.blue)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
