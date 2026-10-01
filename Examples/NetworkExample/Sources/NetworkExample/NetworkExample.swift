import Foundation
import IronBitCoreKitNetwork

struct UserDTO: Codable {
    let id: Int
    let name: String
}

@main
struct NetworkExample {
    static func main() async throws {
        // Stub JSON giúp demo chạy không phụ thuộc internet.
        let client = MockNetworkClient()
        try client.enqueue(.json(UserDTO(id: 1, name: "IronBit")))

        let request = URLRequest(url: URL(string: "https://api.example.com/users/1")!)
        let response = try await client.data(for: request)
        let user = try JSONDecoder.ironBitDefault().decode(UserDTO.self, from: response.value)

        print("Loaded user:", user.name)
        print("HTTP status:", response.status.rawValue)

        // App thật có thể thay MockNetworkClient bằng URLSessionNetworkClient:
        // let realClient = URLSessionNetworkClient()
        // let realResponse = try await realClient.data(for: request)
    }
}
