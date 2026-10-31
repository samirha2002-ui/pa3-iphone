import XCTest

final class ScreenshotTests: XCTestCase {
    let app = XCUIApplication()

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

    func btn(_ text: String) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@", text)).firstMatch
    }

    func tap(_ element: XCUIElement) {
        if element.waitForExistence(timeout: 6) { element.tap() }
    }

    func hideKeyboard() {
        let key = app.keyboards.buttons.matching(NSPredicate(format: "label ==[c] %@ OR label ==[c] %@", "return", "done")).firstMatch
        if key.exists { key.tap() }
    }

    func field(_ name: String) -> XCUIElement {
        let f = app.textFields[name]
        return f.waitForExistence(timeout: 4) ? f : app.textViews[name]
    }

    func tab(_ name: String) {
        tap(app.tabBars.buttons[name])
    }

    func crearActividad(_ titulo: String, _ notas: String) {
        tap(btn("Nueva actividad"))
        let t = field("Título"); tap(t); t.typeText(titulo)
        let n = field("Notas"); tap(n); n.typeText(notas)
        hideKeyboard()
    }

    // Se ejecutan en orden alfabético: A, B, C, D, E
    func testA_Actividades() {
        app.launch()
        shot("01_actividades_vacio")

        crearActividad("Estudiar SwiftUI", "Repasar arquitectura por capas")
        shot("02_formulario_actividad")
        tap(btn("Guardar"))

        crearActividad("Salir a correr", "30 minutos en el parque")
        tap(btn("Guardar"))
        shot("03_lista_actividades")

        tap(app.cells.element(boundBy: 0))
        shot("04_editar_actividad")
        tap(btn("Cancelar"))

        app.cells.element(boundBy: 1).swipeLeft()
        shot("05_deslizar_para_eliminar")
        tap(btn("Eliminar"))
        shot("06_lista_tras_eliminar")

        // Persistencia: cerrar la app y abrirla de nuevo
        app.terminate()
        app.launch()
        shot("07_persistencia_tras_cerrar")
    }

    func testB_Multimedia() {
        app.launch()
        tab("Multimedia")
        shot("08_modulo_multimedia")
        tap(btn("Reproducir audio"))
        shot("09_audio_reproduciendo")
        tap(btn("Reproducir video"))
        shot("10_video_reproduciendo", wait: 3)

        app.swipeUp()
        tap(btn("Elegir imagen"))
        Thread.sleep(forTimeInterval: 3)
        shot("11_selector_de_fotos")
        let photo = app.scrollViews.images.firstMatch
        if photo.waitForExistence(timeout: 8) { photo.tap() }
        shot("12_imagen_seleccionada", wait: 3)
    }

    func testC_Personalizacion() {
        app.launch()
        tab("Personalizar")
        let nombre = field("Tu nombre"); tap(nombre); nombre.typeText("Ana")
        hideKeyboard()
        let plan = field("¿Qué quieres hacer?"); tap(plan); plan.typeText("Clase de yoga")
        hideKeyboard()
        tap(btn("Programar"))
        shot("13_personalizacion_programar_actividad")

        let well = app.colorWells.firstMatch
        if well.waitForExistence(timeout: 4) { well.tap() } else { tap(btn("Color del tema")) }
        shot("14_selector_de_color", wait: 2)
    }

    func testD_Explorar() {
        app.launch()
        tab("Explorar")
        shot("15_explorar_cuadricula", wait: 8)
    }

    func testE_ErrorDeRed() {
        app.launchArguments = ["-simulate-error"]
        app.launch()
        tab("Explorar")
        shot("16_explorar_error_de_red", wait: 4)
    }
}
