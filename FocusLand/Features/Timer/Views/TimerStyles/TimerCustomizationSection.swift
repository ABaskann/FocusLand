import SwiftUI

struct TimerCustomizationSection: View {
    @Bindable var settings: TimerSettings
    let accentColor: Color
    
    private let colors: [Color] = [
        .white, .blue, .purple, .pink, .red, 
        .orange, .yellow, .green, .mint, .teal
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Timer Style")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Color Grid
            ColorGridView(colors: colors, selectedColor: accentColor) { color in
                settings.selectedColor = color.toHex() ?? "#FF9500"
            }
            
            Divider()
                .background(Color.gray.opacity(0.3))
                .padding(.vertical, 8)
            
            // Timer Style Scroll
            PremiumFeatureView{
                TimerStyleScrollView(settings: settings, accentColor: accentColor)
            }
            
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
}

private struct ColorGridView: View {
    let colors: [Color]
    let selectedColor: Color
    let onColorSelected: (Color) -> Void
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 16) {
            ForEach(colors, id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .opacity(color == selectedColor ? 1 : 0)
                    )
                    .onTapGesture {
                        onColorSelected(color)
                    }
            }
        }
    }
}

private struct TimerStyleScrollView: View {
    @Bindable var settings: TimerSettings
    let accentColor: Color
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(TimerStyle.allCases) { style in
                    TimerStyleButton(
                        style: style,
                        isSelected: settings.timerStyleEnum == style,
                        accentColor: accentColor
                    ) {
                        settings.timerStyle = style.rawValue
                    }
                }
            }
            .padding(.vertical, 8)
        }
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
