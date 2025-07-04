import Foundation

let mockPersonJsonData: Data = """
  {
      "name": "John",
      "age": 30
  }
  """.data(using: .utf8)!

let invalidMockPersonJsonData: Data = """
  {
      "Name": "John",
      "Age": 30
  }
  """.data(using: .utf8)!

let mockImageData: Data = Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMB/3h58iQAAAAASUVORK5CYII=")!
