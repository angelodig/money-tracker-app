//
//  MainButtonView.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 24/11/20.
//

import SwiftUI

struct MainButtonView: View {
    @State private var menuBtnViewIsOpen: Bool = false
    @State private var addViewIsPresented: Bool = false
    
    var body: some View {
        
        ZStack {
            ///Background
            if menuBtnViewIsOpen {
                Group {
                    Color.white.edgesIgnoringSafeArea(.all)
                }.onTapGesture {
                    menuBtnViewIsOpen.toggle()
                }
            }
            VStack {
                Spacer()
                HStack {
                    ///Button Open
                    if menuBtnViewIsOpen {
                        Button(action: {
                        }) {
                            BasicImageBtnView(nameImage: "slider.horizontal.3")
                        }
                        VStack {
                            Button(action: {
                                self.addViewIsPresented = true
                            }) {
                                BasicImageBtnView(nameImage: "plus")
                            }
                            .sheet(isPresented: $addViewIsPresented, content: {
                                AddRecordView(recordData: RecordData(), mainButtonViewIsOpen: $menuBtnViewIsOpen, addIsPresented: $addViewIsPresented)
                            })
                            
                            Button(action: {
                                self.menuBtnViewIsOpen.toggle()
                            }) {
                                BasicImageBtnView(nameImage: "xmark")
                            }
                        }
                        Button(action: {
                        }) {
                            BasicImageBtnView(nameImage: "gear")
                        }
                    ///Button Close
                    } else {
                        Button(action: {
                            menuBtnViewIsOpen.toggle()
                        }) {
                            BasicImageBtnView(nameImage: "circle.grid.2x2.fill", colorImage: .blue, backgroundColor: .yellow)
                        }
                    }
                }
                .padding()
                .animation(.easeInOut)
            }
        }
    }
}

struct MainButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MainButtonView()
    }
}

//MARK: Basic UI Elements
struct BasicImageBtnView: View {
    var nameImage: String
    var colorImage: Color = .blue
    var backgroundColor: Color = .yellow
    var body: some View {
        Image(systemName: nameImage)
            .frame(width: 32.0, height: 32.0)
            .font(Font.title.weight(.bold))
            .padding()
            .background(backgroundColor)
            .cornerRadius(50)
            .foregroundColor(colorImage)
            .padding(5)
    }
}
