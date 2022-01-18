//
//  ContentView.swift
//  SwiftUI_FinalProject
//




import SwiftUI

struct ContentView: View {
    @State var showingSheet = false
    
    var content: some View {
        VStack {
            Text("Custom Sheet")
                .font(.largeTitle)
                .padding()
            Button(action: {
                showingSheet = true
            }) {
                Text("Open Sheet")
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var sheetView: some View {
        ActionSheetCard(photoURL: "", isShowing: $showingSheet)
    }
    
    var body: some View {
        ZStack {
            content
            ActionSheetCard(photoURL: "", isShowing: $showingSheet)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
