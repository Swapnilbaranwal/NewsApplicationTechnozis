//
//  LoginView.swift
//  NewsApplication
//
//  Created by Swapnil Baranwal on 10/07/25.
//
import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    Button("Login") {
                        viewModel.login()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                
                Spacer()
                
                if viewModel.isSyncing {
                    ProgressView("Syncing...")
                        .padding()
                } else {
                    Button("Sync") {
                        viewModel.sync {
                            print("✅ Sync completed!")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                }

                NavigationLink("", destination: NewsRouterView(), isActive: $viewModel.shouldNavigate)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Please sync the app."), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Login")
        }
    }
}


