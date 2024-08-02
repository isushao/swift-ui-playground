//
//  NavigationStackDemo2.swift
//  Playground
//
//  Created by roc on 2024/8/2.
//

import SwiftUI

struct NavigationStackDemo2: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("SubView1", value: Target.subView1) // 只声明关联的状态值
                NavigationLink("SubView2", value: Target.subView2)
                NavigationLink("SubView3", value: 3)
                NavigationLink("SubView4", value: 4)
            }
            .navigationDestination(for: Target.self){ target in // 对同一类型进行统一处理，返回目标视图
                switch target {
                    case .subView1:
                        Text("subview1")
                    case .subView2:
                    Text("subview2")
                }
            }
            .navigationDestination(for: Int.self) { target in  // 为不同的类型添加多个处理模块
                switch target {
                case 3:
                    Text("subview3")
                default:
                    Text("subview4")
                }
            }
        }
    }

    enum Target {
        case subView1,subView2
    }
}

#Preview {
    NavigationStackDemo2()
}
