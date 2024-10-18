import SwiftUI

struct EditItemView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var todoItemDescription: String = ""
    var item: TodoItemEntity

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Item")) {
                    TextField("Item details", text: $todoItemDescription)
                        .textInputAutocapitalization(.never)
                        .accessibility(identifier: "itemDetailsTextField")
                }
                Section {
                    HStack {
                        Spacer()
                        Button("OK") {
                            withAnimation {
                                viewModel.receive(event: .updateItem(item: item, title: todoItemDescription))
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.horizontal, 20)
                        .accessibility(identifier: "okButton")
                        Spacer()
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Cancel", role: .cancel) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.horizontal, 20)
                        .accessibility(identifier: "cancelButton")
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Edit Todo Item", displayMode: .inline)
            .onAppear {
                todoItemDescription = item.title ?? ""
            }
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataPreviewMock().persistentContainer.viewContext
        let viewModel = ViewModel(service: MockPreviewService(), viewContext: context)
        
        let exampleItem = TodoItemEntity(context: context)
        exampleItem.title = "Sample Todo Item"
        exampleItem.completed = false
        exampleItem.userId = 3
        exampleItem.id = 1

        return EditItemView(item: exampleItem)
            .environmentObject(viewModel)
    }
}
