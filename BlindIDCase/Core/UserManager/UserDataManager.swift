//
//  UserDataManager.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 24.05.2025.
//

import Foundation

final class UserDataManager: ObservableObject {
    
    static let shared = UserDataManager()
    @Published var currentUser: User?
    
    private init() {}
    
    func fetchCurrentUser(completion: @escaping (Bool) -> Void) {
        UserService.shared.getCurrentUser { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        self.currentUser = user
                        completion(true)
                    case .failure:
                        // TODO: - Kullanıcı Verisi Alınırken Bir Hata oluştu diyerek çıkış yap butonu eklenmeli
                        self.currentUser = nil
                        completion(false)
                }
            }
        }
    }
    
    func clearUser() {
        self.currentUser = nil
    }
}
