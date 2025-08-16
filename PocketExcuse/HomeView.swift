import SwiftUI
import UIKit

// MARK: - Simple models

struct ExcuseRecord: Identifiable, Equatable, Codable {
    let id: UUID
    var text: String
    var timestamp: Date
    var tone: ExcuseTone
    init(id: UUID = UUID(), text: String, timestamp: Date = Date(), tone: ExcuseTone) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.tone = tone
    }
}

struct ExcuseStats: Identifiable, Equatable, Codable {
    let id: UUID
    var text: String
    var up: Int
    var down: Int
    init(id: UUID = UUID(), text: String, up: Int = 0, down: Int = 0) {
        self.id = id
        self.text = text
        self.up = up
        self.down = down
    }
}

enum ExcuseTone: String, CaseIterable, Identifiable, Codable {
    case polite, formal, friendly
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .polite: return "hand.raised.fill"
        case .formal: return "briefcase.fill"
        case .friendly: return "smiley.fill"
        }
    }
}

// MARK: - Strings

struct L10n {
    var lang: String
    func t(_ key: String) -> String {
        let l = lang
        switch key {
        case "app.title":     return ["es":"Pocket Excuse","fr":"Pocket Excuse","de":"Pocket Excuse","el":"Pocket Excuse"][l] ?? "Pocket Excuse"
        case "app.subtitle":
            return [
                "es":"Excusas rápidas que suenan naturales. Elige un tono y listo.",
                "fr":"Des excuses rapides qui sonnent naturelles. Choisis un ton et c’est parti.",
                "de":"Schnelle Ausreden, die natürlich klingen. Ton wählen und los.",
                "el":"Γρήγορες δικαιολογίες που ακούγονται φυσικές. Διάλεξε ύφος και έτοιμο."
            ][l] ?? "Quick excuses that sound natural. Pick a tone and go."
        case "cta.generate":  return ["es":"Discúlpame","fr":"Excuse-moi","de":"Entschuldige","el":"Συγγνώμη"][l] ?? "Excuse Me"
        case "tone.polite":   return ["es":"Cortés","fr":"Poli","de":"Höflich","el":"Ευγενικό"][l] ?? "Polite"
        case "tone.formal":   return ["es":"Formal","fr":"Formel","de":"Formell","el":"Επίσημο"][l] ?? "Formal"
        case "tone.friendly": return ["es":"Cercano","fr":"Amical","de":"Locker","el":"Φιλικό"][l] ?? "Friendly"
        case "hdr.excuse":    return ["es":"Tu excusa","fr":"Ton excuse","de":"Deine Ausrede","el":"Η δικαιολογία σου"][l] ?? "Your Excuse"
        case "hdr.history":   return ["es":"Historial","fr":"Historique","de":"Verlauf","el":"Ιστορικό"][l] ?? "History"
        case "hdr.success":   return ["es":"Éxito","fr":"Succès","de":"Erfolg","el":"Επιτυχία"][l] ?? "Success"
        case "hdr.dev":       return ["es":"Desarrollador","fr":"Développeur","de":"Entwickler","el":"Προγραμματιστής"][l] ?? "Developer"
        case "hdr.settings":  return ["es":"Ajustes","fr":"Réglages","de":"Einstellungen","el":"Ρυθμίσεις"][l] ?? "Settings"
        case "btn.manage":    return ["es":"Gestionar","fr":"Gérer","de":"Verwalten","el":"Διαχείριση"][l] ?? "Manage"
        case "btn.done":      return ["es":"Listo","fr":"Terminé","de":"Fertig","el":"Τέλος"][l] ?? "Done"
        case "btn.clearall":  return ["es":"Borrar todo","fr":"Tout effacer","de":"Alles löschen","el":"Διαγραφή όλων"][l] ?? "Clear All"
        case "empty.history":
            return ["es":"Aún no hay excusas. Genera una para verla aquí.",
                    "fr":"Aucune excuse pour l’instant. Génère-en une pour l’afficher ici.",
                    "de":"Noch keine Ausreden. Erzeuge eine, um sie hier zu sehen.",
                    "el":"Δεν υπάρχουν δικαιολογίες ακόμη. Δημιούργησε μία για να εμφανιστεί εδώ."][l]
            ?? "No excuses yet. Generate one to see it here."
        case "empty.success":
            return ["es":"Marca lo que funcione o no, para afinar las sugerencias.",
                    "fr":"Indique ce qui marche ou pas pour améliorer les propositions.",
                    "de":"Markiere, was klappt oder nicht, um Vorschläge zu verbessern.",
                    "el":"Σημείωσε τι δούλεψε ή όχι για καλύτερες προτάσεις."][l]
            ?? "Upvote or downvote to improve suggestions."
        case "dev.name":      return ["es":"Nombre","fr":"Nom","de":"Name","el":"Όνομα"][l] ?? "Name"
        case "dev.github":    return "GitHub"
        case "dev.discord":   return "Discord"
        case "dev.aboutme":   return ["es":"Sobre mí","fr":"À propos","de":"Über mich","el":"Σχετικά με εμένα"][l] ?? "About me"
        case "set.theme":     return ["es":"Tema","fr":"Thème","de":"Thema","el":"Θέμα"][l] ?? "Theme"
        case "set.dark":      return ["es":"Oscuro","fr":"Sombre","de":"Dunkel","el":"Σκούρο"][l] ?? "Dark"
        case "set.light":     return ["es":"Claro","fr":"Clair","de":"Hell","el":"Φωτεινό"][l] ?? "Light"
        case "set.info":      return ["es":"Información de la app","fr":"Infos de l’app","de":"App-Info","el":"Πληροφορίες εφαρμογής"][l] ?? "App Info"
        default: return key
        }
    }
}

// MARK: - Theme

struct Theme: Equatable {
    var isDark: Bool
    var iconColor: Color { isDark ? .white : .black }
    var rimColor: Color { isDark ? .white.opacity(0.12) : .black.opacity(0.10) }
    var softShadow: Color { isDark ? .black.opacity(0.24) : .black.opacity(0.12) }
    var buttonGradient: LinearGradient {
        if isDark {
            return LinearGradient(
                colors: [Color(red: 0.13, green: 0.74, blue: 0.52),
                         Color(red: 0.06, green: 0.60, blue: 0.99)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color(red: 0.93, green: 0.50, blue: 0.95),
                         Color(red: 0.44, green: 0.69, blue: 1.00)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - App state

final class AppState: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    @AppStorage("languageCode") var languageCode: String = "en"
    @AppStorage("discordURLString") var discordURLString: String = "https://discord.gg/yourserver"

    @AppStorage("historyJSON") private var historyJSON: String = ""
    @AppStorage("statsJSON")   private var statsJSON: String = ""

    @Published var showExcuseOverlay = false
    @Published var showHistoryOverlay = false
    @Published var showSuccessOverlay = false
    @Published var showSettingsOverlay = false
    @Published var showDevOverlay = false
    @Published var managingHistory = false

    @Published var excuseText: String = ""
    @Published var lastExcuse: String = ""
    @Published var selectedTone: ExcuseTone = .polite
    @Published var history: [ExcuseRecord] = []
    @Published var stats: [ExcuseStats] = []

    var theme: Theme { Theme(isDark: isDarkMode) }
    var l10n: L10n { L10n(lang: languageCode) }
    var discordURL: URL? { URL(string: discordURLString) }

    func onAppear() {
        if let data = historyJSON.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([ExcuseRecord].self, from: data) {
            history = decoded
        }
        if let data = statsJSON.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([ExcuseStats].self, from: data) {
            stats = decoded
        }
    }

    private func persistHistory() {
        if let data = try? JSONEncoder().encode(history) {
            historyJSON = String(decoding: data, as: UTF8.self)
        }
    }
    private func persistStats() {
        if let data = try? JSONEncoder().encode(stats) {
            statsJSON = String(decoding: data, as: UTF8.self)
        }
    }

    @MainActor
    func generateExcuse() {
        let text = localExcuse(avoid: lastExcuse, tone: selectedTone, languageCode: languageCode, stats: stats)
        lastExcuse = text
        excuseText = text
        let rec = ExcuseRecord(text: text, tone: selectedTone)
        history.insert(rec, at: 0)
        persistHistory()
        if stats.firstIndex(where: { $0.text == text }) == nil {
            stats.insert(ExcuseStats(text: text), at: 0)
            persistStats()
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) { showExcuseOverlay = true }
    }

    private func occurrences(inHistory text: String) -> Int {
        history.reduce(0) { $0 + ($1.text == text ? 1 : 0) }
    }

    func upvote(text: String) {
        let maxVotes = occurrences(inHistory: text)
        guard maxVotes > 0 else { return }
        if let i = stats.firstIndex(where: { $0.text == text }) {
            let total = stats[i].up + stats[i].down
            guard total < maxVotes else { return }
            stats[i].up += 1
        } else {
            stats.insert(ExcuseStats(text: text, up: 1, down: 0), at: 0)
        }
        persistStats()
    }
    func downvote(text: String) {
        let maxVotes = occurrences(inHistory: text)
        guard maxVotes > 0 else { return }
        if let i = stats.firstIndex(where: { $0.text == text }) {
            let total = stats[i].up + stats[i].down
            guard total < maxVotes else { return }
            stats[i].down += 1
        } else {
            stats.insert(ExcuseStats(text: text, up: 0, down: 1), at: 0)
        }
        persistStats()
    }

    func removeHistory(id: UUID) {
        guard let idx = history.firstIndex(where: { $0.id == id }) else { return }
        let removedText = history[idx].text
        history.remove(at: idx)
        persistHistory()
        if !history.contains(where: { $0.text == removedText }) {
            stats.removeAll { $0.text == removedText }
            persistStats()
        }
    }
    func clearAllHistory() {
        history.removeAll()
        stats.removeAll()
        persistHistory()
        persistStats()
    }
}

// MARK: - Local lines (per language)

private func localExcuse(avoid: String?, tone: ExcuseTone, languageCode: String, stats: [ExcuseStats]) -> String {
    let en_polite = [
        "Sorry, I’m running a little late. I’ll be there soon.",
        "Thanks for your patience. I got held up on the way.",
        "Apologies, the previous thing took longer than planned.",
        "I’m on my way now. Sorry for the delay.",
        "Really appreciate the wait. I’ll join shortly."
    ]
    let en_formal = [
        "I’m a few minutes behind schedule and will join as soon as possible.",
        "The prior meeting extended. I’m en route and will keep you updated.",
        "Transit delays today. I’ll share an ETA shortly.",
        "A brief delay on my end. I’ll connect when available.",
        "The schedule shifted unexpectedly. Thank you for the flexibility."
    ]
    let en_friendly = [
        "Got caught in a mini mess. Be there soon!",
        "Cat politics at the door, but I’m moving now.",
        "One quick detour and I’m heading over.",
        "The last thing ran long. Catching up fast!",
        "Not disappearing, just delayed a bit."
    ]

    let es_polite = [
        "Perdona, voy un poco justo. Llego en breve.",
        "Gracias por la paciencia, me entretuve de camino.",
        "Disculpa, lo anterior se alargó más de la cuenta.",
        "Ya voy hacia allí. Perdona la demora.",
        "Agradezco la espera. Me uno en un momento."
    ]
    let es_formal = [
        "Llego con unos minutos de retraso. Me incorporo en cuanto pueda.",
        "La reunión previa se prolongó. Ya voy y mantengo informado.",
        "Hoy hubo lío en el transporte. Enseguida paso una hora estimada.",
        "Pequeño retraso por mi parte. Me conecto en cuanto esté libre.",
        "El horario se movió sin avisar. Gracias por la comprensión."
    ]
    let es_friendly = [
        "Se me cruzó un imprevisto, pero ya voy.",
        "La gata montó guardia en la puerta, salgo ya.",
        "Hice un rodeo mínimo, estoy en ello.",
        "Lo de antes se estiró, voy volando.",
        "No me perdí, tardé un poco."
    ]

    let fr_polite = [
        "Désolé, j’arrive un peu plus tard que prévu.",
        "Merci pour la patience, j’ai été retenu en route.",
        "Pardon, la partie d’avant a duré plus longtemps.",
        "J’arrive maintenant. Désolé pour le contretemps.",
        "Merci d’attendre, je me joins dans un instant."
    ]
    let fr_formal = [
        "Je suis en léger décalage, je rejoins dès que possible.",
        "La réunion précédente s’est prolongée. Je suis en route et je vous tiens au courant.",
        "Problèmes de transport aujourd’hui. J’envoie une heure d’arrivée rapidement.",
        "Petit retard de mon côté. Je me connecte dès disponibilité.",
        "Le planning a bougé sans prévenir. Merci pour la souplesse."
    ]
    let fr_friendly = [
        "Petit bazar sur le trajet, j’arrive bientôt.",
        "Le chat a fait sa loi à la porte, je pars là.",
        "Mini détour, je file chez vous.",
        "Le truc d’avant a débordé, je rattrape.",
        "Pas d’évasion, juste un peu en retard."
    ]

    let de_polite = [
        "Tut mir leid, ich bin etwas später dran. Bin gleich da.",
        "Danke für die Geduld, wurde unterwegs aufgehalten.",
        "Entschuldigung, der Termin davor dauerte länger.",
        "Ich mache mich jetzt auf den Weg. Sorry für die Verspätung.",
        "Danke fürs Warten, ich stoße gleich dazu."
    ]
    let de_formal = [
        "Ich liege ein paar Minuten zurück und schalte mich sobald wie möglich zu.",
        "Das vorherige Meeting hat sich gezogen. Ich bin unterwegs und halte euch auf dem Laufenden.",
        "Heute gab es Verzögerungen im Verkehr. Eine ETA folgt gleich.",
        "Kleine Verzögerung meinerseits. Ich verbinde mich, sobald es geht.",
        "Der Plan hat sich kurzfristig geändert. Danke für die Flexibilität."
    ]
    let de_friendly = [
        "Kleines Chaos auf dem Weg, bin gleich da.",
        "Die Katze hat die Tür bewacht, jetzt starte ich.",
        "Mini Umweg, ich komme rüber.",
        "Das Letzte hat länger gedauert, ich hole auf.",
        "Nicht weg, nur kurz verspätet."
    ]

    let el_polite = [
        "Συγγνώμη, άργησα λίγο. Έρχομαι σε λίγο.",
        "Ευχαριστώ για την υπομονή, με καθυστέρησαν στον δρόμο.",
        "Συγγνώμη, το προηγούμενο κράτησε παραπάνω.",
        "Ήδη ξεκίνησα. Συγγνώμη για την καθυστέρηση.",
        "Ευχαριστώ που περίμενες, σε λίγο συνδέομαι."
    ]
    let el_formal = [
        "Θα καθυστερήσω μερικά λεπτά και θα μπω μόλις μπορώ.",
        "Η προηγούμενη συνάντηση παρατάθηκε. Είμαι καθ’ οδόν και θα ενημερώσω.",
        "Σήμερα είχε καθυστέρηση στα μέσα. Θα στείλω εκτίμηση άφιξης.",
        "Μικρή καθυστέρηση από μεριάς μου. Συνδέομαι μόλις είμαι διαθέσιμος.",
        "Το πρόγραμμα άλλαξε τελευταία στιγμή. Ευχαριστώ για την κατανόηση."
    ]
    let el_friendly = [
        "Λίγο μπερδεύτηκα στον δρόμο, έρχομαι.",
        "Η γάτα έκανε κουμάντο στην πόρτα, ξεκινάω τώρα.",
        "Μικρή παράκαμψη και έρχομαι.",
        "Το προηγούμενο τράβηξε, το μαζεύω.",
        "Δεν χάθηκα, απλώς άργησα λίγο."
    ]

    func pools(_ lang: String) -> ([String],[String],[String]) {
        switch lang {
        case "es": return (es_polite, es_formal, es_friendly)
        case "fr": return (fr_polite, fr_formal, fr_friendly)
        case "de": return (de_polite, de_formal, de_friendly)
        case "el": return (el_polite, el_formal, el_friendly)
        default:   return (en_polite, en_formal, en_friendly)
        }
    }

    let (polite, formal, friendly) = pools(languageCode)
    let base: [String]
    switch tone { case .polite: base = polite; case .formal: base = formal; case .friendly: base = friendly }

    let upSet = Set(stats.filter { $0.up > 0 }.map { $0.text })
    let downSet = Set(stats.filter { $0.down > 0 }.map { $0.text })

    var weighted = base.filter { !downSet.contains($0) }
    weighted.append(contentsOf: base.filter { upSet.contains($0) })

    var pick = (weighted.isEmpty ? base : weighted).randomElement() ?? (base.first ?? "...")
    if let avoid, base.count > 1, pick == avoid {
        pick = base.first(where: { $0 != avoid }) ?? pick
    }
    return pick
}

// MARK: - Main view

struct HomeView: View {
    @StateObject private var state = AppState()

    private let edgeInset: CGFloat = 20
    private let iconHit: CGFloat  = 56
    private let iconSize: CGFloat = 28
    private let listHeight: CGFloat = 420

    var body: some View {
        ZStack {
            background(dark: state.isDarkMode).ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    glassIcon(system: "gearshape.fill", theme: state.theme) { state.showSettingsOverlay = true }
                    Spacer()
                    languageMenu(theme: state.theme)
                }
                .padding(.top, edgeInset)
                .padding(.horizontal, edgeInset)

                Spacer().frame(height: 28)

                VStack(spacing: 6) {
                    Text(state.l10n.t("app.title"))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(state.l10n.t("app.subtitle"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                }
                .padding(.bottom, 8)

                Spacer(minLength: 8)

                VStack(spacing: 16) {
                    Button { state.generateExcuse() } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "wand.and.stars").font(.headline.weight(.semibold))
                            Text(state.l10n.t("cta.generate")).font(.headline.weight(.semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(state.theme.buttonGradient)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(Color.white.opacity(state.theme.isDark ? 0.18 : 0.22), lineWidth: 1)
                                )
                                .shadow(color: state.theme.softShadow, radius: 10, x: 0, y: 6)
                        )
                    }
                    .buttonStyle(.plain)

                    HStack(spacing: 12) {
                        toneChip(.polite,   title: state.l10n.t("tone.polite"))
                        toneChip(.formal,   title: state.l10n.t("tone.formal"))
                        toneChip(.friendly, title: state.l10n.t("tone.friendly"))
                    }
                }
                .padding(.horizontal, edgeInset)
                .padding(.bottom, 24)

                Spacer()

                HStack(spacing: 16) {
                    dockIcon("clock", theme: state.theme) { state.managingHistory = false; state.showHistoryOverlay = true }
                    dockIcon("arrow.up.arrow.down", theme: state.theme) { state.showSuccessOverlay = true }
                    dockIcon("person.text.rectangle", theme: state.theme) { state.showDevOverlay = true }
                }
                .padding(.horizontal, edgeInset)
                .padding(.bottom, edgeInset)
            }

            if state.showExcuseOverlay { excusePopup(theme: state.theme) }
            if state.showHistoryOverlay { historyPopup(theme: state.theme) }
            if state.showSuccessOverlay { successPopup(theme: state.theme) }
            if state.showSettingsOverlay { settingsPopup(theme: state.theme) }
            if state.showDevOverlay { developerPopup(theme: state.theme) }
        }
        .onAppear { state.onAppear() }
        .preferredColorScheme(state.isDarkMode ? .dark : .light)
    }
}

// MARK: - Pieces

private extension HomeView {
    @ViewBuilder
    func background(dark: Bool) -> some View {
        ZStack {
            if dark {
                LinearGradient(colors: [
                    Color(red: 0.06, green: 0.08, blue: 0.13),
                    Color(red: 0.07, green: 0.11, blue: 0.18),
                    Color(red: 0.05, green: 0.09, blue: 0.16)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                RadialGradient(colors: [Color(red: 0.50, green: 0.75, blue: 1.00).opacity(0.23), .clear],
                               center: .topTrailing, startRadius: 0, endRadius: 520)
                RadialGradient(colors: [Color(red: 0.35, green: 1.00, blue: 0.75).opacity(0.20), .clear],
                               center: .bottomLeading, startRadius: 0, endRadius: 520)
                RadialGradient(colors: [Color(red: 1.00, green: 0.55, blue: 0.45).opacity(0.16), .clear],
                               center: .bottomTrailing, startRadius: 0, endRadius: 480)
            } else {
                LinearGradient(colors: [Color(red: 0.98, green: 0.98, blue: 1.00), Color(white: 0.92)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                RadialGradient(colors: [Color(red: 1.00, green: 0.84, blue: 0.98).opacity(0.70), .clear],
                               center: .topLeading, startRadius: 0, endRadius: 620)
                RadialGradient(colors: [Color(red: 0.84, green: 0.93, blue: 1.00).opacity(0.65), .clear],
                               center: .bottomTrailing, startRadius: 0, endRadius: 640)
                RadialGradient(colors: [Color(red: 1.00, green: 0.93, blue: 0.83).opacity(0.58), .clear],
                               center: .bottomLeading, startRadius: 0, endRadius: 560)
                AngularGradient(gradient: Gradient(colors: [
                    Color.white.opacity(0.0),
                    Color(red: 0.95, green: 0.93, blue: 1.00).opacity(0.35),
                    Color.white.opacity(0.0)
                ]), center: .center)
                .blendMode(.softLight)
            }
            LinearGradient(colors: [Color.black.opacity(dark ? 0.18 : 0.06), .clear], startPoint: .top, endPoint: .center)
            LinearGradient(colors: [.clear, Color.black.opacity(dark ? 0.22 : 0.08)], startPoint: .center, endPoint: .bottom)
        }
    }

    func glassBox(corner: CGFloat, theme: Theme) -> some View {
        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(RoundedRectangle(cornerRadius: corner, style: .continuous).stroke(theme.rimColor, lineWidth: 1))
            .shadow(color: theme.softShadow, radius: 4, x: 0, y: 2)
    }

    func glassIcon(system: String, theme: Theme, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.title3)
                .foregroundColor(theme.iconColor)
                .frame(width: 56, height: 56)
                .background(glassBox(corner: 16, theme: theme))
        }
        .buttonStyle(.plain)
    }

    func dockIcon(_ name: String, theme: Theme, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: name)
                .font(.system(size: iconSize, weight: .regular))
                .foregroundColor(theme.iconColor)
                .frame(width: iconHit, height: iconHit)
                .background(glassBox(corner: 16, theme: theme))
        }
        .buttonStyle(.plain)
    }

    func languageMenu(theme: Theme) -> some View {
        Menu {
            Picker("Language", selection: $state.languageCode) {
                Text("English").tag("en")
                Text("Español").tag("es")
                Text("Français").tag("fr")
                Text("Deutsch").tag("de")
                Text("Ελληνικά").tag("el")
            }
        } label: {
            Image(systemName: "globe")
                .font(.title3)
                .foregroundColor(theme.iconColor)
                .frame(width: 56, height: 56)
                .background(glassBox(corner: 16, theme: theme))
        }
        .buttonStyle(.plain)
    }

    func toneChip(_ tone: ExcuseTone, title: String) -> some View {
        let selected = state.selectedTone == tone
        return HStack(spacing: 8) {
            Image(systemName: tone.icon).font(.subheadline.weight(.semibold))
            Text(title).font(.subheadline.weight(.semibold))
        }
        .foregroundColor(state.theme.iconColor)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(selected ? state.theme.buttonGradient :
                                LinearGradient(colors: [state.theme.rimColor], startPoint: .leading, endPoint: .trailing),
                                lineWidth: selected ? 1.8 : 1)
                )
                .shadow(color: state.theme.softShadow, radius: 6, x: 0, y: 3)
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.9)) {
                state.selectedTone = tone
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }

    // Excuse popup

    @ViewBuilder
    func excusePopup(theme: Theme) -> some View {
        ZStack {
            Color.black.opacity(theme.isDark ? 0.24 : 0.20).ignoresSafeArea()
                .onTapGesture { withAnimation(.spring(response: 0.28)) { state.showExcuseOverlay = false } }

            VStack(spacing: 12) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles").font(.headline.weight(.semibold))
                        Text(state.l10n.t("hdr.excuse")).font(.headline.weight(.semibold))
                    }
                    .foregroundColor(theme.iconColor)
                    Spacer()
                    HStack(spacing: 8) {
                        glassIcon(system: "doc.on.doc", theme: theme) {
                            UIPasteboard.general.string = state.excuseText
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        glassIcon(system: "square.and.arrow.up", theme: theme) {
                            share(text: state.excuseText)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, 12)

                Text(state.excuseText)
                    .textSelection(.enabled)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.thickMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(theme.rimColor, lineWidth: 1))
                    )
                    .padding(.horizontal, 14)
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: 560) // consistent width
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.regularMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(theme.rimColor, lineWidth: 1))
                    .shadow(color: theme.softShadow, radius: 10, x: 0, y: 6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(.horizontal, 18)
            .transition(.scale.combined(with: .opacity))
        }
    }

    // History popup

    @ViewBuilder
    func historyPopup(theme: Theme) -> some View {
        ZStack {
            Color.black.opacity(theme.isDark ? 0.24 : 0.20).ignoresSafeArea()
                .onTapGesture { withAnimation(.spring(response: 0.28)) { state.showHistoryOverlay = false } }

            VStack(spacing: 0) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "clock").font(.headline.weight(.semibold))
                        Text(state.l10n.t("hdr.history")).font(.headline.weight(.semibold))
                    }
                    .foregroundColor(theme.iconColor)
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.28)) { state.managingHistory.toggle() }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: state.managingHistory ? "checkmark.circle.fill" : "slider.horizontal.3")
                            Text(state.managingHistory ? state.l10n.t("btn.done") : state.l10n.t("btn.manage"))
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(theme.iconColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(.ultraThinMaterial)
                                .overlay(Capsule().stroke(theme.rimColor, lineWidth: 1))
                                .shadow(color: theme.softShadow, radius: 4, x: 0, y: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 10)

                if state.history.isEmpty {
                    Text(state.l10n.t("empty.history"))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 10) {
                            ForEach(state.history) { rec in historyRow(rec, theme: theme) }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    }
                    .frame(height: listHeight)

                    if state.managingHistory {
                        Button {
                            withAnimation(.spring(response: 0.28)) { state.clearAllHistory() }
                        } label: {
                            HStack(spacing: 8) { Image(systemName: "trash"); Text(state.l10n.t("btn.clearall")) }
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.red)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule().fill(.ultraThinMaterial)
                                        .overlay(Capsule().stroke(theme.rimColor, lineWidth: 1))
                                )
                        }
                        .buttonStyle(.plain)
                        .padding(.bottom, 14)
                    }
                }
            }
            .frame(maxWidth: 560)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.regularMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(theme.rimColor, lineWidth: 1))
                    .shadow(color: theme.softShadow, radius: 10, x: 0, y: 6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(.horizontal, 18)
            .transition(.scale.combined(with: .opacity))
        }
    }

    @ViewBuilder
    func historyRow(_ rec: ExcuseRecord, theme: Theme) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(rec.text)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(rec.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            if state.managingHistory {
                Button {
                    withAnimation(.spring(response: 0.28)) { state.removeHistory(id: rec.id) }
                } label: {
                    Image(systemName: "trash")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(width: 40, height: 40)
                        .background(glassBox(corner: 12, theme: theme))
                }
                .buttonStyle(.plain)
            } else {
                HStack(spacing: 8) {
                    glassIcon(system: "doc.on.doc", theme: theme) {
                        UIPasteboard.general.string = rec.text
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    glassIcon(system: "square.and.arrow.up", theme: theme) {
                        share(text: rec.text)
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.regularMaterial)
                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(theme.rimColor, lineWidth: 1))
        )
    }

    // Success popup

    @ViewBuilder
    func successPopup(theme: Theme) -> some View {
        ZStack {
            Color.black.opacity(theme.isDark ? 0.24 : 0.20).ignoresSafeArea()
                .onTapGesture { withAnimation(.spring(response: 0.28)) { state.showSuccessOverlay = false } }

            VStack(spacing: 0) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.up.arrow.down").font(.headline.weight(.semibold))
                        Text(state.l10n.t("hdr.success")).font(.headline.weight(.semibold))
                    }
                    .foregroundColor(theme.iconColor)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 10)

                if state.stats.isEmpty {
                    Text(state.l10n.t("empty.success"))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 10) {
                            ForEach(state.stats) { stat in successRow(stat, theme: theme) }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    }
                    .frame(height: listHeight)
                }
            }
            .frame(maxWidth: 560)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.regularMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(theme.rimColor, lineWidth: 1))
                    .shadow(color: theme.softShadow, radius: 10, x: 0, y: 6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(.horizontal, 18)
            .transition(.scale.combined(with: .opacity))
        }
    }

    @ViewBuilder
    func successRow(_ stat: ExcuseStats, theme: Theme) -> some View {
        let occurrences = state.history.reduce(0) { $0 + ($1.text == stat.text ? 1 : 0) }
        let usedVotes = stat.up + stat.down
        let canVote = usedVotes < occurrences

        HStack(spacing: 12) {
            Button {
                if canVote {
                    state.upvote(text: stat.text)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up")
                        .font(.headline)
                        .foregroundStyle(canVote ? theme.buttonGradient :
                                         LinearGradient(colors: [.secondary], startPoint: .leading, endPoint: .trailing))
                    Text("\(stat.up)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                }
                .frame(width: 76, height: 40)
                .background(glassBox(corner: 12, theme: theme))
            }
            .buttonStyle(.plain)
            .disabled(!canVote)

            Button {
                if canVote {
                    state.downvote(text: stat.text)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.down")
                        .font(.headline)
                        .foregroundColor(canVote ? .red : .secondary)
                    Text("\(stat.down)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                }
                .frame(width: 76, height: 40)
                .background(glassBox(corner: 12, theme: theme))
            }
            .buttonStyle(.plain)
            .disabled(!canVote)

            Text(stat.text)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.regularMaterial)
                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(theme.rimColor, lineWidth: 1))
        )
        .overlay(alignment: .topTrailing) {
            if !canVote {
                Text("✓")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                    .padding(6)
                    .background(Capsule().fill(.ultraThinMaterial))
                    .overlay(Capsule().stroke(theme.rimColor, lineWidth: 1))
                    .padding(.trailing, 8)
                    .padding(.top, 8)
            }
        }
    }

    // Settings popup (theme + app info only)

    @ViewBuilder
    func settingsPopup(theme: Theme) -> some View {
        ZStack {
            Color.black.opacity(theme.isDark ? 0.24 : 0.20).ignoresSafeArea()
                .onTapGesture { withAnimation(.spring(response: 0.28)) { state.showSettingsOverlay = false } }

            let card = RoundedRectangle(cornerRadius: 22, style: .continuous)

            VStack(spacing: 14) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "gearshape.fill").font(.headline.weight(.semibold))
                        Text(state.l10n.t("hdr.settings")).font(.headline.weight(.semibold))
                    }
                    .foregroundColor(theme.iconColor)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)

                SettingsThemeRow(
                    theme: theme,
                    isDarkMode: $state.isDarkMode,
                    title: state.l10n.t("set.theme"),
                    light: state.l10n.t("set.light"),
                    dark: state.l10n.t("set.dark")
                )

                VStack(alignment: .leading, spacing: 6) {
                    Text(state.l10n.t("set.info"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.secondary)
                    Text("\(Bundle.main.appName) • v\(Bundle.main.appVersion)")
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 6)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: 560)
            .background(
                card.fill(.regularMaterial)
                    .overlay(card.stroke(theme.rimColor, lineWidth: 1))
                    .shadow(color: theme.softShadow, radius: 10, x: 0, y: 6)
            )
            .clipShape(card)
            .padding(.horizontal, 18)
            .transition(.scale.combined(with: .opacity))
        }
    }
    
    // MARK: - Developer popup (name + bio + GitHub button)
    
    @ViewBuilder
    func developerPopup(theme: Theme) -> some View {
        ZStack {
            Color.black.opacity(theme.isDark ? 0.24 : 0.20).ignoresSafeArea()
                .onTapGesture { withAnimation(.spring(response: 0.28)) { state.showDevOverlay = false } }

            VStack(spacing: 12) {
                // Header
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "person.text.rectangle").font(.headline.weight(.semibold))
                        Text(state.l10n.t("hdr.dev")).font(.headline.weight(.semibold))
                    }
                    .foregroundColor(theme.iconColor)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)

                // Name + bio (left-aligned and tidy)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Marios Neofytou")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)

                    Text(state.l10n.t("dev.aboutme"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.secondary)

                    Text("I’m Marios Neofytou, 18 years old. I enjoy programming, shipping small iOS apps, and learning new things as I go.")
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 16)

                // GitHub button (uses asset if available, falls back to SF Symbol-ish)
                Button {
                    if let url = URL(string: "https://github.com/chewtle") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack(spacing: 10) {
                        githubIcon()
                            .frame(width: 18, height: 18)
                        Text("GitHub")
                            .font(.headline.weight(.semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 14).fill(theme.buttonGradient))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: 560) // same width as other popups
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.regularMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(theme.rimColor, lineWidth: 1))
                    .shadow(color: theme.softShadow, radius: 10, x: 0, y: 6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(.horizontal, 18)
            .transition(.scale.combined(with: .opacity))
        }
    }

    // Uses an asset named "github" if present (vector PDF or PNG). Falls back to a system symbol if not.
    @ViewBuilder
    func githubIcon() -> some View {
        if UIImage(named: "github") != nil {
            Image("github")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
        } else {
            Image(systemName: "chevron.left.slash.chevron.right") // fallback
                .font(.headline)
        }
    }

}

// MARK: - Small helpers

private struct SettingsThemeRow: View {
    let theme: Theme
    @Binding var isDarkMode: Bool
    let title: String
    let light: String
    let dark: String

    var body: some View {
        HStack {
            Text(title).foregroundColor(.secondary)
            Spacer()
            Picker("", selection: $isDarkMode) {
                Text(light).tag(false)
                Text(dark).tag(true)
            }
            .pickerStyle(.segmented)
            .frame(width: 180)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - share and bundle helpers

private func share(text: String) {
    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let root = scene.keyWindow?.rootViewController else { return }
    let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
    root.present(vc, animated: true)
}

private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first(where: { $0.isKeyWindow }) }
}

private extension Bundle {
    var appName: String {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        ?? object(forInfoDictionaryKey: "CFBundleName") as? String
        ?? "App"
    }
    var appVersion: String {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        ?? "1.0"
    }
}

