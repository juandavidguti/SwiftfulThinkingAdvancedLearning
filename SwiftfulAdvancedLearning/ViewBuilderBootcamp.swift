//
//  ViewBuilderBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 26/10/25.
//

import SwiftUI

struct HeaderViewRegultar: View {
    
    let title: String
    let description: String?
    let iconName: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            if let description = description {
                Text(description)
                    .font(.callout)
            }
            if let iconName = iconName {
                Image(systemName: iconName)
            }
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}


struct HeaderViewGeneric<T: View> : View {
    
    let title: String
    let content: T
    
    init(title: String, @ViewBuilder content: () -> T) { // as soon as we initialize the view, instead of just passing content we make a function that passes content to put what we want.
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            content
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}


struct CustomHStack<Content: View> : View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content){
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
        }
    }
}

struct ViewBuilderBootcamp: View {
    var body: some View {
        VStack {
            HeaderViewRegultar(title: "new title", description: "hello", iconName: "heart.fill")
            HeaderViewRegultar(title: "another title", description: nil, iconName: "paperplane")
            
            HeaderViewGeneric(title: "Generic3", content: {
                HStack {
                    Text("Hellooooo")
                    Image(systemName: "bolt.fill")
                }
            })
            
            CustomHStack {
                Text("hi")
                Text("hi")
                Text("hi")
            }
            
            HStack {
                Text("hi")
                Text("hi")
                Text("hi")

            }
            
            Spacer()
        }
    }
}

struct LocalViewBuilder: View {
    
    enum ViewType {
        case one, two, three
    }
    
    let type: ViewType
    
    
    var body: some View {
        VStack{
            headerSection
        }
    }
    
   @ViewBuilder private var headerSection: some View {
       switch type {
           case .one:
               viewOne
           case .two:
               viewTwo
           case .three:
               viewThree
       }
    }
    
    private var viewOne: some View {
        Text("1")
    }
    
    private var viewTwo: some View {
        VStack {
            Text("twoo")
            Image(systemName: "heart.fill")
        }
    }
    
    private var viewThree: some View {
        Image(systemName: "heart.fill")

    }
}

#Preview {
    LocalViewBuilder(type: .one)
}
