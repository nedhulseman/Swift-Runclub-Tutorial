//
//  LoginView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 6/19/25.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    var body: some View {
        VStack{
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height:400)
                .clipShape(Circle())
            TextField("E-mail", text:$email)
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            
            
            Button {
                Task {
                    do {
                        try await AuthService.shared.magicLinkLogin(email: email)
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Login")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .background(Color.yellow)
                    .clipShape(Capsule())
            }
            .disabled(email.count < 7)
        }
        .padding()
        .onOpenURL(perform: {url in
            Task {
                do {
                    try await AuthService.shared.handleOpenURL(url: url)
                } catch{
                    print(error.localizedDescription)
                }
            }
        })
    }
}

#Preview {
    LoginView()
}
