import Supabase
import Foundation

extension Date {
    var supabaseFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}

enum SupabaseContructorError: Error {
    case noAPIKeyProvided
}

func getSupabaseClient() throws -> SupabaseClient {
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
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    
    let kURL = "AZKAR_SUPABASE_API_URL"
    let kApiKey = "AZKAR_SUPABASE_API_KEY"
    let processEnv = ProcessInfo.processInfo.environment
    guard
        let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
        let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
        let rawURL = (dict[kURL] as? String)?.textOrNil ?? processEnv[kURL],
        let url = URL(string: rawURL),
        let key = (dict[kApiKey] as? String)?.textOrNil ?? processEnv[kApiKey]
    else {
        print("You must provide Supabase API key & url address.")
        throw SupabaseContructorError.noAPIKeyProvided
    }
    
    let client = SupabaseClient(
        supabaseURL: url,
        supabaseKey: key,
        options: SupabaseClientOptions(
            db: .init(
                encoder: encoder,
                decoder: decoder
            )
        )
    )
    return client
}
