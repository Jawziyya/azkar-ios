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
                    \(date.formatted(date: .abbreviated, time: .omitted))
                    \(phaseInfo.phase.titleRu)
                    \(String(format: "%.2f", phaseInfo.illuminatedFraction))
                    """
                }
                
                VStack {
                    LunarPhaseView(info: phaseInfo)
                        .frame(width: imageSize, height: imageSize)
                                    
                    Text(phaseInfoText)
                        .font(isToday ? .caption2.bold() : .caption2)
                        .underline(isToday, color: Color.blue)
                    
                    Spacer()
                }
                .foregroundStyle(isToday ? Color.blue : Color.primary)
            }
        }
        .padding()
    }
    .scrollIndicators(.hidden)
}
