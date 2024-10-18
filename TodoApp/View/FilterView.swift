import SwiftUI

struct FilterView: View {
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        Picker("Filter", selection: $viewModel.currentFilter) {
            ForEach(FilterType.allCases, id: \.self) { filter in
                Text(filter.rawValue).tag(filter)
                    .accessibilityLabel(filter.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .accessibility(identifier: "filterPicker")
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel(service: MockPreviewService(), viewContext: CoreDataPreviewMock.shared.persistentContainer.viewContext)
        viewModel.currentFilter = .all
        
        return FilterView().environmentObject(viewModel)
    }
}
