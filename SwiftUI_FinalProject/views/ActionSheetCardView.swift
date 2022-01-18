//
//  ActionSheetCard.swift
//  SwiftUI_FinalProject
//



import SwiftUI
import Combine

public struct ActionSheetCard: View {
    private let compWidth = UIScreen.main.bounds.width
    private let compHeight = UIScreen.main.bounds.height
    @State var offset = UIScreen.main.bounds.height
    @Binding var isShowing: Bool
    var photoURL: String
    
    //let items: [ActionSheetCardItem]
    let heightToDisappear = UIScreen.main.bounds.height
    let cellHeight: CGFloat = 400
    let backgroundColor: Color
    
    public init(
        photoURL: String,
        isShowing: Binding<Bool>,
        //items: [ActionSheetCardItem],
        backgroundColor: Color = Color.white
    ) {
        _isShowing = isShowing
        //self.items = items
        self.photoURL = photoURL
        self.backgroundColor = backgroundColor
    }
    
    func hide() {
        offset = heightToDisappear
        isShowing = false
    }
        
    var topHalfMiddleBar: some View {
        Capsule()
            .frame(width: 130, height: 5)
            .foregroundColor(Color.gray)
            .padding(.top, 20)
    }
    
    var itemsView: some View {
        VStack {
            AsyncImage(url: URL(string: photoURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ImagePlaceholdView(frameH: 100)
            }
        }
        .frame(maxWidth: compWidth, maxHeight: compHeight/2)
    }
    
    var interactiveGesture: some Gesture {
        DragGesture()
            .onChanged({ (value) in
                if value.translation.height > 0 {
                    offset = value.location.y
                }
            })
            .onEnded({ (value) in
                let diff = abs(offset-value.location.y)
                if diff > 100 {
                    hide()
                }
                else {
                    offset = 0
                }
            })
    }
    
    var outOfFocusArea: some View {
        Group {
            if isShowing {
                GreyOutOfFocusView {
                    self.isShowing = false
                }
            }
        }
    }
    
    var sheetView: some View {
        VStack {
            Spacer()
            VStack {
                topHalfMiddleBar
                itemsView
                Text("").frame(height: 20) // empty space
            }
            .background(backgroundColor)
            .cornerRadius(15)
            .offset(y: offset)
            .gesture(interactiveGesture)
            .onTapGesture {
                hide()
            }
        }
    }
    
    var bodyContet: some View {
        ZStack {
            outOfFocusArea
            sheetView
        }
        .onAppear {
            print(photoURL)
        }
    }
    
    public var body: some View {
        Group {
            if isShowing {
                bodyContet
            }
        }
        .animation(.default)
        .onReceive(Just(isShowing), perform: { isShowing in
            offset = isShowing ? 0 : heightToDisappear
        })
    }
}

struct ActionSheetCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            ActionSheetCard(photoURL: "https://iplay.sa.gov.tw/Upload/passeasyphotogym/%E5%85%A7%E6%B9%96%E9%AB%98%E4%B8%AD%E6%B4%BB%E5%8B%95%E4%B8%AD%E5%BF%83%E7%84%A1%E9%9A%9C%E7%A4%99%E9%9B%BB%E6%A2%AF%E7%85%A7%E7%89%8720170413094136.JPG", isShowing: .constant(true))
        }
    }
}
