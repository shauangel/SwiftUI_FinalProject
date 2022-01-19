//
//  CoverPageView.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/12.
//

import SwiftUI


struct CoverPageView: View {
    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false
    @State private var rotateDrgree: Double = 0
    
    var LongPress: some Gesture {
        LongPressGesture(minimumDuration: 5)
            .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                gestureState = currentState
                transaction.animation = Animation.easeIn(duration: 2.0)
            }
            .onEnded { finished in
                self.completedLongPress = finished
            }
    }
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [MyColorPlate.lightCyan, MyColorPlate.pewterBlue, MyColorPlate.cadet]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            Group {
                Image("vbSpike")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Circle()
                    .fill(self.isDetectingLongPress ? MyColorPlate.silverPink : (self.completedLongPress ? MyColorPlate.cerise: Color.black))
                    .frame(width: 42, height: 42)
                    .offset(x:28, y: -224)
                Image("vb")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(rotateDrgree))
                    .animation(
                        .linear(duration: 0.1)
                            .repeatForever(autoreverses: false),
                        value: rotateDrgree)
                    .frame(width: 45)
                    .offset(x:28, y: -224)
                    .onAppear {
                        rotateDrgree = 360
                    }
                    .gesture(LongPress)
            }
            .frame(height: UIScreen.main.bounds.height/3*2)
            .offset(y:-50)
            VStack {
                Spacer()
                    .frame(height: UIScreen.main.bounds.height/3*2)
                Text("VB Helper")
                    .font(.system(size: 70))
                    .fontWeight(.heavy)
                    .foregroundColor(MyColorPlate.cadet)
                
            }
        }
        .sheet(isPresented: $completedLongPress){
            SupriseView(completedLongPress: $completedLongPress)
        }
    }
}

struct SupriseView: View {
    @State private var triggerAlert = false
    @Binding var completedLongPress: Bool
    @StateObject var funViewModel = FunViewModel()
    
    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            HStack {
                Image(systemName: "hand.thumbsup")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                Text(String(funViewModel.funMeme.ups))
            }
            .foregroundColor(.gray)
            AsyncImage(url: URL(string: funViewModel.funMeme.url)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView("Loading...")
            }
            Text(funViewModel.funMeme.title)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                completedLongPress.toggle()
            }, label: {
                HStack {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                    Text("BACK")
                        .font(.title3)
                }
                .foregroundColor(.black)
            })
        }
        .onAppear {
            triggerAlert = funViewModel.fetchMeme()
        }
        .alert(isPresented: $triggerAlert) {
            Alert(
                        title: Text("Unable to Get Api Response"),
                        message: Text("The connection to the server was lost."),
                        primaryButton: .default(
                            Text("Try Again"),
                            action: {
                                triggerAlert = funViewModel.fetchMeme()
                            }
                        ),
                        secondaryButton: .destructive(
                            Text("Cancel"),
                            action: {
                                triggerAlert.toggle()
                            }
                        )
                    )
        }
    }
}

struct CoverPageView_Previews: PreviewProvider {
    static var previews: some View {
        CoverPageView()
    }
}




