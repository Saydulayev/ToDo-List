//
//  NewTaskView.swift
//  ToDo List
//
//  Created by Akhmed on 24.09.23.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var title: String = ""
    @State private var details: String = ""
    var onComplete: (String, String) -> Void = { _,_ in }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Task title", text: $title)
                }
                Section(header: Text("Details")) {
                    TextEditor(text: $details)
                }
            }
            .navigationBarTitle("New Task", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                self.onComplete("", "")
            }, trailing: Button("Save") {
                self.onComplete(self.title, self.details)
            })
        }
    }
}


struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
    }
}
