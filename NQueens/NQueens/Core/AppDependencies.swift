//
//  AppDependencies.swift
//  NQueens
//
//  Created by Anton Makarov on 28.02.2026.
//

import Foundation

/// Dependency Injection Container
///
/// A lightweight DI container without third-party libraries (e.g. Needle, Swinject).
/// All dependencies are created lazily and share the same lifecycle as the container.
///
/// For larger scale projects, Needle (compile-time safe) or Swinject could be considered,
/// but are overkill for the current project size.
///

final class AppDependencies {
    
    private(set) lazy var settingsService: ISettingsService = SettingsService()
    private(set) lazy var gameHistoryService: IGameHistoryService = GameHistoryService()
    private(set) lazy var gameValidationService: IGameValidationService = GameValidationService()
    
}
