import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Next", destination:
                   SecondView()
                )
                Text("HomeScreen")
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tabItem {
            Label("Home", systemImage: "house.fill")
        }
    }
}

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Second")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Label("Voltar", systemImage: "arrow.backward.circle.fill" )
                }
            }
        }
    }
}
