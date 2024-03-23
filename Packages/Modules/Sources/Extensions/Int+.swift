import Foundation

extension Int {
    
    /// Converts the integer to a string with an abbreviated format.
    /// Formats numbers into 'K' for thousands and 'M' for millions with one decimal place precision.
    /// Examples: 1,000 becomes "1K", 1,000,000 becomes "1M".
    public func toAbbreviatedString() -> String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1 {
            return "\(round(million * 10) / 10)M"
        } else if thousand >= 1 {
            return "\(round(thousand * 10) / 10)K"
        } else {
            return "\(self)"
        }
    }
    
}
