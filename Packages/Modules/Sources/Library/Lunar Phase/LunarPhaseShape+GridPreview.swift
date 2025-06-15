import SwiftUI

@available(iOS 16.0, *)
#Preview {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    let imageSize: CGFloat = 70
    
    var moonPhaseDates: [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (-30 ... 30).map { day in
            calendar.date(byAdding: .day, value: day, to: today) ?? today
        }
    }
    
    ScrollView {
        let today = Calendar.current.startOfDay(for: Date())
        
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(moonPhaseDates, id: \.self) { date in
                let phaseInfo = LunarPhaseInfo(date)
                let isToday = Calendar.current.startOfDay(for: date) == today
                
                var phaseInfoText: String {
                    """
                    \(phaseInfo.phase.rawValue)
                    emoji: \(phaseInfo.emoji)
                    \(String(format: "%.2f", phaseInfo.illuminatedFraction))
                    \(String(format: "%.2f", LunarPhaseShape.normalizeProgress(phaseInfo.illuminatedFraction, isWaxing: phaseInfo.isWaxing)))
                    \(phaseInfo.isWaxing ? "waxing" : "waning")
                    """
                }
                
                VStack {
                    LunarPhaseView(info: phaseInfo)
                        .frame(width: imageSize, height: imageSize)
                                    
                    Text(phaseInfoText)
                        .font(.caption2)
                    
                    Spacer()
                }
                .background {
                    if isToday {
                        Color.blue.opacity(0.25)
                    }
                }
            }
        }
        .padding()
    }
    .scrollIndicators(.hidden)
}
