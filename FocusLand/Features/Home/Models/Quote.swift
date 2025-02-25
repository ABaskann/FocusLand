import Foundation


struct Quote: Identifiable, Codable {
    let id: String
    let translations: [String: String] // Language code to quote text
    let author: String
    var date: Date
    var text: String {
        // Get system language code
        
        let languageCode = Locale(identifier: Locale.preferredLanguages.first!).language.languageCode?.identifier ?? "en"
        // Return translation for current language or fallback to English
        return translations[languageCode] ?? translations["en"] ?? "Error loading quote"
    }
    
    static let quotes = [
        Quote(
        id: "1",
            translations: [
                "en": "The only way to do great work is to love what you do.",
                "es": "La única forma de hacer un gran trabajo es amar lo que haces.",
                "fr": "La seule façon de faire du bon travail est d'aimer ce que vous faites.",
                "de": "Der einzige Weg, großartige Arbeit zu leisten, ist zu lieben, was man tut."
            ],
            author: "Steve Jobs",
            date: Date()
        ),
        Quote(
            id: "2",
            translations: [
                "en": "Success is not final, failure is not fatal: it is the courage to continue that counts.",
                "es": "El éxito no es definitivo, el fracaso no es fatal: lo que cuenta es el valor para continuar.",
                "fr": "Le succès n'est pas final, l'échec n'est pas fatal : c'est le courage de continuer qui compte.",
                "de": "Erfolg ist nicht endgültig, Misserfolg ist nicht fatal: Was zählt, ist der Mut weiterzumachen."
            ],
            author: "Winston Churchill",
            date: Date()
        ),
        Quote(
            id: "3",
            translations: [
                "en": "Don't watch the clock; do what it does. Keep going.",
                "es": "No mires el reloj; haz lo que él hace. Sigue adelante.",
                "fr": "Ne regardez pas l'horloge ; faites comme elle. Continuez d'avancer.",
                "de": "Schauen Sie nicht auf die Uhr; tun Sie, was sie tut. Weitermachen."
            ],
            author: "Sam Levenson",
            date: Date()
        ),
        Quote(
            id: "4",
            translations: [
                "en": "Focus on being productive instead of busy.",
                "es": "Concéntrate en ser productivo en lugar de estar ocupado.",
                "fr": "Concentrez-vous sur la productivité plutôt que sur l'occupation.",
                "de": "Konzentrieren Sie sich darauf, produktiv zu sein, statt beschäftigt zu sein."
            ],
            author: "Tim Ferriss",
            date: Date()
        ),
        Quote(
            id: "5",
            translations: [
                "en": "The future depends on what you do today.",
                "es": "El futuro depende de lo que hagas hoy.",
                "fr": "L'avenir dépend de ce que vous faites aujourd'hui.",
                "de": "Die Zukunft hängt davon ab, was du heute tust."
            ],
            author: "Mahatma Gandhi",
            date: Date()
        ),
        Quote(
            id: "6",
            translations: [
                "en": "It's not about having time, it's about making time.",
                "es": "No se trata de tener tiempo, se trata de hacer tiempo.",
                "fr": "Ce n'est pas une question d'avoir du temps, mais d'en créer.",
                "de": "Es geht nicht darum, Zeit zu haben, sondern Zeit zu machen."
            ],
            author: "Unknown",
            date: Date()
        ),
        Quote(
            id: "7",
            translations: [
                "en": "The way to get started is to quit talking and begin doing.",
                "es": "La forma de empezar es dejar de hablar y comenzar a hacer.",
                "fr": "La façon de commencer est d'arrêter de parler et de commencer à faire.",
                "de": "Der Weg anzufangen ist, aufzuhören zu reden und anzufangen zu handeln."
            ],
            author: "Walt Disney",
            date: Date()
        ),
        Quote(
            id: "8",
            translations: [
                "en": "Quality is not an act, it is a habit.",
                "es": "La calidad no es un acto, es un hábito.",
                "fr": "La qualité n'est pas un acte, c'est une habitude.",
                "de": "Qualität ist keine Handlung, sondern eine Gewohnheit."
            ],
            author: "Aristotle",
            date: Date()
        ),
        Quote(
            id: "9",
            translations: [
                "en": "Your time is limited, don't waste it living someone else's life.",
                "es": "Tu tiempo es limitado, no lo desperdicies viviendo la vida de alguien más.",
                "fr": "Votre temps est limité, ne le gaspillez pas à vivre la vie de quelqu'un d'autre.",
                "de": "Deine Zeit ist begrenzt, verschwende sie nicht damit, das Leben eines anderen zu leben."
            ],
            author: "Steve Jobs",
            date: Date()
        ),
        Quote(
            id: "10",
            translations: [
                "en": "The only limit to our realization of tomorrow will be our doubts of today.",
                "es": "El único límite para nuestra realización del mañana serán nuestras dudas de hoy.",
                "fr": "La seule limite à notre réalisation de demain sera nos doutes d'aujourd'hui.",
                "de": "Die einzige Grenze unserer Verwirklichung von morgen werden unsere Zweifel von heute sein."
            ],
            author: "Franklin D. Roosevelt",
            date: Date()
        ),
        Quote(
            id: "11",
            translations: [
                "en": "Start where you are. Use what you have. Do what you can.",
                "es": "Empieza donde estás. Usa lo que tienes. Haz lo que puedas.",
                "fr": "Commencez où vous êtes. Utilisez ce que vous avez. Faites ce que vous pouvez.",
                "de": "Beginne dort, wo du bist. Nutze, was du hast. Tue, was du kannst."
            ],
            author: "Arthur Ashe",
            date: Date()
        ),
        Quote(
            id: "12",
            translations: [
                "en": "The secret of getting ahead is getting started.",
                "es": "El secreto para avanzar es comenzar.",
                "fr": "Le secret pour avancer est de commencer.",
                "de": "Das Geheimnis des Fortschritts ist der Anfang."
            ],
            author: "Mark Twain",
            date: Date()
        ),
        Quote(
            id: "13",
            translations: [
                "en": "Don't count the days, make the days count.",
                "es": "No cuentes los días, haz que los días cuenten.",
                "fr": "Ne comptez pas les jours, faites en sorte que les jours comptent.",
                "de": "Zähle nicht die Tage, lass die Tage zählen."
            ],
            author: "Muhammad Ali",
            date: Date()
        ),
        Quote(
            id: "14",
            translations: [
                "en": "Either you run the day or the day runs you.",
                "es": "O tú diriges el día o el día te dirige a ti.",
                "fr": "Soit vous dirigez la journée, soit la journée vous dirige.",
                "de": "Entweder du steuerst den Tag oder der Tag steuert dich."
            ],
            author: "Jim Rohn",
            date: Date()
        ),
        Quote(
            id: "15",
            translations: [
                "en": "The only place where success comes before work is in the dictionary.",
                "es": "El único lugar donde el éxito viene antes que el trabajo es en el diccionario.",
                "fr": "Le seul endroit où le succès vient avant le travail est dans le dictionnaire.",
                "de": "Der einzige Ort, an dem Erfolg vor der Arbeit kommt, ist im Wörterbuch."
            ],
            author: "Vidal Sassoon",
            date: Date()
        ),
        Quote(
            id: "16",
            translations: [
                "en": "Success usually comes to those who are too busy to be looking for it.",
                "es": "El éxito suele llegar a quienes están demasiado ocupados para buscarlo.",
                "fr": "Le succès vient généralement à ceux qui sont trop occupés pour le chercher.",
                "de": "Erfolg kommt meist zu denen, die zu beschäftigt sind, um danach zu suchen."
            ],
            author: "Henry David Thoreau",
            date: Date()
        ),
        Quote(
            id: "17",
            translations: [
                "en": "The difference between try and triumph is just a little umph!",
                "es": "¡La diferencia entre intentar y triunfar es solo un pequeño esfuerzo!",
                "fr": "La différence entre essayer et triompher n'est qu'un petit effort !",
                "de": "Der Unterschied zwischen Versuch und Triumph ist nur ein kleines Umph!"
            ],
            author: "Marvin Phillips",
            date: Date()
        ),
        Quote(
            id: "18",
            translations: [
                "en": "The expert in anything was once a beginner.",
                "es": "El experto en cualquier cosa fue una vez principiante.",
                "fr": "L'expert en quoi que ce soit a d'abord été un débutant.",
                "de": "Der Experte in allem war einmal ein Anfänger."
            ],
            author: "Helen Hayes",
            date: Date()
        ),
        Quote(
            id: "19",
            translations: [
                "en": "Focus on the journey, not the destination.",
                "es": "Concéntrate en el viaje, no en el destino.",
                "fr": "Concentrez-vous sur le voyage, pas sur la destination.",
                "de": "Konzentriere dich auf die Reise, nicht auf das Ziel."
            ],
            author: "Greg Anderson",
            date: Date()
        ),
        Quote(
            id: "20",
            translations: [
                "en": "What you do today can improve all your tomorrows.",
                "es": "Lo que haces hoy puede mejorar todos tus mañanas.",
                "fr": "Ce que vous faites aujourd'hui peut améliorer tous vos lendemains.",
                "de": "Was du heute tust, kann all deine Morgen verbessern."
            ],
            author: "Ralph Marston",
            date: Date()
        ),
        Quote(
            id: "21",
            translations: [
                "en": "Small progress is still progress.",
                "es": "Un pequeño progreso sigue siendo progreso.",
                "fr": "Un petit progrès reste un progrès.",
                "de": "Kleiner Fortschritt ist immer noch Fortschritt."
            ],
            author: "Unknown",
            date: Date()
        ),
        Quote(
            id: "22",
            translations: [
                "en": "The only bad workout is the one that didn't happen.",
                "es": "El único mal entrenamiento es el que no sucedió.",
                "fr": "Le seul mauvais entraînement est celui qui n'a pas eu lieu.",
                "de": "Das einzige schlechte Training ist das, das nicht stattgefunden hat."
            ],
            author: "Unknown",
            date: Date()
        ),
        Quote(
            id: "23",
            translations: [
                "en": "Dream big, start small, but most of all, start.",
                "es": "Sueña en grande, empieza pequeño, pero sobre todo, empieza.",
                "fr": "Rêvez grand, commencez petit, mais surtout, commencez.",
                "de": "Träume groß, fange klein an, aber vor allem, fange an."
            ],
            author: "Simon Sinek",
            date: Date()
        ),
        Quote(
            id: "24",
            translations: [
                "en": "Every accomplishment starts with the decision to try.",
                "es": "Todo logro comienza con la decisión de intentarlo.",
                "fr": "Chaque réussite commence par la décision d'essayer.",
                "de": "Jeder Erfolg beginnt mit der Entscheidung, es zu versuchen."
            ],
            author: "Unknown",
            date: Date()
        ),
        Quote(
            id: "25",
            translations: [
                "en": "The harder you work for something, the greater you'll feel when you achieve it.",
                "es": "Cuanto más duro trabajas por algo, mejor te sentirás cuando lo logres.",
                "fr": "Plus vous travaillez dur pour quelque chose, plus vous vous sentirez bien quand vous l'obtiendrez.",
                "de": "Je härter du für etwas arbeitest, desto besser fühlst du dich, wenn du es erreichst."
            ],
            author: "Unknown",
            date: Date()
        ),
        Quote(
            id: "26",
            translations: [
                "en": "Don't stop when you're tired. Stop when you're done.",
                "es": "No te detengas cuando estés cansado. Detente cuando hayas terminado.",
                "fr": "Ne vous arrêtez pas quand vous êtes fatigué. Arrêtez-vous quand vous avez fini.",
                "de": "Hör nicht auf, wenn du müde bist. Hör auf, wenn du fertig bist."
            ],
            author: "Unknown",
            date: Date()
        ),
        Quote(
            id: "27",
            translations: [
                "en": "Success is built on daily habits.",
                "es": "El éxito se construye sobre hábitos diarios.",
                "fr": "Le succès se construit sur des habitudes quotidiennes.",
                "de": "Erfolg baut auf täglichen Gewohnheiten auf."
            ],
            author: "Unknown",
            date: Date()
        ),
        Quote(
            id: "28",
            translations: [
                "en": "Your future is created by what you do today.",
                "es": "Tu futuro se crea por lo que haces hoy.",
                "fr": "Votre avenir est créé par ce que vous faites aujourd'hui.",
                "de": "Deine Zukunft wird durch das geschaffen, was du heute tust."
            ],
            author: "Unknown",
            date: Date()
        ),
        Quote(
            id: "29",
            translations: [
                "en": "Make each day your masterpiece.",
                "es": "Haz de cada día tu obra maestra.",
                "fr": "Faites de chaque jour votre chef-d'œuvre.",
                "de": "Mache jeden Tag zu deinem Meisterwerk."
            ],
            author: "John Wooden",
            date: Date()
        ),
        Quote(
            id: "30",
            translations: [
                "en": "The only way to do great work is to love what you do.",
                "es": "La única manera de hacer un gran trabajo es amar lo que haces.",
                "fr": "La seule façon de faire du bon travail est d'aimer ce que vous faites.",
                "de": "Der einzige Weg, großartige Arbeit zu leisten, ist zu lieben, was man tut."
            ],
        author: "Steve Jobs",
        date: Date()
    )
    ]
    
    static func getTodaysQuote() -> Quote {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let seed = calendar.component(.day, from: today) + 
                  calendar.component(.month, from: today) +
                  calendar.component(.year, from: today)
        
        let index = seed % quotes.count
        var quote = quotes[index]
        quote.date = today
        return quote
    }
} 
