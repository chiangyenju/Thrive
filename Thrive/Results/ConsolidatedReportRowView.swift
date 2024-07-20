import SwiftUI

struct ConsolidatedReportRowView: View {
    var report: ConsolidatedReport

    var body: some View {
        VStack(alignment: .leading) {
            Text(report.content)
                .font(Font.custom("LexendDeca-Regular", size: 16))
                .padding(.vertical, 8)
        }
    }
}
