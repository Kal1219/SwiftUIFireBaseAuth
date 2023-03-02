//
//  ContentView.swift
//  SwiftUIFireBaseAuth
//
//  Created by Servicio Kaleb on 23/02/23.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject
{
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool
    {
        return auth.currentUser != nil
    }
    
    func signIn (email: String, password: String)
    {
        auth.signIn(withEmail: email, password: password)
        {
            [weak self] result, error in
            guard result != nil, error == nil else
            {
                return
            }
            DispatchQueue.main.async
            {
                //Success
                self?.signedIn = true
            }
            
        }
    }
    
    func signUp (email: String, password: String)
    {
        auth.createUser(withEmail: email, password: password)
        {
            [weak self] result, error in
            guard result != nil, error == nil else
            {
                return
            }
            DispatchQueue.main.async
            {
                //Success
                self?.signedIn = true
            }
        }
    }
    func signOut()
    {
        try? auth.signOut()
        
        self.signedIn = false
    }
}

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    
    var body: some View {
        NavigationView {
            if viewModel.signedIn
            {
                VStack
                {
                    Text("Estas Registrado")
                    
                    Button(action: {
                        viewModel.signOut()
                    }, label: {
                        Text("Cerrar Sesión")
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .padding()
                    })
                }

            }
            else
            {
                SignInView()
            }
        }
        .onAppear
        {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

struct SignInView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    
    var body: some View
    {
        VStack
        {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack
            {
                TextField("Correo Electronico", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("Contraseña", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else
                    {
                        return
                    }
                    
                    viewModel.signIn(email: email, password: password)
                    
                }, label: {
                    Text("Inicio de Sesión")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .cornerRadius(8)
                        .background(Color.blue)
                })
                
                NavigationLink("Crea tu cuenta", destination: SignUpView())
                    .padding()
            }
            .padding()
            
            
            Spacer()
        }
        .navigationTitle("Sign in")
    }
}

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    
    var body: some View
    {
        VStack
        {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack
            {
                TextField("Correo Electronico", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("Contraseña", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else
                    {
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password)
                    
                }, label: {
                    Text("Crea tu cuenta")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .cornerRadius(8)
                        .background(Color.blue)
                })
            }
            .padding()
            
            
            Spacer()
        }
        .navigationTitle("Creacion de cuenta")
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
