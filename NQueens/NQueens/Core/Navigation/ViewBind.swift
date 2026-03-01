//
//  ViewBind.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import SwiftUI

// MARK: - Workaround
// SwiftUI.AtomicBuffer holds a strong reference to @Observable object
// when passed directly via Binding to NavigationStack/sheet.
// Intermediate @State breaks the retain - buffer holds @State instead
// of coordinator, allowing proper deallocation.
// Known SwiftUI + @Observable issue, reproducible via Memory Graph.

extension View {
    func bind<Destination: Hashable, Sheet: Identifiable & Hashable>(
        to coordinator: FlowCoordinator<Destination, Sheet>,
        path: Binding<[Destination]>,
        sheet: Binding<Sheet?>
    ) -> some View {
        self
            .onChange(of: coordinator.path) { _, newValue in path.wrappedValue = newValue }
            .onChange(of: coordinator.sheet) { _, newValue in sheet.wrappedValue = newValue }
            .onChange(of: path.wrappedValue) { _, newValue in coordinator.path = newValue }
            .onChange(of: sheet.wrappedValue) { _, newValue in coordinator.sheet = newValue }
    }
}
