import Foundation
import HydraKitNetwork

/// A repository backed by a network data source.
public final class HKNetworkRepository<ID: Hashable & Sendable, Mapper: DTOMapper>: Readable, Writable, @unchecked Sendable {
    public typealias Model = Mapper.Model

    private let client: any NetworkClient
    private let requestBuilder: any RequestBuilding
    private let decoder: JSONDecoder
    private let mapper: Mapper
    private let readEndpoint: @Sendable (ID) -> any Endpoint
    private let readAllEndpoint: (@Sendable () -> any Endpoint)?
    private let saveEndpoint: (@Sendable (Mapper.DTO) -> any Endpoint)?
    private let deleteEndpoint: (@Sendable (ID) -> any Endpoint)?

    /// Creates a network repository.
    public init(
        client: any NetworkClient,
        requestBuilder: any RequestBuilding = RequestBuilder(),
        decoder: JSONDecoder = .ironBitDefault(),
        mapper: Mapper,
        readEndpoint: @escaping @Sendable (ID) -> any Endpoint,
        readAllEndpoint: (@Sendable () -> any Endpoint)? = nil,
        saveEndpoint: (@Sendable (Mapper.DTO) -> any Endpoint)? = nil,
        deleteEndpoint: (@Sendable (ID) -> any Endpoint)? = nil
    ) {
        self.client = client
        self.requestBuilder = requestBuilder
        self.decoder = decoder
        self.mapper = mapper
        self.readEndpoint = readEndpoint
        self.readAllEndpoint = readAllEndpoint
        self.saveEndpoint = saveEndpoint
        self.deleteEndpoint = deleteEndpoint
    }

    /// Reads a model by identifier from the network.
    public func read(id: ID) async throws -> Model? {
        let dto: Mapper.DTO = try await decode(endpoint: readEndpoint(id))
        return try mapper.mapToModel(dto)
    }

    /// Reads all models from the network.
    public func readAll() async throws -> [Model] {
        guard let readAllEndpoint else {
            throw HKRepositoryError.unsupportedOperation("readAllEndpoint chưa được cấu hình.")
        }

        let dtos: [Mapper.DTO] = try await decode(endpoint: readAllEndpoint())
        return try dtos.map(mapper.mapToModel)
    }

    /// Saves a model to the network.
    public func save(_ model: Model) async throws {
        guard let saveEndpoint else {
            throw HKRepositoryError.unsupportedOperation("saveEndpoint chưa được cấu hình.")
        }

        let dto = try mapper.mapToDTO(model)
        _ = try await rawData(endpoint: saveEndpoint(dto))
    }

    /// Deletes a model from the network.
    public func delete(id: ID) async throws {
        guard let deleteEndpoint else {
            throw HKRepositoryError.unsupportedOperation("deleteEndpoint chưa được cấu hình.")
        }

        _ = try await rawData(endpoint: deleteEndpoint(id))
    }

    private func decode<Value: Decodable>(endpoint: any Endpoint) async throws -> Value {
        let response = try await rawData(endpoint: endpoint)
        do {
            return try decoder.decode(Value.self, from: response.value)
        } catch {
            throw HKRepositoryError.mappingFailed(error.localizedDescription)
        }
    }

    private func rawData(endpoint: any Endpoint) async throws -> Response<Data> {
        let request = try requestBuilder.buildRequest(for: endpoint)
        do {
            return try await client.data(for: request)
        } catch {
            throw HKRepositoryError.networkFailed(error.localizedDescription)
        }
    }
}
