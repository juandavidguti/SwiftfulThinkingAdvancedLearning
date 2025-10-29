//
//  CustomTabBarView.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 27/10/25.
//

import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @State var localSelection: TabBarItem
    
    @Namespace private var namespace
    
    var body: some View {
        tabBarVersion2
            .onChange(of: selection) { oldValue, newValue in
                withAnimation(.easeInOut) {
                    localSelection = newValue
                }
            }
    }
}

#Preview {
    
    let tabs: [TabBarItem] = [
        .home, .favorites, .profile
    ]
    
    VStack {
        Spacer()
        CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!)
        
    }
}


extension CustomTabBarView {
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold,design: .rounded))
        }
        .foregroundStyle(localSelection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background((localSelection == tab ? tab.color : Color.clear).opacity(0.3))
        .cornerRadius(10)
    }
    
    private var tabBarVersion1: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                    tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white)
    }
    
    private func switchToTab(tab: TabBarItem) {
            selection = tab
    }
}


extension CustomTabBarView {
    private func tabView2(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold,design: .rounded))
        }
        .foregroundStyle(localSelection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack(content: {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            })
            )
    }
    
    private var tabBarVersion2: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                    tabView2(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}
