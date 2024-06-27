//
//  ModelContainer.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/12/24.
//

import Foundation
import SwiftData
import OSLog


private func insertToModel<T: PersistentModel>(_ context: ModelContext, _ object: T) {
    context.insert(object)
}

public func ConfigureModelContext() -> ModelContext {
    do {
        var inMemory = false
        
#if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            inMemory = true
        }
#endif
        
        let config = ModelConfiguration(for: VocabWord.self, Story.self, isStoredInMemoryOnly: inMemory)
        let container = try ModelContainer(for: VocabWord.self, Story.self, migrationPlan: LexelMigrationPlan.self, configurations: config)
        
        let context = ModelContext(container)
        context.autosaveEnabled = true
        
#if DEBUG
        if CommandLine.arguments.contains("populate") {
            
            let objects: [any PersistentModel] = [
                VocabWord(word: "mein", language: "de-DE", def: "my"),
                VocabWord(word: "hund", language: "de-DE", def: "dog"),
                VocabWord(word: "hallo", language: "de-DE", def: "Hello", fam: 3),
                VocabWord(word: "dieses", language: "de-DE", def: "This", fam: 4),
                VocabWord(word: "ist", language: "de-DE", def: "is"),
                VocabWord(word: "jeder", language: "de-DE", def: "every"),
                VocabWord(word: "klingen", language: "de-DE", def: "sound", fam: 3),
                VocabWord(word: "noch", language: "de-DE", def: "to", fam: 2),
                VocabWord(word: "sie", language: "de-DE", def: "they", fam: 3),
                VocabWord(word: "sich", language: "de-DE", def: "himself", fam: 1),
                
                
                
                Story(title: "Der Hund", text: "Hallo, dieses ist mein Hund. Genau.", language: LexelLanguage("German","de-DE")),
                Story(title: "Der Hund 2", text: "Das ist ein big sequel", language: LexelLanguage("German","de-DE")),
                Story(title: "Der Zaunkönig - Brüder Grimm", text:
"""
In den alten Zeiten, da hatte jeder Klang noch Sinn und Bedeutung. Wenn der Hammer des Schmieds ertönte, so rief er: "Smiet mi to! Smiet mi to!" Wenn der Hobel des Tischlers schnarrte, so sprach er: "Dor häst! Dor, dor häst!" Fing das Räderwerk der Mühle an zu klappern, so sprach es: "Help, Herr Gott! Help, Herr Gott!," und war der Müller ein Betrüger und ließ die Mühle an, so sprach sie hochdeutsch und fragte erst langsam: "Wer ist da? Wer ist da?," dann antwortete sie schnell: "Der Müller! Der Müller!," und endlich ganz geschwind: "Stiehlt tapfer, stiehlt tapfer, vom Achtel drei Sechter."

Zu dieser Zeit hatten auch die Vögel ihre eigene Sprache, die jedermann verstand, jetzt lautet es nur wie ein Zwitschern, Kreischen und Pfeifen und bei einigen wie Musik ohne Worte. Es kam aber den Vögeln in den Sinn, sie wollten nicht länger ohne Herrn sein und einen unter sich zu ihrem König wählen. Nur einer von ihnen, der Kiebitz, war dagegen; frei hatte er gelebt, und frei wollte er sterben, und angstvoll hin und her fliegend rief er: "Wo bliew ick? Wo bliew ick?" Er zog sich zurück in einsame und unbesuchte Sümpfe und zeigte sich nicht wieder unter seinesgleichen.

Die Vögel wollten sich
""", language: LexelLanguage("German","de-DE")),
                Story(title: "Der gestiefelte Kater", text:
"""
Es war einmal ein Müller, der hatte drei Söhne, seine Mühle, einen Esel und einen Kater; die Söhne mußten mahlen, der Esel Getreide holen und Mehl forttragen, die Katze dagegen die Mäuse wegfangen. Als der Müller starb, teilten sich die drei Söhne in die Erbschaft: der älteste bekam die Mühle, der zweite den Esel, der dritte den Kater; weiter blieb nichts für ihn übrig. Da war er traurig und sprach zu sich selbst: "Mir ist es doch recht schlimm ergangen, mein ältester Bruder kann mahlen, mein zweiter auf seinem Esel reiten - was kann ich mit dem Kater anfangen? Ich laß mir ein Paar Pelzhandschuhe aus seinem Fell machen, dann ist's vorbei."

"Hör," fing der Kater an, der alles verstanden hatte, "du brauchst mich nicht zu töten, um ein Paar schlechte Handschuhe aus meinem Pelz zu kriegen; laß mir nur ein Paar Stiefel machen, daß ich ausgehen und mich unter den Leuten sehen lassen kann, dann soll dir bald geholfen sein." Der Müllersohn verwunderte sich, daß der Kater so sprach, weil aber eben der Schuster vorbeiging, rief er ihn herein und ließ ihm die Stiefel anmessen. Als sie fertig waren, zog sie der Kater an, nahm einen Sack, machte dessen Boden voll Korn, band aber eine Schnur drum, womit man ihn zuziehen konnte, dann warf er ihn über den Rücken und ging auf zwei Beinen, wie ein Mensch, zur Tür hinaus.

Damals regierte ein König im Land, der aß so gerne Rebhühner: es war aber eine Not, daß keine zu kriegen waren. Der ganze Wald war voll, aber sie waren so scheu, daß kein Jäger sie erreichen konnte. Das wußte der Kater, und gedachte seine Sache besserzumachen; als er in den Wald kam, machte er seinen Sack auf, breitete das Korn auseinander, die Schnur aber legte er ins Gras und leitete sie hinter eine Hecke. Da versteckte er sich selber, schlich herum und lauerte. Die Rebhühner kamen bald gelaufen, fanden das Korn - und eins nach dem andern hüpfte in den Sack hinein. Als eine gute Anzahl drinnen war, zog der Kater den Strick zu, lief herbei und drehte ihnen den Hals um; dann warf er den Sack auf den Rücken und ging geradewegs zum Schloß des Königs. Die Wache rief. "Halt! Wohin?" - "Zum König!" antwortete der Kater kurzweg. "Bist du toll, ein Kater und zum König?" - "Laß ihn nur gehen," sagte ein anderer, "der König hat doch oft Langeweile, vielleicht macht ihm der Kater mit seinem Brummen und Spinnen Vergnügen." Als der Kater vor den König kam, machte er eine tiefe Verbeugung und sagte: "Mein Herr, der Graf" - dabei nannte er einen langen und vornehmen Namen - "läßt sich dem Herrn König empfehlen und schickt ihm hier Rebhühner"; wußte der sich vor Freude nicht zu fassen und befahl dem Kater, soviel Gold aus der Schatzkammer in seinen Sack zu tun, wie er nur tragen könne: "Das bringe deinem Herrn, und danke ihm vielmals für sein Geschenk."

Der arme Müllersohn aber saß zu Haus am Fenster, stützte den Kopf auf die Hand und dachte, daß er nun sein letztes Geld für die Stiefel des Katers weggegeben habe, und der ihm wohl nichts besseres dafür bringen könne. Da trat der Kater herein, warf den Sack vom Rücken, schnürte ihn auf und schüttete das Gold vor den Müller hin: "Da hast du etwas Gold vom König, der dich grüßen läßt und sich für die Rebhühner bei dir bedankt." Der Müller war froh über den Reichtum, ohne daß er noch recht begreifen konnte, wie es zugegangen war. Der Kater aber, während er seine Stiefel auszog, erzählte ihm alles; dann sagte er: "Du hast jetzt zwar Geld genug, aber dabei soll es nicht bleiben; morgen ziehe ich meine Stiefel wieder an, dann sollst du noch reicher werden; dem König habe ich nämlich gesagt, daß du ein Graf bist." Am andern Tag ging der Kater, wie er gesagt hatte, wohl gestiefelt, wieder auf die Jagd, und brachte dem König einen reichen Fang. So ging es alle Tage, und der Kater brachte alle Tage Gold heim und ward so beliebt beim König, daß er im Schlosse ein- und ausgehen durfte. Einmal stand der Kater in der Küche des Schlosses beim Herd und wärmte sich, da kam der Kutscher und fluchte: "Ich wünsche,
""", language: LexelLanguage("German","de-DE")),
                Story(title: "Die Bremer Stadtmusikanten", text:
"""
Es war einmal ein Mann, der hatte einen Esel, welcher schon lange Jahre unverdrossen die Säcke in die Mühle getragen hatte. Nun aber gingen die Kräfte des Esels zu Ende, so dass er zur Arbeit nicht mehr taugte. Da dachte der Herr daran, ihn wegzugeben. Aber der Esel merkte, dass sein Herr etwas Böses im Sinn hatte, lief fort und machte sich auf den Weg nach Bremen. Dort, so meinte er, könnte er ja Stadtmusikant werden.

Als er schon eine Weile gegangen war, fand er einen Jagdhund am Wege liegen, der jämmerlich heulte. „Warum heulst du denn so, Pack an?“ fragte der Esel.

„Ach“, sagte der Hund, „weil ich alt bin, jeden Tag schwächer werde und auch nicht mehr auf die Jagd kann, wollte mich mein Herr totschießen. Da hab ich Reißaus genommen. Aber womit soll ich nun mein Brot verdienen?“

„Weißt du, was“, sprach der Esel, „ich gehe nach Bremen und werde dort Stadtmusikant. Komm mit mir und lass dich auch bei der Musik annehmen. Ich spiele die Laute, und du schlägst die Pauken.“

Der Hund war einverstanden, und sie gingen mitsammen weiter. Es dauerte nicht lange, da sahen sie eine Katze am Wege sitzen, die machte ein Gesicht wie drei Tage Regenwetter. „Was ist denn dir in die Quere gekommen, alter Bartputzer?“ fragte der Esel.

„Wer kann da lustig sein, wenn's einem an den Kragen geht“, antwortete die Katze. „Weil ich nun alt bin, meine Zähne stumpf werden und ich lieber hinter dem Ofen sitze und spinne, als nach Mäusen herumjage, hat mich meine Frau ersäufen wollen. Ich konnte mich zwar noch davonschleichen, aber nun ist guter Rat teuer. Wo soll ich jetzt hin?“

„Geh mit uns nach Bremen! Du verstehst dich doch auf die Nachtmusik, da kannst du Stadtmusikant werden.“

Die Katze hielt das für gut und ging mit. Als die drei so miteinander gingen, kamen sie an einem Hof vorbei. Da saß der Haushahn auf dem Tor und schrie aus Leibeskräften. „Du schreist einem durch Mark und Bein“, sprach der Esel, „was hast du vor?“

„Die Hausfrau hat der Köchin befohlen, mir heute Abend den Kopf abzuschlagen. Morgen, am Sonntag, haben sie Gäste, da wollen sie mich in der Suppe essen. Nun schrei ich aus vollem Hals, solang ich noch kann.“

„Ei was“ sagte der Esel, „zieh lieber mit uns fort, wir gehen nach Bremen, etwas Besseres als den Tod findest du überall. Du hast eine gute Stimme, und wenn wir mitsammen musizieren, wird es gar herrlich klingen.“ Dem Hahn gefiel der Vorschlag, und sie gingen alle vier mitsammen fort.

Sie konnten aber die Stadt Bremen an einem Tag nicht erreichen und kamen abends in einen Wald, wo sie übernachten wollten. Der Esel und der Hund legten sich unter einen großen Baum, die Katze kletterte auf einen Ast, und der Hahn flog bis in den Wipfel, wo es am sichersten für ihn war.

 Ehe er einschlief, sah er sich noch einmal nach allen vier Windrichtungen um. Da bemerkte er einen Lichtschein. Er sagte seinen Gefährten, dass in der Nähe ein Haus sein müsse, denn er sehe ein Licht. Der Esel antwortete: „So wollen wir uns aufmachen und noch hingehen, denn hier ist die Herberge schlecht.“ Der Hund meinte, ein paar Knochen und etwas Fleisch daran täten ihm auch gut.

Also machten sie sich auf den Weg nach der Gegend, wo das Licht war. Bald sahen sie es heller schimmern, und es wurde immer größer, bis sie vor ein hellerleuchtetes Räuberhaus kamen. Der Esel, als der größte, näherte sich dem Fenster und schaute hinein.

„Was siehst du, Grauschimmel?“ fragte der Hahn.

„Was ich sehe?“ antwortete der Esel. „Einen gedeckten Tisch mit schönem Essen und Trinken, und Räuber sitzen rundherum und lassen sich's gut gehen!“

„Das wäre etwas für uns“, sprach der Hahn.

Da überlegten die Tiere, wie sie es anfangen könnten, die Räuber hinauszujagen. Endlich fanden sie ein Mittel. Der Esel stellte sich mit den Vorderfüßen auf das Fenster, der Hund sprang auf des Esels Rücken, die Katze kletterte auf den Hund, und zuletzt flog der Hahn hinauf und setzte sich der Katze auf den Kopf. Als das geschehen war, fingen sie auf ein Zeichen an, ihre Musik zu machen: der Esel schrie, der Hund bellte, die Katze miaute, und der Hahn krähte. Darauf stürzten sie durch das Fenster in die Stube hinein, dass die Scheiben klirrten.

Die Räuber fuhren bei dem entsetzlichen Geschrei in die Höhe. Sie meinten, ein Gespenst käme herein, und flohen in größter Furcht in den Wald hinaus.

Nun setzten sich die vier Gesellen an den Tisch, und jeder aß nach Herzenslust von den Speisen, die ihm am besten schmeckten.

Als sie fertig waren, löschten sie das Licht aus, und jeder suchte sich eine Schlafstätte nach seinem Geschmack. Der Esel legte sich auf den Mist, der Hund hinter die Tür, die Katze auf den Herd bei der warmen Asche, und der Hahn flog auf das Dach hinauf. Und weil sie müde waren von ihrem langen Weg, schliefen sie bald ein.

Als Mitternacht vorbei war und die Räuber von weitem sahen, dass kein Licht mehr im Haus brannte und alles ruhig schien, sprach der Hauptmann: „Wir hätten uns doch nicht sollen ins Bockshorn jagen lassen.“ Er schickte einen Räuber zurück.

""", language: LexelLanguage("German","de-DE")),
            ]

            for obj in objects {
                context.insert(obj)
            }
            
            try! context.save()
        }
#endif
        
        return context
    } catch {
        os_log("\(error.localizedDescription)")
        fatalError("Failed to initialize model container")
    }
}
