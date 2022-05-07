//
//  ContentView.swift
//  CompositionalLayout
//
//  Created by Claudius Kockelmann on 01.05.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    // MARK: Hiding Native One
    init() {
        UITabBar.appearance().isHidden = true
    }
    @StateObject var imageFetcher: ImageFetcher = .init()
    
    @State var currentTab: Tab = .bookmark
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                NavigationView {
                    Group {
                        // MARK: Custom View
                        if let images = imageFetcher.fetchedImages{
                            ScrollView{
                                CompositionalView(items: images, id: \.id) { item in
            //                        ZStack {
            //                            Rectangle()
            //                                .fill(.cyan)
            //                            Text("\(item)")
            //                                .font(.title.bold())
            //                        }
                                    GeometryReader{ proxy in
                                        let size = proxy.size
                                        WebImage(url: URL(string: item.download_url))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: size.width, height: size.height)
                                            .cornerRadius(10)
                                            .onAppear {
                                                if images.last?.id == item.id {
                                                    imageFetcher.startPagination = true
                                                }
                                            }
                                    }
                                }
                                .padding()
                                .padding(.bottom, 10)
                                
                                if imageFetcher.startPagination && !imageFetcher.endPagination {
                                    ProgressView()
                                        .offset(y: -15)
                                        .onAppear{
                                            // MARK: Slight Delay
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                imageFetcher.updateImages()
                                            }
                                        }
                                }
                            }
                        } else {
                            ProgressView()
                        }
                    }
                    .navigationTitle("Compositional Layout")
                }
                    .tag(Tab.bookmark)
                Text("Time")
                    .applyBG()
                    .tag(Tab.time)
                Text("Camera")
                    .applyBG()
                    .tag(Tab.camera)
                Text("Chat")
                    .applyBG()
                    .tag(Tab.chat)
                Text("Settings")
                    .applyBG()
                    .tag(Tab.settings)
            }
            CustomTabbar(currentTab: $currentTab)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func applyBG()-> some View{
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color("BG")
                    .ignoresSafeArea()
            }
    }
}
