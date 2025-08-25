//
//  zzzzzzzz.swift
//  shoppingLists
//
//  Created by neodiyadin on 24.08.2025.
//

import SwiftUI

struct ShoppingList: Identifiable, Codable {
    let id: UUID
    var title: String
    var createdDate: Date
    var items: [ShoppingItem]
    
    var totalItems: Int {
        items.count
    }
    
    var completedItems: Int {
        items.filter { $0.isCompleted }.count
    }
    
    var dateString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter.localizedString(for: createdDate, relativeTo: Date())
    }
    
    var progressString: String {
        return "\(totalItems) items | \(completedItems) completed"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, createdDate, items
    }
    
    init(id: UUID = UUID(), title: String, createdDate: Date, items: [ShoppingItem]) {
        self.id = id
        self.title = title
        self.createdDate = createdDate
        self.items = items
    }
}

struct ShoppingItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ItemCategory
    var isCompleted: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, isCompleted
    }
    
    init(id: UUID = UUID(), name: String, category: ItemCategory, isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.category = category
        self.isCompleted = isCompleted
    }
}

enum ItemCategory: String, CaseIterable, Codable {
    case vegetables = "Vegetables"
    case grains = "Grains"
    case meat = "Meat & Proteins"
    case dairy = "Dairy"
    
    var color: Color {
        switch self {
        case .vegetables:
            return .green
        case .grains:
            return .brown
        case .meat:
            return .red
        case .dairy:
            return .orange
        }
    }
    
    var icon: String {
        switch self {
        case .vegetables:
            return "🥬"
        case .grains:
            return "🌾"
        case .meat:
            return "🥩"
        case .dairy:
            return "🥛"
        }
    }
    
    var suggestions: [String] {
        switch self {
        case .vegetables:
            return ["Apples", "Pears", "Bananas", "Oranges", "Carrots", "Broccoli", "Spinach", "Tomatoes", "Onions", "Potatoes", "Lettuce", "Bell Peppers"]
        case .grains:
            return ["Rice", "Pasta", "Bread", "Oats", "Quinoa", "Barley", "Wheat Flour", "Cereal", "Crackers", "Bagels"]
        case .meat:
            return ["Chicken Breast", "Ground Beef", "Salmon", "Eggs", "Turkey", "Pork Chops", "Tuna", "Shrimp", "Bacon", "Ham"]
        case .dairy:
            return ["Milk", "Cheese", "Yogurt", "Butter", "Cream", "Sour Cream", "Cottage Cheese", "Ice Cream", "Mozzarella", "Cheddar Cheese"]
        }
    }
}

class DataManager: ObservableObject {
    @Published var shoppingLists: [ShoppingList] = []
    private let userDefaults = UserDefaults.standard
    private let listsKey = "SavedShoppingLists"
    
    init() {
        loadLists()
    }
    
    func saveLists() {
        if let encoded = try? JSONEncoder().encode(shoppingLists) {
            userDefaults.set(encoded, forKey: listsKey)
        }
    }
    
    func loadLists() {
        if let data = userDefaults.data(forKey: listsKey),
           let decoded = try? JSONDecoder().decode([ShoppingList].self, from: data) {
            shoppingLists = decoded
        } else {
            shoppingLists = []
        }
    }
    
    func addList(_ list: ShoppingList) {
        shoppingLists.append(list)
        saveLists()
    }
    
    func updateList(_ updatedList: ShoppingList) {
        if let index = shoppingLists.firstIndex(where: { $0.id == updatedList.id }) {
            shoppingLists[index] = updatedList
            saveLists()
        }
    }
    
    func deleteList(_ list: ShoppingList) {
        shoppingLists.removeAll { $0.id == list.id }
        saveLists()
    }
}

struct ShoppingListView: View {
    @StateObject private var dataManager = DataManager()
    
    var body: some View {
        NavigationView {
            VStack {
                // New List Button
                NavigationLink(destination: NewListView { newList in
                    dataManager.addList(newList)
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Create New List")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(red: 0.4, green: 0.6, blue: 0.7))
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // List Items
                if dataManager.shoppingLists.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("You haven't created any lists yet")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Text("Tap the button above to create your first list")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 80)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(dataManager.shoppingLists) { list in
                                NavigationLink(destination: EditListView(
                                    list: binding(for: list),
                                    dataManager: dataManager
                                )) {
                                    ShoppingListItem(list: list)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .background(Color.white)
                                .cornerRadius(12)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        dataManager.deleteList(list)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("My Shopping Lists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Burada istediğin aksiyonu yapabilirsin
                        print("Left button tapped")
                    }) {
                        Image(systemName: "chevron.left") // ok ikonu
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            }

        }
    }
    
    private func binding(for list: ShoppingList) -> Binding<ShoppingList> {
        guard let index = dataManager.shoppingLists.firstIndex(where: { $0.id == list.id }) else {
            fatalError("List not found")
        }
        return $dataManager.shoppingLists[index]
    }
}

struct ShoppingListItem: View {
    let list: ShoppingList
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(list.title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(list.dateString)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Text(list.progressString)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

struct NewListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var listName = ""
    @State private var selectedCategory: ItemCategory = .vegetables
    @State private var items: [ShoppingItem] = []
    @State private var newItemName = ""
    let onSave: (ShoppingList) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack {
                    // List Name
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("List Name")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        TextField("Shopping List", text: $listName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Select Item
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Select Category")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(ItemCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        
                        // Custom Item Input
                        HStack {
                            TextField("Enter custom item name", text: $newItemName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: addCustomItem) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color(red: 0.4, green: 0.6, blue: 0.7))
                                    .clipShape(Circle())
                            }
                            .disabled(newItemName.isEmpty)
                        }
                        .padding(.top, 8)
                        
                        // Suggestions
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Suggestions")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(availableSuggestions(), id: \.self) { suggestion in
                                    Button(action: {
                                        addSuggestion(suggestion)
                                    }) {
                                        Text(suggestion)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(selectedCategory.color)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(selectedCategory.color.opacity(0.1))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .stroke(selectedCategory.color.opacity(0.3), lineWidth: 1)
                                                    )
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.top, 12)
                        
                        // Current Items
                        if !items.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Items in List")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .padding(.top, 12)
                                
                                LazyVStack(alignment: .leading, spacing: 8) {
                                    ForEach(items) { item in
                                        HStack {
                                            Text(item.category.icon)
                                            Text(item.name)
                                                .font(.system(size: 14))
                                            Spacer()
                                            Button(action: {
                                                removeItem(item)
                                            }) {
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.red)
                                                    .font(.system(size: 12))
                                            }
                                        }
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.1))
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
            
            // Fixed Create Button at bottom
            Button(action: saveList) {
                Text("Create List")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(red: 0.4, green: 0.6, blue: 0.7))
                    )
            }
            .disabled(listName.isEmpty || items.isEmpty)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .background(Color(UIColor.systemGroupedBackground))
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Create New List")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func availableSuggestions() -> [String] {
        let existingItemNames = Set(items.map { $0.name.lowercased() })
        return selectedCategory.suggestions.filter { !existingItemNames.contains($0.lowercased()) }
    }
    
    private func addCustomItem() {
        let trimmedName = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        // Check if item already exists
        let existingItemNames = items.map { $0.name.lowercased() }
        if !existingItemNames.contains(trimmedName.lowercased()) {
            let newItem = ShoppingItem(name: trimmedName, category: selectedCategory)
            items.insert(newItem, at: 0) // Insert at the beginning
        }
        newItemName = ""
    }
    
    private func addSuggestion(_ suggestion: String) {
        let newItem = ShoppingItem(name: suggestion, category: selectedCategory)
        items.insert(newItem, at: 0) // Insert at the beginning
    }
    
    private func removeItem(_ item: ShoppingItem) {
        items.removeAll { $0.id == item.id }
    }
    
    private func saveList() {
        let newList = ShoppingList(
            title: listName,
            createdDate: Date(),
            items: items
        )
        onSave(newList)
        presentationMode.wrappedValue.dismiss()
    }
}

struct CategoryButton: View {
    let category: ItemCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(category.icon)
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? category.color.opacity(0.2) : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? category.color : Color.clear, lineWidth: 2)
                    )
            )
            .foregroundColor(isSelected ? category.color : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditListView: View {
    @Binding var list: ShoppingList
    @ObservedObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddItem = false
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(list.items.indices, id: \.self) { index in
                    ListItemRow(item: $list.items[index], dataManager: dataManager)
                }
                .onDelete { indexSet in
                    list.items.remove(atOffsets: indexSet)
                    dataManager.saveLists()
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            Button(action: {
                showingAddItem = true
            }) {
                Text("Add Item")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(red: 0.4, green: 0.6, blue: 0.7))
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .navigationTitle(list.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddItem) {
            AddItemView(existingItems: list.items) { newItem in
                list.items.insert(newItem, at: 0) // Insert at the beginning
                dataManager.saveLists()
            }
        }
    }
}

struct ListItemRow: View {
    @Binding var item: ShoppingItem
    let dataManager: DataManager
    
    var body: some View {
        HStack(spacing: 12) {
            Text(item.name)
                .font(.system(size: 16))
                .foregroundColor(item.isCompleted ? Color(red: 0.4, green: 0.6, blue: 0.7) : .primary)
                .strikethrough(item.isCompleted)
            
            Spacer()
            
            Button(action: {
                item.isCompleted.toggle()
                dataManager.saveLists()
            }) {
                Image(systemName: item.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(item.isCompleted ? Color(red: 0.4, green: 0.6, blue: 0.7) : .gray)
                    .font(.system(size: 20))
            }
        }
        .contentShape(Rectangle())
    }
}

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var itemName = ""
    @State private var selectedCategory: ItemCategory = .vegetables
    let existingItems: [ShoppingItem]
    let onSave: (ShoppingItem) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Item Name")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        TextField("Enter item name", text: $itemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Select Category")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(ItemCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        
                        // Suggestions
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Suggestions")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                                .padding(.top, 12)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(availableSuggestions(), id: \.self) { suggestion in
                                    Button(action: {
                                        itemName = suggestion
                                    }) {
                                        Text(suggestion)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(selectedCategory.color)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(selectedCategory.color.opacity(0.1))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .stroke(selectedCategory.color.opacity(0.3), lineWidth: 1)
                                                    )
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Button(action: saveItem) {
                        Text("Add")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(red: 0.4, green: 0.6, blue: 0.7))
                            )
                    }
                    .disabled(itemName.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func availableSuggestions() -> [String] {
        let existingItemNames = Set(existingItems.map { $0.name.lowercased() })
        return selectedCategory.suggestions.filter { !existingItemNames.contains($0.lowercased()) }
    }
    
    private func saveItem() {
        let trimmedName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        let newItem = ShoppingItem(name: trimmedName, category: selectedCategory)
        onSave(newItem)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    ShoppingListView()
}


