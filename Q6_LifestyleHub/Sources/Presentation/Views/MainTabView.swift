import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ActivitiesView()
                .tabItem { Label("Actividades", systemImage: "checklist") }
            MediaView()
                .tabItem { Label("Multimedia", systemImage: "play.rectangle") }
            PersonalizationView()
                .tabItem { Label("Personalizar", systemImage: "paintpalette") }
            ExploreView()
                .tabItem { Label("Explorar", systemImage: "square.grid.2x2") }
        }
    }
}
