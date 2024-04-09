//
//  ContentView.swift
//  Coordinator-Navigation-SwiftUI
//
//  Created by Muhammad Farooq on 09/04/2024.
//

import SwiftUI

struct CoordinatorView: View {
    
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                coordinator.build(page: .home)
            }
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
        }
        .sheet(isPresented: Binding<Bool>(
            get: { self.coordinator.presentedPage != nil },
            set: { _ in }
        )) {
            if let page = self.coordinator.presentedPage {
                self.coordinator.build(page: page)
                    .presentationCompactAdaptation(self.coordinator.navigation == .modal  ? .fullScreenCover : .automatic)
                    .presentationDetents(self.coordinator.navigation == .modalFromBottom ? [.medium, .large]:  [.large])
                    .presentationDragIndicator(.hidden)
                    .presentationBackground(self.coordinator.navigation == .modal ? .clear : .primary)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .environmentObject(coordinator)
    }
}

struct HomeView: View {
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        VStack(alignment: .center) {
            Text("SwitfUI Navigation\nUsing Coordinator Pattern").font(.headline)  .multilineTextAlignment(.center)
                .lineLimit(2)
            Spacer().frame(height: 100)
            Text("MODAL").underline().foregroundStyle(.blue).onTapGesture {
                coordinator.route(to: .popUpModal, navigation: .modal)
            }
            Text("PRESENT").underline().foregroundStyle(.blue).onTapGesture {
                coordinator.route(to: .popUpBottom, navigation: .present)
            }
            Text("BOTTOM SHEET").underline().foregroundStyle(.blue).onTapGesture {
                coordinator.route(to: .popUpBottom, navigation: .modalFromBottom)
            }
            Text("PUSH").underline().foregroundStyle(.blue).onTapGesture {
                coordinator.route(to: .detailView, navigation: .push)
            }
        }
        .padding()
    }
}
struct PopUpModal: View {
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                VStack {
                    Color.red
                        .onTapGesture {
                            coordinator.routeBack(navigation: .dismiss)
                        }
                }.frame(width: geometry.size.width, height: 400, alignment: .center)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }.padding()
    }
}
struct PopUpBottom: View {
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        ZStack {
            Color.blue
        }
    }
}
struct DetailView: View {
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        ZStack {
            Color.green
            Text("Go to More Detail").onTapGesture {
                coordinator.route(to: .moreDetail, navigation: .push)
            }.foregroundStyle(.white)
        }.ignoresSafeArea()
    }
}
struct MoreDetailView: View {
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        ZStack {
            Color.white
            VStack {
                Text("Go to Parent").underline().foregroundStyle(.blue).onTapGesture {
                    coordinator.routeBack(navigation: .popAll)
                }
                Text("MODAL").underline().foregroundStyle(.blue).onTapGesture {
                    coordinator.route(to: .popUpModal, navigation: .modal)
                }
                Text("PRESENT").underline().foregroundStyle(.blue).onTapGesture {
                    coordinator.route(to: .popUpBottom, navigation: .present)
                }
                Text("BOTTOM SHEET").underline().foregroundStyle(.blue).onTapGesture {
                    coordinator.route(to: .popUpBottom, navigation: .modalFromBottom)
                }
            }
            
        }.ignoresSafeArea()
    }
}
#Preview {
    CoordinatorView()
}
