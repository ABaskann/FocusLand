import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    @Environment(\.dismiss) private var dismiss
    
    private let colors: [Color] = [
        .white, .blue, .purple, .pink, .red, 
        .orange, .yellow, .green, .mint, .teal
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .opacity(selectedColor == color ? 1 : 0)
                            )
                            .onTapGesture {
                                selectedColor = color
                                dismiss()
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Color")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
} 