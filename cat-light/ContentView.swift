//
//  ContentView.swift
//  cat-light
//
//  Created by wukong on 2025/4/3.
//

import SwiftUI

// 定义场景项目的数据结构
struct SceneItem: Identifiable {
    let id = UUID()
    let name: String        // 场景名称
    let icon: String        // 场景图标
    let description: String // 场景描述
}

struct ContentView: View {
    // 状态属性
    @State private var brightness: Double = 0.5    // 亮度值
    @State private var saturation: Double = 1.0    // 饱和度值
    @State private var hue: Double = 0.0          // 色调值
    @State private var selectedScene: String = "自然光" // 当前选中的场景
    @State private var isPanelVisible: Bool = true    // 控制面板显示状态
    @State private var dragOffset: CGFloat = 0       // 拖动偏移量
    
    // 预定义场景列表
    let scenes = [
        SceneItem(name: "自然光", icon: "sun.max", description: "自然舒适的光线"),
        SceneItem(name: "暖光", icon: "sunset", description: "温暖橙黄色调"),
        SceneItem(name: "冷光", icon: "moon", description: "清爽蓝色光线"),
        SceneItem(name: "柔和光", icon: "cloud.sun", description: "柔和米色光线"),
        SceneItem(name: "少女感", icon: "heart", description: "温暖粉嫩色调"),
        SceneItem(name: "磨皮感", icon: "wand.and.stars", description: "柔和自然光线"),
        SceneItem(name: "冷白皮", icon: "snowflake", description: "清透冷色调"),
        SceneItem(name: "网感紫", icon: "sparkles", description: "时尚紫色光线"),
        SceneItem(name: "DeepSeek蓝", icon: "rays", description: "科技蓝色光线")
    ]
    
    var body: some View {
        ZStack {
            // 色卡显示区域 - 点击可切换控制面板显示状态
            Rectangle()
                .fill(Color(hue: hue, saturation: saturation, brightness: brightness))
                .ignoresSafeArea()
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = gesture.translation.width
                        }
                        .onEnded { gesture in
                            let threshold: CGFloat = 50
                            if abs(dragOffset) > threshold {
                                if let currentIndex = scenes.firstIndex(where: { $0.name == selectedScene }) {
                                    var newIndex = currentIndex
                                    if dragOffset > 0 { // 向右滑动，切换到上一个场景
                                        newIndex = (currentIndex - 1 + scenes.count) % scenes.count
                                    } else { // 向左滑动，切换到下一个场景
                                        newIndex = (currentIndex + 1) % scenes.count
                                    }
                                    withAnimation(.easeInOut) {
                                        selectedScene = scenes[newIndex].name
                                        applyScene(scenes[newIndex].name)
                                    }
                                }
                            }
                            dragOffset = 0
                        }
                )
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isPanelVisible.toggle()
                    }
                }
            
            // 控制面板区域
            if isPanelVisible {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        VStack(spacing: 12) {
                            // 场景选择器滚动视图
                            ScrollView(showsIndicators: true) {
                                // 使用LazyVGrid实现网格布局
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80, maximum: 100))], spacing: 8) {
                                    // 遍历场景列表创建场景选择按钮
                                    ForEach(scenes) { scene in
                                        VStack(spacing: 4) {
                                            Image(systemName: scene.icon)
                                                .font(.system(size: 22))
                                                .foregroundColor(selectedScene == scene.name ? .white : .primary)
                                            Text(scene.name)
                                                .font(.system(size: 12, weight: .medium))
                                            Text(scene.description)
                                                .font(.system(size: 10))
                                                .foregroundColor(.secondary)
                                        }
                                        .frame(width: 80, height: 70)
                                        .padding(.vertical, 2)
                                        .background(selectedScene == scene.name ? Color.accentColor : Color.clear)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                        )
                                        .onTapGesture {
                                            withAnimation {
                                                selectedScene = scene.name
                                                applyScene(scene.name)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.trailing, 4) // 为滚动条预留空间
                            }
                            .frame(height: geometry.size.height * 0.25)
                            
                            // 光线参数调节控件组
                            VStack(spacing: 12) {
                                // 亮度调节滑块
                                HStack {
                                    Image(systemName: "sun.min")
                                        .foregroundColor(.secondary)
                                    Slider(value: $brightness, in: 0...1)
                                        .controlSize(.mini)
                                        .scaleEffect(0.8)
                                    Image(systemName: "sun.max")
                                        .foregroundColor(.secondary)
                                }
                                
                                // 饱和度调节滑块
                                HStack {
                                    Image(systemName: "drop")
                                        .foregroundColor(.secondary)
                                    Slider(value: $saturation, in: 0...1)
                                        .controlSize(.mini)
                                        .scaleEffect(0.8)
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(.secondary)
                                }
                                
                                // 色调调节滑块
                                HStack {
                                    Image(systemName: "circle.lefthalf.filled")
                                        .foregroundColor(.secondary)
                                    Slider(value: $hue, in: 0...1)
                                        .controlSize(.mini)
                                        .scaleEffect(0.8)
                                    Image(systemName: "circle.righthalf.filled")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .padding(8)
                        .frame(height: geometry.size.height * 0.5)
                    }
                }
            }
        }
    }
    
    // 应用预设场景的参数设置
    func applyScene(_ scene: String) {
        switch scene {
        case "自然光":
            brightness = 0.5
            saturation = 0.7
            hue = 0.1 // 略微偏暖的自然色调
        case "暖光":
            brightness = 0.6
            saturation = 0.8
            hue = 0.08 // 温暖的橙黄色调
        case "冷光":
            brightness = 0.5
            saturation = 0.6
            hue = 0.6 // 清爽的蓝色调
        case "柔和光":
            brightness = 0.4
            saturation = 0.5
            hue = 0.05 // 柔和的米色调
        case "少女感":
            brightness = 0.7
            saturation = 0.6
            hue = 0.95 // 温暖粉嫩色调
        case "磨皮感":
            brightness = 0.65
            saturation = 0.4
            hue = 0.08 // 柔和自然色调
        case "冷白皮":
            brightness = 0.75
            saturation = 0.3
            hue = 0.6 // 清透冷色调
        case "网感紫":
            brightness = 0.6
            saturation = 0.7
            hue = 0.8 // 时尚紫色调
        case "DeepSeek蓝":
            brightness = 0.55
            saturation = 0.75
            hue = 0.65 // 科技蓝色调
        default:
            break
        }
    }
}
