import Foundation

class UserService {
    static let shared = UserService()
    private let apiClient = APIClient()
    
    func followUser(userId: String, completion: ((Bool, Error?) -> Void)? = nil) {
        let endpoint = "users/\(userId)/follow"
        
        apiClient.post(endpoint: endpoint) { success, error in
            // Update local user cache if successful
            if success {
                NotificationCenter.default.post(name: .userFollowStatusChanged, object: nil)
            }
            completion?(success, error)
        }
    }
    
    func unfollowUser(userId: String, completion: ((Bool, Error?) -> Void)? = nil) {
        let endpoint = "users/\(userId)/unfollow"
        
        apiClient.post(endpoint: endpoint) { success, error in
            if success {
                NotificationCenter.default.post(name: .userFollowStatusChanged, object: nil)
            }
            completion?(success, error)
        }
    }
}
