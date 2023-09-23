//
//  ItemEditView.swift
//  ToDo lList
//
//  Created by Akhmed on 22.09.23.
//

import SwiftUI

struct ItemEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var item: Item



    @State private var title: String = ""
    @State private var details: String = ""

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Task title", text: $title)
            }
            Section(header: Text("Details")) {
                TextEditor(text: $details)
            }
        }
        .onAppear {
            self.title = self.item.title ?? ""
            self.details = self.item.details ?? ""
        }
        .navigationBarTitle("Edit Task", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            saveChanges()
        })
    }

    func saveChanges() {
        item.title = title
        item.details = details

        do {
            try managedObjectContext.save()
            self.presentationMode.wrappedValue.dismiss()  // Эта строка закрывает экран
        } catch {
            print("Error saving changes: \(error)")
        }
    }
}

//struct ItemEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemEditView()
//    }
//}
