//
//  LexelUITests.swift
//  LexelUITests
//
//  Created by Tyler McCormick on 6/23/24.
//

import XCTest

final class LexelUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .landscapeRight
    }

    func testAddButtonShown() throws {
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        let button = app.buttons["addStoryButton"]
        XCTAssertTrue(button.exists)
    }
    
    func testNoStoriesInLibrary() throws {
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
        
        let libraryList = app.collectionViews["storyList"]
        XCTAssert(libraryList.exists)
        
        // assert list has 0 elements
        let emptyRow = libraryList.cells.element(boundBy: 0)
        XCTAssertFalse(emptyRow.exists)
    }

    func testAddOneStory() throws {
           let app = XCUIApplication()
           app.launchArguments = ["enable-testing"]
           app.launch()

           let addStoryButton = app.buttons["addStoryButton"]
           addStoryButton.tap()

           let titleField = app.textFields["storyTitleField"]
           XCTAssertTrue(titleField.exists)
           titleField.tap()
           titleField.typeText("Der Hund")

   //        let languagePicker = app.pickers["storyLangPicker"]
   //        XCTAssertTrue(languagePicker.exists, "Lang picker should exist")
   //        languagePicker.tap()
   //        languagePicker.pickerWheels.element.adjust(toPickerWheelValue: "German")
   //        let selectedValue = languagePicker.pickerWheels.element.value as? String
   //        XCTAssertEqual(selectedValue, "German")

           let textField = app.textViews["storyTextField"]
           XCTAssertTrue(textField.exists)
           textField.tap()
           textField.typeText("Der Hund hat einem shonen tag heute! Genau genau jaja.")
           
           
           let add = app.buttons["addStory"]
           XCTAssertTrue(add.exists)
           add.tap()

//           XCTAssertTrue(app.staticTexts["Der Hund"].exists) // new story should be in the sidebar
           XCTAssertTrue(app.collectionViews["storyList"].cells.element(boundBy: 0).exists)
       }
       
       func testStoryViewable() throws {
           let app = XCUIApplication()
           app.launchArguments = ["populate", "enable-testing"]
           app.launch()
           
           let storyList = app.collectionViews["storyList"]
           XCTAssertTrue(storyList.cells.count == 2)
       }

   }
