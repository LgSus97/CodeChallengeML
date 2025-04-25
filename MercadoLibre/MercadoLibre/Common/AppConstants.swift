//
//  AppConstants.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//


import Foundation

/// Centralized constants used across the app for networking and configuration.
enum AppConstants {
    
    // MARK: - API Configuration

    /// Default site ID used for Mercado Libre requests (e.g., MLM for Mexico).
    static let siteID = "MLM"

    /// Temporary hardcoded access token for testing.
    /// Note: This token will expire after a few (6) hours. Replace manually or implement refresh logic if needed.
    static let accessToken = "APP_USR-3339912005181956-042500-702334c5bed23b532af6796e34154787-710754186"
}
