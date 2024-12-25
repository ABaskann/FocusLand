import SwiftUI
import SwiftData

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    @Environment(\.dismiss) private var dismiss
    @Bindable var settings: TimerSettings
    
    private let colors: [Color] = [
        .white, .blue, .purple, .pink, .red, 
        .orange, .yellow, .green, .mint, .teal
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    ColorSection(selectedColor: $selectedColor, colors: colors)
                    TimerStyleSection(selectedColor: selectedColor, settings: settings)
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Customize Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Color Section
private struct ColorSection: View {
    @Binding var selectedColor: Color
    let colors: [Color]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Theme Color")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 16) {
                ForEach(colors, id: \.self) { color in
                    ColorButton(color: color, isSelected: selectedColor == color) {
                        selectedColor = color
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
}

// MARK: - Timer Style Section
private struct TimerStyleSection: View {
    let selectedColor: Color
    @Bindable var settings: TimerSettings
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Timer Style")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(TimerStyle.allCases) { style in
                        TimerStyleButton(
                            style: style,
                            isSelected: settings.timerStyleEnum == style,
                            accentColor: selectedColor
                        ) {
                            settings.timerStyle = style.rawValue
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
}

// MARK: - Helper Views
private struct ColorButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 60, height: 60)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .opacity(isSelected ? 1 : 0)
            )
            .onTapGesture(perform: action)
    }
}

private struct TimerStyleButton: View {
    let style: TimerStyle
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: style.icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? accentColor : .gray)
            Text(style.name)
                .font(.caption)
                .foregroundColor(isSelected ? accentColor : .gray)
        }
        .frame(width: 80, height: 80)
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? accentColor : Color.clear, lineWidth: 2)
        )
        .onTapGesture(perform: action)
    }
} 