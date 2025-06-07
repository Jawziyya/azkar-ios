import Supabase
import Foundation

enum SupabaseContructorError: Error {
    case noAPIKeyProvided
}

public let defaultSupabaseDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    // First formatter with fractional seconds
    let formatterWithFractionalSeconds = DateFormatter()
    formatterWithFractionalSeconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    formatterWithFractionalSeconds.timeZone = TimeZone(secondsFromGMT: 0)
    formatterWithFractionalSeconds.locale = Locale(identifier: "en_US_POSIX")

    // Second formatter without fractional seconds
    let formatterWithoutFractionalSeconds = DateFormatter()
    formatterWithoutFractionalSeconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatterWithoutFractionalSeconds.timeZone = TimeZone(secondsFromGMT: 0)
    formatterWithoutFractionalSeconds.locale = Locale(identifier: "en_US_POSIX")

    // Custom date decoding strategy
    decoder.dateDecodingStrategy = .custom { (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        if let date = formatterWithFractionalSeconds.date(from: dateString) {
            return date
        } else if let date = formatterWithoutFractionalSeconds.date(from: dateString) {
            return date
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string: \(dateString)")
        }
    }
    return decoder
}()

public let defaultSupabaseEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}()

func getSupabaseClient() throws -> SupabaseClient {
    guard
        let rawURL = readSecret(AzkarSecretKey.AZKAR_SUPABASE_API_URL),
        let url = URL(string: rawURL),
        let key = readSecret(AzkarSecretKey.AZKAR_SUPABASE_API_KEY)
    else {
        print("You must provide Supabase API key & url address.")
        throw SupabaseContructorError.noAPIKeyProvided
    }
    
    let client = SupabaseClient(
        supabaseURL: url,
        supabaseKey: key,
        options: SupabaseClientOptions(
            db: .init(
                encoder: defaultSupabaseEncoder,
                decoder: defaultSupabaseDecoder
            )
        )
    )
    return client
}
