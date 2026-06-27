//
//  SwiftUIView.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-13.
//

import SwiftUI

public struct ModalNavigationDrawer<Drawer: View, Content: View, Data: Hashable>: View {

    @Binding
    private var isOpen: Bool
    
    @Binding
    private var path: [Data]

    private let root: Data
    private let drawer: Drawer
    private let content: (Data) -> Content
    private let drawerWidthRatio: CGFloat
    private let showNavigationButton: Bool
    
    @GestureState
    private var dragOffset: CGFloat = 0

    public init(
        isOpen: Binding<Bool>,
        path: Binding<[Data]>,
        root: Data,
        drawerWidthRatio: CGFloat = 0.85,
        showNavigationButton: Bool = true,
        @ViewBuilder drawer: () -> Drawer,
        @ViewBuilder content: @escaping (Data) -> Content
    ) {
        _isOpen = isOpen
        _path = path
        self.root = root
        self.drawerWidthRatio = drawerWidthRatio
        self.drawer = drawer()
        self.content = content
        self.showNavigationButton = showNavigationButton
    }

    public var body: some View {
            GeometryReader { geometry in
                
                let drawerWidth = geometry.size.width * drawerWidthRatio
                
                ZStack(alignment: .leading) {
                    
                    if #available(iOS 16.0, *) {
                        navigationStack()
                    } else {
                        navigationView(drawerWidth: drawerWidth)
                    }
                    
                    // MARK: - Overlay
                    if isOpen {
                        Color.black
                            .opacity(overlayOpacity(drawerWidth: drawerWidth))
                            .ignoresSafeArea()
                            .onTapGesture { close() }
                            .transition(.opacity)
                    }
                    
                    // MARK: - Drawer
                    drawer
                        .frame(width: drawerWidth)
                        .offset(x: currentOffset(drawerWidth: drawerWidth))
                        .shadow(radius: 12)
                        .gesture(dragGesture(drawerWidth: drawerWidth))
                        .opacity(drawerOpacity(drawerWidth: drawerWidth))
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isOpen)
                .gesture(edgeSwipeToOpen(drawerWidth: drawerWidth))
            }
    }
}


private extension ModalNavigationDrawer {
    
    @available(iOS 16.0, *)
    private func navigationStack() -> some View {
        NavigationStack(path: $path) {
            Spacer()
                .navigationDestination(for: Data.self) { data in
                    // MARK: - Main Content
                    content(data)
                        .disabled(isOpen)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(showNavigationButton)
                }
        }
        .onChange(of: path) { newPath in
            if newPath.isEmpty {
                path = [root]
            }
        }
    }
    
    // Fallback for iOS < 16
    private func navigationView(drawerWidth: CGFloat) -> some View {
        NavigationView {

            ZStack(alignment: .leading) {

                // MARK: - Main Content based on path last element
                if let current = path.last {
                    content(current)
                        .disabled(isOpen)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(showNavigationButton)
                }

                // MARK: - Overlay
                if isOpen {
                    Color.black
                        .opacity(overlayOpacity(drawerWidth: drawerWidth))
                        .ignoresSafeArea()
                        .onTapGesture { close() }
                }

                // MARK: - Drawer
                drawer
                    .frame(width: drawerWidth)
                    .offset(x: currentOffset(drawerWidth: drawerWidth))
                    .shadow(radius: 12)
                    .gesture(dragGesture(drawerWidth: drawerWidth))
                    .opacity(drawerOpacity(drawerWidth: drawerWidth))
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isOpen)
            .gesture(edgeSwipeToOpen(drawerWidth: drawerWidth))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: path) { newPath in
            if newPath.isEmpty {
                path = [root]
            }
        }
    }

    func currentOffset(drawerWidth: CGFloat) -> CGFloat {
        if isOpen {
            return max(dragOffset, -drawerWidth)
        } else {
            return -drawerWidth + max(dragOffset, 0)
        }
    }

    func overlayOpacity(drawerWidth: CGFloat) -> Double {
        let progress = 1 - abs(currentOffset(drawerWidth: drawerWidth)) / drawerWidth
        return Double(progress * 0.4)
    }
    
    func drawerOpacity(drawerWidth: CGFloat) -> Double {
        let progress = 1 - abs(currentOffset(drawerWidth: drawerWidth)) / drawerWidth
        return Double(progress)
    }

    func dragGesture(drawerWidth: CGFloat) -> some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                let threshold = drawerWidth * 0.4
                let velocity = value.velocity.width

                if isOpen {
                    if value.translation.width < -threshold || velocity < -500 {
                        close()
                    }
                } else {
                    if value.translation.width > threshold || velocity > 500 {
                        open()
                    }
                }
            }
    }

    func edgeSwipeToOpen(drawerWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onEnded { value in
                if !isOpen,
                   value.startLocation.x < 20,
                   value.translation.width > 100 {
                    open()
                }
            }
    }

    func open() {
        isOpen = true
    }

    func close() {
        isOpen = false
    }
}

private enum AppRoute: Hashable {
    case home
    case explore
    case info
}

#Preview("Drawer Preview") {

    struct PreviewWrapper: View {

        @State private var isOpen = false
        @State private var screens: [AppRoute] = [.home]

        var body: some View {

            ModalNavigationDrawer(
                isOpen: $isOpen,
                path: $screens,
                root: .home,
                drawerWidthRatio: 0.85,
                drawer: {
                    NavigationDrawerContent(
                        header: {
                            HStack{
                                Image(systemName: "homepod.and.appletv.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundColor(.blue)
                                    .padding()
                                
                                Spacer()
                                
                                Button(action: { isOpen = false }){
                                    Image(systemName:"line.3.horizontal.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .padding(.trailing, 8)
                                }
                            }
                        },
                        footer: {
                            Text("- About")
                        }
                    ) {
                        VStack(alignment: .leading){
                            Text("- Home")
                                .onTapGesture {
                                    isOpen = false
                                    screens.removeAll()
                                    screens.append(.home)
                                }
                            Text("- Explore")
                                .onTapGesture {
                                    isOpen = false
                                    screens.removeAll()
                                    screens.append(.explore)
                                }
                            Text("- Info")
                                .onTapGesture {
                                    isOpen = false
                                    screens.removeAll()
                                    screens.append(.info)
                                }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color.white)
                },
                content: { screen in
                    ZStack {
                        Color.gray.opacity(0.1)
                            .ignoresSafeArea()

                        VStack {
                            HStack {
                                Button(action: { isOpen = true }) {
                                    Image(systemName: "rectangle.stack")
                                        .foregroundStyle(Color.blue)
                                }
                                Spacer()
                            }
                            .padding()
                            
                            Spacer()
                            
                            Group {
                                switch screen {
                                case .home:
                                    ScrollView {
                                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 10) {
                                            ForEach(1...100, id: \.self) { i in
                                                Rectangle()
                                                    .fill(Color.blue.opacity(0.7))
                                                    .frame(height: 80)
                                                    .overlay(Text("\(i)").foregroundColor(.white))
                                                    .cornerRadius(8)
                                            }
                                        }
                                        .padding()
                                    }
                                    
                                case .explore:
                                    Text("This is exp screen")
                                        .foregroundStyle(Color.green)
                                    
                                case .info:
                                    Text("This is info screen")
                                        .foregroundStyle(Color.indigo)
                                }
                            }
                            .padding()
                            
                            Spacer()
                        }
                    }
                }
            )
        }
    }

    return PreviewWrapper()
}

