//
//  ContentView.swift
//  Digital Library
//
//  Created by Baylor Harrison on 2/18/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bookInfoDictionary:infoDictionary = infoDictionary()
    
    @State var title:String
    @State var author:String
    @State var genre:String
    @State var price:String
    @State var deleteTitle:String
    @State var displayIndex:Int = 0
    
    var body: some View {
        NavigationView{
            VStack{
                NaviView(titleN:$title, authorN:$author, genreN:$genre, priceN:$price, deleteTitleN:$deleteTitle, bModel:bookInfoDictionary)
                DisplayView(dTitle:$title, dAuthor:$author, dGenre:$genre, dPrice:$price, currentIndex:$displayIndex, bModel:bookInfoDictionary)
                ToolView(sTitle:$title, sAuthor:$author, sGenre:$genre, sPrice:$price, currentIndex:$displayIndex, bModel:bookInfoDictionary)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("My Book List")
        }
    }
}

struct NaviView: View {
    @Binding var titleN:String
    @Binding var authorN:String
    @Binding var genreN:String
    @Binding var priceN:String
    @Binding var deleteTitleN:String
    @ObservedObject var bModel:infoDictionary
    
    @State var showingAddAlert = false
    @State var showingDeleteAlert = false
    
    var body: some View {
        Text("")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        showingAddAlert = true
                    },
                    label: {
                        Image(systemName: "plus.app")
                    })
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        showingDeleteAlert = true
                    },
                    label:{
                        Image(systemName: "trash")
                    })
                }
            }.alert("Add Book", isPresented: $showingAddAlert, actions: {
                TextField("Title", text:$titleN)
                TextField("Author", text:$authorN)
                TextField("Genre", text:$genreN)
                TextField("Price ($)", text:$priceN)
                
                Button("Add Book", action: {
                    bModel.add(titleN, authorN, genreN, Double(priceN) ?? 0)
                })
                Button("Cancel", role: .cancel, action: {
                    showingAddAlert = false;
                })
            }, message: {
                Text("Please enter the book details below")
            })
            .alert("Delete Book", isPresented: $showingDeleteAlert, actions: {
                TextField("Title", text:$deleteTitleN)
                Button("Delete Book", action: {
                    bModel.delete(t: deleteTitleN)
                })
                Button("Cancel", role: .cancel, action: {
                    showingDeleteAlert = false;
                })
            }, message: {
                Text("Please enter the book title")
            })
            
    }
}

struct ToolView: View {
    @Binding var sTitle:String
    @Binding var sAuthor:String
    @Binding var sGenre:String
    @Binding var sPrice:String
    @Binding var currentIndex:Int
    @ObservedObject var bModel:infoDictionary
    
    @State var showingBookAlert = false
    @State var showingSearchResult = false
    @State var showingResultNotFound = false
    @State var showingEditAlert = true
    
    var body: some View {
        Text("")
            .toolbar{
                ToolbarItem(placement: .bottomBar){
                    Button(action: {
                        showingBookAlert = true
                    }, label: {
                        Image(systemName: "magnifyingglass")
                    })
                }
                ToolbarItem(placement: .bottomBar){
                    Button(action: {
                        showingEditAlert = true
                    }, label: {
                        Text("Edit")
                    })
                }
                ToolbarItemGroup(placement: .bottomBar){
                    Spacer()
                    Spacer()
                    Spacer()
                    Button(action:
                    {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }, label: {
                        Text("Prev")
                    })
                    Spacer()
                    Button(action:
                    {
                        if currentIndex < bModel.getCount() - 1 {
                            currentIndex += 1
                        }
                    }, label: {
                        Text("Next")
                    })
                    Spacer()
                }
            }
            .alert("Book Search", isPresented: $showingBookAlert, actions: {
                TextField("Title", text:$sTitle)
                
                Button("Search", action: {
                    let b = bModel.search(t: sTitle)
                    if let x = b {
                        sAuthor = x.author!
                        sGenre = x.genre!
                        sPrice = String(x.price!)
                        
                        showingSearchResult = true
                    }
                    else{
                        showingResultNotFound = true
                    }
                })
                Button("Cancel", role: .cancel, action: {
                    showingBookAlert = false
                })
            }, message: {
                Text("Please enter book title")
            })
            .alert("Search Result", isPresented: $showingSearchResult, actions: {
                Text("\(sTitle) by \(sAuthor)")
                Text("Genre: \(sGenre)")
                Text("Price: \(sPrice)")
                
                Button("Close", action: {
                    showingSearchResult = false;
                })
            })
            .alert("No book with that title was found", isPresented: $showingResultNotFound, actions: {})
            .alert("Edit", isPresented: $showingEditAlert, actions: {
                TextField("Title", text: $sTitle)
                TextField("Author", text: $sAuthor)
                TextField("Genre", text: $sGenre)
                TextField("Price ($)", text: $sPrice)
                
                Button("Confirm", action: {
                    bModel.delete(t:sTitle)
                    bModel.add(sTitle, sAuthor, sGenre, Double(sPrice)!)
                    showingEditAlert = false
                })
                Button("Cancel", role: .cancel, action: {
                    showingEditAlert = false
                })
            })
    }
}

struct DisplayView: View {
    @Binding var dTitle:String
    @Binding var dAuthor:String
    @Binding var dGenre:String
    @Binding var dPrice:String
    @Binding var currentIndex:Int
    @ObservedObject var bModel:infoDictionary
        
    var body: some View {
        if let books = Array(bModel.infoRepository.values) as? [bookRecord], !books.isEmpty {
            let currentBook = books[currentIndex]
            VStack {
                Text("\(currentBook.title ?? "") by \(currentBook.author ?? "")")
                Text("Genre: \(currentBook.genre ?? "")")
                Text(String(format: "$%.2f", currentBook.price ?? 0))
            }
        } else {
            Text("No books found")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(title: "", author: "", genre: "", price: "", deleteTitle: "")
    }
}
