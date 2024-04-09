//
//  Coordinator.swift
//  VxH-Cam
//
//  Created by XD on 09/04/2024.
//

import Foundation
import SwiftUI

class Coordinator: ObservableObject {
    @Published var currentDetent = PresentationDetent.medium
    @Published var path = NavigationPath()
    @Published var presentedPage: Page?
    var navigation:Navigation = .push
    enum Navigation {
        case push
        case present
        case modal
        case modalFromBottom
    }
    enum BackNavigation {
        case dismiss
        case pop
        case popAll
    }
    
    func route(to vc: Page, navigation:Navigation) {
        switch navigation {
        case .push:
            DispatchQueue.main.async {
                self.push(vc)
            }
        case  .modal:
            DispatchQueue.main.async {
                self.navigation = navigation
                var transaction = Transaction(animation: .easeInOut)
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    self.present(vc)
                }
            }
        case .present, .modalFromBottom:
            DispatchQueue.main.async {
                self.navigation = navigation
                self.present(vc)
            }
        }
    }
    
    func routeBack(navigation backNavigation:BackNavigation) {
        switch backNavigation {
        case .dismiss:
            DispatchQueue.main.async {
                var transaction = Transaction(animation: .linear)
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    self.dismiss()
                }
            }
        case .pop:
            DispatchQueue.main.async {
                self.pop()
            }
        case .popAll:
            DispatchQueue.main.async {
                self.popToRoot()
            }
        }
    }
}
extension Coordinator {
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .home:
            HomeView()
        case .popUpModal:
            PopUpModal()
        case .popUpBottom:
            PopUpBottom()
        case .detailView:
            DetailView()
        case .moreDetail:
            MoreDetailView()
        }
    }
    private func push(_ page: Page) {self.presentedPage = nil;path.append(page) }
    private func pop() {guard !path.isEmpty else {return};path.removeLast();}
    private func popToRoot() {guard !path.isEmpty else {return};path.removeLast(path.count);}
    private func present(_ page: Page) {presentedPage = page;}
    private func presentModal(_ page: Page) {}
    private func presentModalFromBottom(_ page: Page) {}
    private func dismiss() {presentedPage = nil;}
}
