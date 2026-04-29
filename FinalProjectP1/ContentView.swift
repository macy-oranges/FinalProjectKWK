//
//  ContentView.swift
//  to-do list
//
//  Created by Scholar on 7/30/24.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var showNewTask = false
    @State private var deleteAllTask = false
    @State private var showImagePopUp = false
    let imageNames = [Image("duck1"), Image("duck2"), Image("duck3")]
    //links views initially; second view is not showing
    
    @Query var toDos: [ToDoItem]
    // helps the code read our data
    
    
    @Environment(\.modelContext) var modelContext
    
      @State var percent: CGFloat = 0
//    @State private var checkDone = "⬜️"
    
    var body: some View {
        ZStack {
            Color(red: 1, green: 1, blue: 0.85)
                .ignoresSafeArea()
            
        VStack {
            
            VStack (spacing: 10) {
                Text("\(Int(percent))%")
                    .font(.system(size: 40, weight:.bold))
                ProgressBar(width: 300, height: 20, percent: percent, color1: Color(.green), color2: Color(.blue)
                )
                .animation(.spring())
                
                
            }
            
            HStack {
                Text("To do List")
                    .fontWeight(.black)
                    .font(.system(size: 40))
                Spacer() //moves todolist to left of screen
                
                
                
                Button {
                    withAnimation {
                        self.showNewTask = true
                        //self = "you're gonna do this on this field"
                        
                    }
                    
                } label: {
                    Text("+")
                }
                .fontWeight(.black)
                .foregroundColor(.green)
                .font(.system(size: 40))
                
                
                
                Button {
                    withAnimation {
                        
                        deleteAllToDos()
                        self.percent = 0
                    }
                    
                } label: {
                    Image(systemName: "trash")
                }
                .fontWeight(.black)
                .foregroundColor(.red)
                .font(.system(size: 20))
                
            }
            .padding()
            Spacer() //moves it up since Vstack
            
            List {
                ForEach(toDos){
                    toDoItem in
                    HStack{
                        Button(action: {
                            if self.percent >= 100.0 {
                                self.percent = 100.0
                                
                            } else {
                                self.percent += CGFloat(100/toDos.count)
                            }
                            //checkDone = "✅"
                            toDoItem.check = "✅"
                            
                        }, label: {
                            //                     Text(checkDone)
                            Text(toDoItem.check)
                        })
                        
                        .buttonStyle(.borderedProminent)
                        .tint(.white)
                        
                        Spacer()
                        
                        if toDoItem.isImportant == true {
                            Text("‼️ " + toDoItem.title)
                        }else{
                            Text(toDoItem.title)
                        }
                        
                        
                    }
                    
                }
                .onDelete(perform: deleteToDo)
                
                .listStyle(.plain)
                
            }
            
            if self.percent == 100.0 {
                Button("GET UR DUCKING PRIZE"){
                completeTask()
                }
                .fontWeight(.bold)
                .padding(50)
                .sheet(isPresented: $showImagePopUp) {
                    popUp(image: showRandomImage(), isPresented: $showImagePopUp)
                }
            }
            
            if showNewTask {
                NewToDoView(toDoItem: ToDoItem(title: "", isImportant: false, checkedDone: false, check: "⬜️"), showNewTask: $showNewTask)
                // this code calls new to-do task view
            }
            
          
                
            
        }
            
        .background(Rectangle() .foregroundColor(Color(hue: 0.052, saturation: 0.518, brightness: 0.999, opacity: 0.778)))
        .cornerRadius(15.0)
        . padding()
            
            //this is the red stuff around the to do list

    }
        }
    func deleteToDo(at offsets: IndexSet){
        for offset in offsets {
            let toDoItem = toDos[offset]
            // this is for individual task
            modelContext.delete(toDoItem)
        }
        
    }
    func showRandomImage() -> Image{
            let randomIndex = Int.random(in: 0..<imageNames.count)
            let imageName = imageNames[randomIndex]
        return imageName
        }
    
    func deleteAllToDos() {
        for toDoItem in toDos {
            modelContext.delete(toDoItem)
        }
    }
    func completeTask() {
        // Perform your task here
        showImagePopUp = true
    }
}


#Preview {
    ContentView()
}

