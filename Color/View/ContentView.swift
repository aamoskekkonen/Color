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
        GeometryReader { canvas in
            
        }
        .background(Color.blue)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
