import XCTest

final class ScreenshotTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = true
    }

    func shot(_ name: String, wait: TimeInterval = 1.0) {
        Thread.sleep(forTimeInterval: wait)
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func launch(_ arguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        return app
    }

    func testA_ConsumoExitoso() {
        _ = launch()
        shot("01_consumo_exitoso", wait: 12)
    }

    func testB_EstadoCarga() {
        _ = launch(["-simulate-slow"])
        shot("02_estado_carga", wait: 3)
    }

    func testC_EstadoError() {
        _ = launch(["-simulate-error"])
        shot("03_estado_error", wait: 3)
    }

    func testD_ResultadoFiltradoYVacio() {
        let app = launch()
        Thread.sleep(forTimeInterval: 12)
        let search = app.searchFields.firstMatch
        if search.waitForExistence(timeout: 8) {
            search.tap()
            search.typeText("the")
            shot("04_resultado_filtrado", wait: 2)
            search.typeText("zzzzzz")
            shot("05_estado_vacio", wait: 2)
        }
    }
}
