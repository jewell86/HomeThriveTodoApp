import SwiftUI

struct AddItemView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @State private var todoItemDescription: String = ""
    @State private var isPresentingAddItemView = false

    var body: some View {
        Button(action: {
            isPresentingAddItemView.toggle()
        }) {
            Image(systemName: "plus")
        }
        .accessibility(identifier: "addButton")
        .alert("Add Todo Item", isPresented: $isPresentingAddItemView) {
            TextField("Item details", text: $todoItemDescription)
                .accessibility(identifier: "itemDetailsTextField")
                .textInputAutocapitalization(.never)
            Button("OK", action: addItem)
                .accessibility(identifier: "okButton")
            Button("Cancel", role: .cancel) { }
                .accessibility(identifier: "cancelButton")
        }
    }

    private func addItem() {
        withAnimation {
            viewModel.receive(event: .addItem(title: todoItemDescription))
            todoItemDescription = ""
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataPreviewMock().persistentContainer.viewContext
        let viewModel = ViewModel(service: MockPreviewService(), viewContext: context)
        
        AddItemView()
            .environmentObject(viewModel)
    }
}
