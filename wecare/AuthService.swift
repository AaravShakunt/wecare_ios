//
//  AuthService.swift
//  wecare
//
//  Created by Harshit Pesala on 30/11/24.
//


import Foundation
import Supabase

class AuthService {
    let authclient: SupabaseClient
    
    init() {
        authclient = SupabaseClient(
            supabaseURL: URL(filePath: "https://sdriubluimifxhcwrkqe.supabase.co")!,
          supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNkcml1Ymx1aW1pZnhoY3dya3FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEzODk0NzMsImV4cCI6MjA0Njk2NTQ3M30.PuwznuKzc1Q-LjlfmLwyVwpYYKvztpVSkA5ib9jdVx4"
        )
    }
    
    func register(email: String, password: String, completion: @escaping (_ isSucceed: Bool, _ error: Error?) -> Void) async {
        do {
            try await authclient.auth.signUp(email: email, password: password)
            completion(true, nil)
        } catch {
            print("Failed to register. \(error.localizedDescription)")
            completion(false, error)
        }
    }
}
