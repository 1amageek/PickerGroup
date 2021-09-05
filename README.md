# PickerGroup

Multi-picker for iOS and Mac available in Swift UI


```swift
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
```
