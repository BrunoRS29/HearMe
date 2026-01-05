import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel: CalendarViewModel
    @State private var selectedTab = 0

    
    var body: some View {
        VStack {
            Text("Tela calendario")
            
            Spacer()
            
            BottomNavigationBar(
                selectedIndex: selectedTab,
                onItemSelected: { index in
                    selectedTab = index

                    switch index {
                    case 0:
                        print("🟢 Navbar ➜ Início selecionado")
                    case 1:
                        print("🟡 Navbar ➜ Histórico selecionado")
                        viewModel.goToHome()
                    case 2:
                        print("🟣 Navbar ➜ Perfil selecionado")
                        viewModel.goToProfile()
                        
                    default:
                        print("⚪️ Navbar ➜ Índice desconhecido: \(index)")
                    }
                }
            )
        }
        .background(Color("BackgroundColor"))
    }
    
}
