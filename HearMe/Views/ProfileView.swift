import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @State private var selectedTab = 2
    
    var body: some View {
        VStack {
            Text("Profile")
            Text("bom")
            Text("dia")
            
            Spacer()
            
            BottomNavigationBar(
                selectedIndex: selectedTab,
                onItemSelected: { index in
                    selectedTab = index

                    switch index {
                    case 0:
                        print("🟢 Navbar ➜ Início selecionado")
                        viewModel.goToCalendar()
                    case 1:
                        print("🟡 Navbar ➜ Histórico selecionado")
                        viewModel.goToHome()
                    case 2:
                        print("🟣 Navbar ➜ Perfil selecionado")
                        
                    default:
                        print("⚪️ Navbar ➜ Índice desconhecido: \(index)")
                    }
                }
            )
        }
        .background(Color("BackgroundColor"))
    }
}
