//
//  PickerGroup.swift
//  PickerGroup
//
//  Created by nori on 2021/09/04.
//

import SwiftUI

public struct PickerGroup<Label, Content> {

    var label: Label

    var components: [Component]

    var content: Content
}

#if os(iOS)
extension PickerGroup: UIViewRepresentable {

    public typealias UIViewType = UIPickerView

    public func makeCoordinator() -> Coordinator { Coordinator(self) }

    public func makeUIView(context: Context) -> UIPickerView {
        let picker: UIPickerView = UIPickerView()
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        picker.setContentHuggingPriority(.defaultLow, for: .horizontal)
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return picker
    }

    public func updateUIView(_ uiView: UIPickerView, context: Context) {

    }

    public class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

        var parent: PickerGroup

        init(_ parent: PickerGroup) {
            self.parent = parent
        }

        public func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return parent.components.count
        }

        public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.components[component].contents.count
        }

        public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = parent.components[component].contents[row]
            return UIHostingController(rootView: view).view
        }

        public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.components[component].didSelectRowHandler(row)
        }
    }
}
#endif

#if os(macOS)
extension PickerGroup: View where Label: View, Content: View {

    public var body: some View {
        HStack {
            label
            VStack {
                content
            }
        }
    }
}
#endif

extension PickerGroup {
    struct Component {
        var contents: [AnyView]
        var didSelectRowHandler: (Int) -> Void
    }
}

public struct PickerComponent<SelectionValue, Content> {

    var selection: Binding<SelectionValue>!

    var content: Content

    var views: [AnyView] = []

    var didSelectRowHandler: (Int) -> Void
}

#if os(iOS)
extension PickerComponent: View {

    public var body: Never { fatalError() }

    public typealias Body = Never
}
#endif

#if os(macOS)
extension PickerComponent: View where SelectionValue: Hashable, Content: View {

    public init(selection: Binding<SelectionValue>, @ViewBuilder content: @escaping () -> Content) {
        let content = content()
        self.selection = selection
        self.content = content
        self.views = [AnyView(content)]
        self.didSelectRowHandler = { _ in }
    }

    public var body: some View {
        if selection == nil {
            EmptyView()
        } else {
            Picker(selection: selection, content: {
                content
            }, label: {
                EmptyView()
            })
        }
    }
}

extension PickerComponent where SelectionValue == Never, Content: View {

    public init(@ViewBuilder content: @escaping () -> Content) {
        let content = content()
        self.content = content
        self.views = [AnyView(content)]
        self.didSelectRowHandler = { _ in }
    }
}

#endif

#if os(iOS)
extension PickerComponent {
    public init(@ViewBuilder content: @escaping () -> Content) where Content: View, SelectionValue == Never {
        let content = content()
        self.content = content
        self.views = [AnyView(content)]
        self.didSelectRowHandler = { _ in }
    }
}
#endif

extension PickerComponent {
    public init<Data, ID, InContent>(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) where Content == ForEach<Data, ID, InContent>, Data: RandomAccessCollection, ID: Hashable, InContent: View, Data.Element == SelectionValue {
        self.selection = selection
        let forEach = content()
        self.content = forEach
        self.views = forEach.data.map { AnyView(forEach.content($0)) }
        self.didSelectRowHandler = { row in
            selection.wrappedValue = Array(forEach.data)[row]
        }
    }
}

extension PickerGroup where Label: View {
    public init<S0, C0, S1, C1>(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) where Content == TupleView<(PickerComponent<S0, C0>, PickerComponent<S1, C1>)> {
        let content = content()
        self.content = content
        self.label = label()
        let value = content.value
        let c0 = Component(contents: value.0.views, didSelectRowHandler: value.0.didSelectRowHandler)
        let c1 = Component(contents: value.1.views, didSelectRowHandler: value.1.didSelectRowHandler)
        self.components = [c0, c1]
    }

    public init<S0, C0, S1, C1, S2, C2>(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) where Content == TupleView<(PickerComponent<S0, C0>, PickerComponent<S1, C1>, PickerComponent<S2, C2>)> {
        let content = content()
        self.content = content
        self.label = label()
        let value = content.value
        let c0 = Component(contents: value.0.views, didSelectRowHandler: value.0.didSelectRowHandler)
        let c1 = Component(contents: value.1.views, didSelectRowHandler: value.1.didSelectRowHandler)
        let c2 = Component(contents: value.2.views, didSelectRowHandler: value.2.didSelectRowHandler)
        self.components = [c0, c1, c2]
    }
}

extension PickerGroup where Label == Text {
    public init<S0, C0, S1, C1>(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) where Content == TupleView<(PickerComponent<S0, C0>, PickerComponent<S1, C1>)> {
        let content = content()
        self.content = content
        self.label = Text(titleKey)
        let value = content.value
        let c0 = Component(contents: value.0.views, didSelectRowHandler: value.0.didSelectRowHandler)
        let c1 = Component(contents: value.1.views, didSelectRowHandler: value.1.didSelectRowHandler)
        self.components = [c0, c1]
    }

    public init<S0, C0, S1, C1, S2, C2>(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) where Content == TupleView<(PickerComponent<S0, C0>, PickerComponent<S1, C1>, PickerComponent<S2, C2>)> {
        let content = content()
        self.content = content
        self.label = Text(titleKey)
        let value = content.value
        let c0 = Component(contents: value.0.views, didSelectRowHandler: value.0.didSelectRowHandler)
        let c1 = Component(contents: value.1.views, didSelectRowHandler: value.1.didSelectRowHandler)
        let c2 = Component(contents: value.2.views, didSelectRowHandler: value.2.didSelectRowHandler)
        self.components = [c0, c1, c2]
    }

    public init<S, S0, C0, S1, C1>(_ title: S, @ViewBuilder content: () -> Content) where Content == TupleView<(PickerComponent<S0, C0>, PickerComponent<S1, C1>)>, S: StringProtocol {
        let content = content()
        self.content = content
        self.label = Text(title)
        let value = content.value
        let c0 = Component(contents: value.0.views, didSelectRowHandler: value.0.didSelectRowHandler)
        let c1 = Component(contents: value.1.views, didSelectRowHandler: value.1.didSelectRowHandler)
        self.components = [c0, c1]
    }

    public init<S, S0, C0, S1, C1, S2, C2>(_ title: S, @ViewBuilder content: () -> Content) where Content == TupleView<(PickerComponent<S0, C0>, PickerComponent<S1, C1>, PickerComponent<S2, C2>)>, S: StringProtocol {
        let content = content()
        self.content = content
        self.label = Text(title)
        let value = content.value
        let c0 = Component(contents: value.0.views, didSelectRowHandler: value.0.didSelectRowHandler)
        let c1 = Component(contents: value.1.views, didSelectRowHandler: value.1.didSelectRowHandler)
        let c2 = Component(contents: value.2.views, didSelectRowHandler: value.2.didSelectRowHandler)
        self.components = [c0, c1, c2]
    }
}

struct SwiftUIView_Previews: PreviewProvider {

    struct ContentView: View {

        @State var selection: String

        var body: some View {
            Picker("", selection: .constant("")) {
                
            }
        }
    }

    static var previews: some View {
        VStack {
            PickerGroup("Label") {
                PickerComponent(selection: .constant(0)) {
                    ForEach(0..<10) { index in
                        Text("\(index)")
                    }
                }
                PickerComponent {
                    Text("text")
                }
            }
            PickerGroup("Label") {
                PickerComponent(selection: .constant(0)) {
                    ForEach(0..<10) { index in
                        Text("\(index)")
                    }
                }
                PickerComponent(selection: .constant(0)) {
                    ForEach(0..<10) { index in
                        Text("\(index)")
                    }
                }
            }
            PickerGroup("Label") {
                PickerComponent(selection: .constant(0)) {
                    ForEach(0..<10) { index in
                        Text("\(index)")
                    }
                }
                PickerComponent(selection: .constant(0)) {
                    ForEach(0..<10) { index in
                        Text("\(index)")
                    }
                }
                PickerComponent(selection: .constant(0)) {
                    ForEach(0..<10) { index in
                        Text("\(index)")
                    }
                }
            }
        }
    }
}
