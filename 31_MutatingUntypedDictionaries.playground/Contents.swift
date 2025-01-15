var dict: [String: Any] = [
    "countries": [
        "japan": [
            "capital": "tokyo"
        ]
    ]
]

((dict["countries"] as? [String: Any])?["japan"] as? [String: Any])?["capital"]

extension Dictionary {

    subscript(jsonDict key: Key) -> [String: Any]? {
        get {
            self[key] as? [String: Any]
        }
        set {
            self[key] = newValue as? Value
        }
    }

    subscript(string key: Key) -> String? {
        get {
            self[key] as? String
        }
        set {
            self[key] = newValue as? Value
        }
    }
}

dict[jsonDict: "countries"]?[jsonDict: "japan"]?["capital"] = "berlin"
dict[jsonDict: "countries"]?[jsonDict: "japan"]?[string: "capital"]?.append("!")
dict
