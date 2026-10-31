import XCTest

final class ScreenshotTests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = true
    }

    func shot(_ name: String) {
        Thread.sleep(forTimeInterval: 1.0)
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func btn(_ text: String) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@", text)).firstMatch
    }

    func tap(_ element: XCUIElement) {
        if element.waitForExistence(timeout: 6) { element.tap() }
    }

        func hideKeyboard() {
        let cont = app.buttons["Continue"]
        if cont.waitForExistence(timeout: 2) { cont.tap() }
        let key = app.keyboards.buttons.matching(NSPredicate(format: "label ==[c] %@ OR label ==[c] %@", "return", "done")).firstMatch
        if key.exists { key.tap() }
    }

    func field(_ name: String) -> XCUIElement {
        let f = app.textFields[name]
        return f.waitForExistence(timeout: 4) ? f : app.textViews[name]
    }

    /// Intenta elegir la primera foto del selector del sistema.
    func pickFirstPhoto() {
        tap(btn("Elegir imagen"))
        Thread.sleep(forTimeInterval: 3.0)
        let photo = app.scrollViews.images.firstMatch
        if photo.waitForExistence(timeout: 8) { photo.tap() }
        Thread.sleep(forTimeInterval: 2.0)
    }

    func crearEvento(titulo: String, descripcion: String, conFoto: Bool) {
        tap(btn("Nuevo evento"))
        let t = field("Título"); tap(t); t.typeText(titulo)
        let d = field("Descripción"); tap(d); d.typeText(descripcion)
        hideKeyboard()
        if conFoto { pickFirstPhoto() }
    }

    func testEventPlanner() {
        app.launch()
        shot("01_listado_vacio")

        crearEvento(titulo: "Cumpleaños de Ana", descripcion: "Cena familiar en casa", conFoto: true)
        shot("02_pantalla_creacion")
        tap(btn("Guardar"))

        crearEvento(titulo: "Reunión de trabajo", descripcion: "Revisión de avances del proyecto", conFoto: false)
        tap(btn("Guardar"))
        shot("03_listado_con_eventos")

        // Editar el primer evento
        tap(app.cells.element(boundBy: 0))
        let t = field("Título")
        if t.waitForExistence(timeout: 5) {
            t.coordinate(withNormalizedOffset: CGVector(dx: 0.98, dy: 0.5)).tap()
            t.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 40) + "Cumpleaños de Ana (editado)")
            hideKeyboard()
        }
        shot("04_pantalla_edicion")
        tap(btn("Guardar"))
        shot("05_listado_tras_editar")

        // Persistencia: cerrar la app por completo y abrirla de nuevo
        app.terminate()
        app.launch()
        shot("06_persistencia_tras_cerrar_la_app")
    }
}
