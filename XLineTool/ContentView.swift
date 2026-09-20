//
//  ContentView.swift
//  XLineTool
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            SetupBackground()

            VStack(spacing: 28) {
                SetupHeader()

                VStack(spacing: 12) {
                    SetupStep(
                        number: 1,
                        title: "Enable the extension",
                        description: "Open System Settings and turn on XLineTools under Xcode Source Editor extensions."
                    )

                    SetupStep(
                        number: 2,
                        title: "Assign keyboard shortcuts",
                        description: "Relaunch Xcode, open Key Bindings, and search for “XLine” to choose your shortcuts."
                    )
                }

                ExtensionStatusCard()
            }
            .frame(maxWidth: 560)
            .padding(36)
        }
        .frame(minWidth: 520, minHeight: 460)
    }
}

private struct SetupBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.accentColor.opacity(0.16),
                Color.accentColor.opacity(0.04),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

private struct SetupHeader: View {
    var body: some View {
        VStack(spacing: 14) {
            Image(.mainIcon)
                .resizable()
                .frame(width: 72, height: 72)

            VStack(spacing: 6) {
                Text("Welcome to XLineTool")
                    .font(.largeTitle.bold())

                Text("Two quick steps and your editing commands will be ready in Xcode.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

private struct SetupStep: View {
    let number: Int
    let title: LocalizedStringResource
    let description: LocalizedStringResource

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Text(number, format: .number)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(Color.accentColor, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(.background.opacity(0.65), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.separator.opacity(0.5))
        }
    }
}

import ExtensionKit
private struct ExtensionStatusCard: View {
    @Environment(\.openURL) private var openURL

    private let settingsURL = URL(
        string: "x-apple.systempreferences:com.apple.ExtensionsPreferences?extensionPointIdentifier=com.apple.dt.Xcode.extension.source-editor"
    )

    var body: some View {
        ViewThatFits {
            HStack(spacing: 16) {
                status
                Spacer(minLength: 12)
                settingsButton
            }

            VStack(alignment: .leading, spacing: 16) {
                status
                settingsButton
            }
        }
        .padding(18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var status: some View {
        HStack(spacing: 12) {
            Image(systemName: "circle.dashed")
                .font(.title2)
                .foregroundStyle(.orange)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Extension status: unknown")
                    .font(.headline)

                Text("Confirm that XLineTools is enabled")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var settingsButton: some View {
        Button {
            if let settingsURL {
                openURL(settingsURL)
            }
        } label: {
            Label("Open System Settings", systemImage: "gear")
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(settingsURL == nil)
    }
}

#Preview {
    ContentView()
        .frame(width: 640, height: 520)
}
