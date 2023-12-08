import Foundation
import Entities
import Combine

/// `DatabaseService` Protocol
///
/// A protocol that defines methods for accessing and retrieving data from a database.
/// It supports operations for various types hadith, fadl and zikr.
/// It is designed to handle multi-language content and provide translations where available.
public protocol DatabaseService {
    
    /// The language in which the service provides the data.
    var language: Language { get }
    
    /// Checks if a translation for a specific language exists in the database.
    ///
    /// - Parameter language: The language to check for available translations.
    /// - Returns: A Boolean value indicating whether a translation exists.
    func translationExists(for language: Language) -> Bool
    
    /// Retrieves all Hadith records from the database.
    ///
    /// - Throws: An error if the retrieval fails.
    /// - Returns: An array of `Hadith` objects.
    func getAhadith() throws -> [Hadith]
    
    /// Retrieves a specific Hadith by its identifier.
    ///
    /// - Parameter id: The identifier of the Hadith.
    /// - Throws: An error if the retrieval fails.
    /// - Returns: An optional `Hadith` object. Nil if not found.
    func getHadith(_ id: Int) throws -> Hadith?
    
    /// Retrieves the count of all Fadail (virtues) records.
    ///
    /// - Throws: An error if the count cannot be retrieved.
    /// - Returns: The total count of Fadail records as an Int.
    func getFadailCount() throws -> Int
    
    /// Retrieves a specific Fadl (virtue) by its identifier.
    ///
    /// - Parameters:
    ///   - id: The identifier of the Fadl.
    ///   - language: An optional parameter to specify the language of the Fadl. Defaults to nil.
    /// - Throws: An error if the retrieval fails.
    /// - Returns: An optional `Fadl` object. Nil if not found.
    func getFadl(_ id: Int, language: Language?) throws -> Fadl?
    
    /// Retrieves a random Fadl (virtue) from the database, optionally in a specified language.
    ///
    /// - Parameter language: An optional parameter to specify the language of the Fadl. Defaults to nil.
    /// - Throws: An error if the retrieval fails.
    /// - Returns: An optional `Fadl` object. Nil if not found.
    func getRandomFadl(language: Language?) throws -> Fadl?
    
    /// Retrieves all Fadail (virtues) from the database, optionally in a specified language.
    ///
    /// - Parameter language: An optional parameter to specify the language of the Fadail. Defaults to nil.
    /// - Throws: An error if the retrieval fails.
    /// - Returns: An array of `Fadl` objects.
    func getFadail(language: Language?) throws -> [Fadl]
    
    /// Retrieves a specific Zikr by its identifier.
    ///
    /// - Parameter id: The identifier of the Zikr.
    /// - Throws: An error if the retrieval fails.
    /// - Returns: An optional `Zikr` object. Nil if not found.
    func getZikr(_ id: Int) throws -> Zikr?
    
    /// Retrieves a Zikr that is recited before breaking a fast.
    func getZikrBeforeBreakingFast() -> Zikr?
    
    /// Retrieves all Adhkar from the database.
    ///
    /// - Throws: An error if the retrieval fails.
    /// - Returns: An array of `Zikr` objects.
    func getAllAdhkar() throws -> [Zikr]
    
    /// Retrieves Adhkar belonging to a specific category.
    ///
    /// - Parameter category: The category of Zikr to retrieve.
    /// - Throws: An error if the retrieval fails.
    /// - Returns: An array of `Zikr` objects within the given category.
    func getAdhkar(_ category: ZikrCategory) throws -> [Zikr]
    
    /// Searches for Adhkar matching a given query.
    ///
    /// This method performs a search based on a textual query and returns a list of Zikr objects that match the search criteria.
    ///
    /// - Parameter query: The text string to search for within the Adhkar.
    /// - Throws: An error if the search or retrieval fails.
    /// - Returns: An array of `Zikr` objects that match the query.
    func searchAdhkar(_ query: String) throws -> [Zikr]
    
    /// Retrieves the count of Adhkar within a specific category.
    ///
    /// - Parameter category: The category of Zikr for which to retrieve the count.
    /// - Throws: An error if the count cannot be retrieved.
    /// - Returns: The count of `Zikr` objects in the given category as an Int.
    func getAdhkarCount(_ category: ZikrCategory) throws -> Int
    
    /// Retrieves audio timing data for a specific audioId.
    ///
    /// - Parameter audioId: The identifier of the audio for which timings are requested.
    /// - Throws: An error if the retrieval fails.
    /// - Returns: An array of `AudioTiming` objects.
    func getAudioTimings(audioId: Int) throws -> [AudioTiming]
    
}
