
# PickerGroup

Multi-picker for iOS and Mac available in Swift UI

![スクリーンショット 2021-09-05 17 04 11](https://user-images.githubusercontent.com/11146538/132120011-975bc1ad-7210-4e36-aeed-6fa1c24053e9.png)

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
