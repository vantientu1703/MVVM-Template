//
//  main.swift
//  InstallMVVMTemplate
//
//  Created by Juanpe Catalán on 17/02/2017.
//  Copyright © 2017 Juanpe Catalán. All rights reserved.
//

import Foundation

let templateName = "MVVM-Swift.xctemplate"

// Sử dụng user templates directory (không cần sudo)
// Nếu muốn dùng system templates, có thể thay đổi sang system path
func getDestinationPath() -> String {
  // Thử dùng user templates trước (không cần sudo)
  if let homeDir = ProcessInfo.processInfo.environment["HOME"] {
    let userTemplatesPath =
      "\(homeDir)/Library/Developer/Xcode/Templates/Project Templates/iOS/Application"
    return userTemplatesPath
  }
  // Fallback về system templates (cần sudo)
  return
    "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/Project Templates/iOS/Application"
}

func printInConsole(_ message: Any) {
  print("====================================")
  print("\(message)")
  print("====================================")
}

func moveTemplate() {

  let fileManager = FileManager.default
  let destinationPath = getDestinationPath()

  // Tìm đường dẫn tuyệt đối của template
  // Khi chạy với sudo, working directory có thể thay đổi, nên cần tìm đường dẫn tuyệt đối
  let currentDir = fileManager.currentDirectoryPath
  var sourcePath = "\(currentDir)/\(templateName)"

  // Nếu không tìm thấy ở thư mục hiện tại, thử tìm ở các vị trí khác
  if !fileManager.fileExists(atPath: sourcePath) {
    // Thử tìm trong HOME directory
    if let homeDir = ProcessInfo.processInfo.environment["HOME"] {
      let possiblePath =
        "\(homeDir)/Desktop/outsource-projects/MVVM-Template-Generator/\(templateName)"
      if fileManager.fileExists(atPath: possiblePath) {
        sourcePath = possiblePath
      }
    }
  }

  // Kiểm tra xem template có tồn tại không
  if !fileManager.fileExists(atPath: sourcePath) {
    printInConsole("❌  Error: Cannot find template '\(templateName)'")
    printInConsole("Current directory: \(currentDir)")
    printInConsole("Please run this script from the directory containing '\(templateName)'")
    printInConsole("Example: cd /path/to/MVVM-Template-Generator && swift install.swift")
    return
  }

  // Tạo destination directory nếu chưa tồn tại
  var isDirectory: ObjCBool = false
  if !fileManager.fileExists(atPath: destinationPath, isDirectory: &isDirectory)
    || !isDirectory.boolValue
  {
    do {
      try fileManager.createDirectory(
        atPath: destinationPath, withIntermediateDirectories: true, attributes: nil)
      printInConsole("📁  Created destination directory: \(destinationPath)")
    } catch {
      printInConsole("❌  Error: Cannot create destination directory: \(destinationPath)")
      printInConsole("Error details: \(error.localizedDescription)")
      return
    }
  }

  do {
    if !fileManager.fileExists(atPath: "\(destinationPath)/\(templateName)") {

      try fileManager.copyItem(atPath: sourcePath, toPath: "\(destinationPath)/\(templateName)")

      printInConsole("✅  Template installed succesfully 🎉. Enjoy it 🙂")

    } else {

      try _ = fileManager.replaceItemAt(
        URL(fileURLWithPath: "\(destinationPath)/\(templateName)"),
        withItemAt: URL(fileURLWithPath: sourcePath))

      printInConsole("✅  Template already exists. So has been replaced succesfully 🎉. Enjoy it 🙂")
    }
  } catch let error as NSError {
    let errorMessage = error.localizedFailureReason ?? error.localizedDescription
    printInConsole("❌  Ooops! Something went wrong 😡 : \(errorMessage)")
    printInConsole("Error code: \(error.code)")
    if error.code == 513 || error.code == 1 {
      printInConsole("💡  This is a permission error.")
      printInConsole("   The script is trying to install to: \(destinationPath)")
      if destinationPath.contains("/Applications/Xcode.app") {
        printInConsole("   Trying to use system templates. Consider using user templates instead.")
        printInConsole("   Or you may need to disable System Integrity Protection (SIP)")
      }
    }
  }
}

func shell(launchPath: String, arguments: [String]) -> String {
  let task = Process()
  task.launchPath = launchPath
  task.arguments = arguments

  let pipe = Pipe()
  task.standardOutput = pipe
  task.launch()

  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  let output = String(data: data, encoding: String.Encoding.utf8)!
  if output.count > 0 {
    //remove newline character.
    let lastIndex = output.index(before: output.endIndex)
    return String(output[output.startIndex..<lastIndex])
  }
  return output
}

func bash(command: String, arguments: [String]) -> String {
  let whichPathForCommand = shell(
    launchPath: "/bin/bash", arguments: ["-l", "-c", "which \(command)"])
  return shell(launchPath: whichPathForCommand, arguments: arguments)
}

moveTemplate()
