import Foundation

/// Maps between transport DTOs and domain models.
public protocol DTOMapper: Sendable {
    /// The DTO type.
    associatedtype DTO: Codable & Sendable

    /// The domain model type.
    associatedtype Model: Sendable

    /// Converts a DTO into a domain model.
    /// - Parameter dto: The DTO to map.
    /// - Returns: The mapped domain model.
    func mapToModel(_ dto: DTO) throws -> Model

    /// Converts a domain model into a DTO.
    /// - Parameter model: The domain model to map.
    /// - Returns: The mapped DTO.
    func mapToDTO(_ model: Model) throws -> DTO
}
