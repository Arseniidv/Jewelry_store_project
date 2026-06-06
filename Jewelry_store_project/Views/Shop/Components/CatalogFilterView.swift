import SwiftUI

struct CatalogFilterView: View {
    let collections: [String]
    @Binding var draft: CatalogFilter
    let onApply: () -> Void
    let onReset: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Sort by") {
                    Picker("Sort", selection: $draft.sort) {
                        ForEach(ProductSortOption.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(.inline)
                }

                Section("Categories") {
                    ForEach(ProductCategory.allCases) { category in
                        Toggle(category.displayName, isOn: categoryBinding(category))
                    }
                }

                Section("Collections") {
                    if collections.isEmpty {
                        Text("No collections available")
                            .foregroundStyle(AppTheme.secondaryText)
                    } else {
                        ForEach(collections, id: \.self) { collection in
                            Toggle(collection, isOn: collectionBinding(collection))
                        }
                    }
                }

                Section("Price range") {
                    TextField("Min price", value: $draft.minimumPrice, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Max price", value: $draft.maximumPrice, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .appScreenBackground()
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset", action: onReset)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply", action: onApply)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func categoryBinding(_ category: ProductCategory) -> Binding<Bool> {
        Binding(
            get: { draft.categories.contains(category) },
            set: { isOn in
                if isOn {
                    draft.categories.insert(category)
                } else {
                    draft.categories.remove(category)
                }
            }
        )
    }

    private func collectionBinding(_ collection: String) -> Binding<Bool> {
        Binding(
            get: { draft.collections.contains(collection) },
            set: { isOn in
                if isOn {
                    draft.collections.insert(collection)
                } else {
                    draft.collections.remove(collection)
                }
            }
        )
    }
}
