import Combine
import Foundation
final class NetworkManager {
    private static var sharedInstance: NetworkManager?

    private var urlSession: URLSession

    static func getSharedInstance(with urlSession: URLSession = URLSession(configuration: .default)) -> NetworkManager {
        return sharedInstance ?? self.init(with: urlSession)
    }

    private init(with urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }

    func execute(request: EndPointProvider) -> AnyPublisher<Data, NetworkRequestError> {
        guard let urlRequest = request.urlRequest else {
            return Fail(error: NetworkRequestError.requestError)
                .eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkRequestError.unknown
                }
                return data
            }
            .mapError { error in
                if let error = error as? NetworkRequestError {
                    return error
                } else {
                    return NetworkRequestError.serverError(error: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
