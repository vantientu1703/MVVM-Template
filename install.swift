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

func findTemplatePath(templateName: String) -> String? {
  let fileManager = FileManager.default

  // 1. Tìm trong thư mục hiện tại (ưu tiên cao nhất)
  let currentDir = fileManager.currentDirectoryPath
  var possiblePaths = ["\(currentDir)/\(templateName)"]

  // 2. Tìm trong thư mục chứa script (nếu script được gọi từ đường dẫn tuyệt đối)
  if let scriptPath = CommandLine.arguments.first,
    scriptPath.hasPrefix("/")
  {
    let scriptDir = (scriptPath as NSString).deletingLastPathComponent
    if scriptDir != "/" && scriptDir != currentDir {
      possiblePaths.append("\(scriptDir)/\(templateName)")
    }
  }

  // 3. Tìm trong thư mục cha của thư mục hiện tại
  let parentDir = (currentDir as NSString).deletingLastPathComponent
  if parentDir != "/" {
    possiblePaths.append("\(parentDir)/\(templateName)")
  }

  // Tìm đường dẫn đầu tiên tồn tại
  for path in possiblePaths {
    if fileManager.fileExists(atPath: path) {
      return path
    }
  }

  return nil
}

func moveTemplate() {

  let fileManager = FileManager.default
  let destinationPath = getDestinationPath()

  // Tìm đường dẫn tuyệt đối của template
  guard let sourcePath = findTemplatePath(templateName: templateName) else {
    printInConsole("❌  Error: Cannot find template '\(templateName)'")
    printInConsole("Current directory: \(fileManager.currentDirectoryPath)")
    printInConsole("Please run this script from the directory containing '\(templateName)'")
    printInConsole("Or place the script in the same directory as the template")
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
