import SwiftUI

struct BottomNavigationBar: View {
    var selectedIndex: Int
    var onItemSelected: (Int) -> Void

    var body: some View {
        HStack {
            BottomItem(
                icon: "calendar",
                title: "Início",
                isSelected: selectedIndex == 0,
                action: { onItemSelected(0) }
            )

            BottomItem(
                icon: "clock.fill",
                title: "Histórico",
                isSelected: selectedIndex == 1,
                action: { onItemSelected(1) }
            )

            BottomItem(
                icon: "chart.bar.fill",
                title: "Perfil",
                isSelected: selectedIndex == 2,
                action: { onItemSelected(2) }
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .background(Color(.systemBackground))
        .shadow(radius: 3)
    }
}

// Componente interno de cada item da barra
struct BottomItem: View {
    var icon: String
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? Color("MainColor") : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? Color("MainColor")  : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview("BottomNavigationBar") {
    VStack {
        Spacer() // só pra empurrar a barra pro fundo visualmente
        BottomNavigationBar(
            selectedIndex: 1, // simula "Histórico" selecionado
            onItemSelected: { index in
                print("🟩 Aba selecionada: \(index)")
            }
        )
    }
    .background(Color(.systemGray6))
    .ignoresSafeArea(edges: .bottom) // cola visualmente no fundo
}
