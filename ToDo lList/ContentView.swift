//
//  ContentView.swift
//  ToDo List
//
//  Created by Akhmed on 22.09.23.
//

import SwiftUI
import CoreData


struct ContentView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @State private var sortOrder: SortOrder = .date
    @State private var filterStatus: FilterStatus? = nil
    @State private var showingAddTaskSheet = false

    // MARK: - Enums
    enum SortOrder {
        case date, status
    }

    enum FilterStatus {
        case completed, notCompleted
    }
    
    // MARK: - Fetch Request
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        predicate: nil,
        animation: .default
    ) private var items: FetchedResults<Item>
    
    // MARK: - Computed Variables
    private var sortedAndFilteredItems: [Item] {
        var itemList = items.map { $0 }
        
        switch sortOrder {
        case .date:
            itemList.sort(by: { ($0.timestamp ?? Date()) < ($1.timestamp ?? Date()) })
        case .status:
            itemList.sort(by: { $0.isCompleted && !$1.isCompleted })
        }

        if let filter = filterStatus {
            itemList = itemList.filter {
                filter == .completed ? $0.isCompleted : !$0.isCompleted
            }
        }

        return itemList
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                itemList
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    sortingMenu
                }
                ToolbarItem {
                    filterMenu
                }
                ToolbarItem {
                    addButton
                }
            }
            .navigationTitle("To-Do List")
            .sheet(isPresented: $showingAddTaskSheet) {
                NewTaskView { title, details in
                    self.addItem(title: title, details: details)
                    self.showingAddTaskSheet = false
                }
                .environment(\.managedObjectContext, self.viewContext)
            }
        }
    }

    
    // MARK: - Item List
    private var itemList: some View {
        ForEach(sortedAndFilteredItems, id: \.itemUUID) { item in
            NavigationLink(destination: ItemEditView(item: item)) {
                itemRow(for: item)
            }
            .transition(.slide)
        }
        .onDelete(perform: deleteItems)
    }

    private func itemRow(for item: Item) -> some View {
        HStack {
            Text(item.title ?? "No title")
                .foregroundColor(colorForItem(item))
                .strikethrough(item.isCompleted, color: colorForItem(item))
                .overlay(strikethroughOverlay(for: item))
            Spacer()
            checkmarkButton(for: item)
        }
    }

    private func strikethroughOverlay(for item: Item) -> some View {
        Group {
            if item.isCompleted {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 2)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }

    private func checkmarkButton(for item: Item) -> some View {
        Button(action: { toggleCompletion(for: item) }) {
            if item.isCompleted {
                withAnimation(.easeInOut) {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                }
            } else {
                Image(systemName: "circle").foregroundColor(.gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .id(item.itemUUID)
    }
    
    
    // MARK: - View Components
    private var sortingMenu: some View {
        Menu {
            Button("Sort by Date", action: { sortOrder = .date })
            Button("Sort by Status", action: { sortOrder = .status })
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle")
        }
    }

    private var filterMenu: some View {
        Menu {
            Button("Show All", action: { filterStatus = nil })
            Button("Show Completed", action: { filterStatus = .completed })
            Button("Show Not Completed", action: { filterStatus = .notCompleted })
        } label: {
            Image(systemName: "line.horizontal.3.decrease.circle")
        }
    }

    private var addButton: some View {
        Button(action: {
            self.showingAddTaskSheet.toggle()
        }) {
            Label("Add Item", systemImage: "plus")
        }
    }

    
    // MARK: - Functions
    private func addItem(title: String, details: String) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.title = title
            newItem.details = details
            newItem.isCompleted = false
            newItem.itemUUID = UUID()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func toggleCompletion(for item: Item) {
        withAnimation(.easeInOut(duration: 0.5)) {
            item.isCompleted.toggle()
            do {
                try viewContext.save()
            } catch {
                print("Error toggling completion status: \(error)")
            }
        }
    }

    func colorForItem(_ item: Item) -> Color {
        if item.isCompleted {
            return Color.gray
        } else if let dueDate = item.dueDate, Calendar.current.isDateInTomorrow(dueDate) || Calendar.current.isDateInToday(dueDate) {
            return Color.red
        } else {
            return Color.green
        }
    }
}








private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()










struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        
    }
}

