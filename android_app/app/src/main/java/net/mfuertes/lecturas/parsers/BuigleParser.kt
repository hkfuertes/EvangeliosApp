package net.mfuertes.lecturas.parsers

import net.mfuertes.lecturas.Texts
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import org.jsoup.select.Elements
import java.text.SimpleDateFormat
import java.util.*

class BuigleParser : Parser() {
    override fun parse(body: String): Texts {
        val doc: Document = Jsoup.connect("http://www.tutorialspoint.com/").get()
        val text: String = doc.select("table.texto2 tbody tr td div")[1].select("div")[0].html()

        /*************/
        var chunk = body.split("PRIMERA LECTURA")[1];
        var firstParts = chunk
            .split("SALMO RESPONSORIAL")[0]
            .replace("<br>", "\n")
            .trim()
            .split("\n")
            .filter { it.isNotBlank() && it.isNotEmpty() }
        chunk = chunk.split("SALMO RESPONSORIAL")[1];
        var psalmParts = chunk
            .split("Versículo")[0]
            .replace("<br>", "\n")
            .trim()
            .split("\n")
            .filter { it.isNotEmpty() && it.isNotBlank() }
        var godspelParts = chunk
            .split("EVANGELIO")[1]
            .replace("<br>", "\n")
            .trim()
            .split("\n")
            .filter { it.isNotBlank() && it.isNotEmpty() }

        var sTest = psalmParts.joinToString("\n").split("SEGUNDA LECTURA");
        var secondParts: List<String>? = null
        if (sTest.count() > 1) {
            secondParts = sTest[1].split("\n").filter { it.isNotEmpty() && it.isNotBlank() }
        }

        return Texts(
            date = null,
            from = getProviderNameForDisplay(),
            second = secondParts?.subList(2, secondParts.count())?.joinToString("\n"),
            secondIndex = secondParts?.get(1)?.trim(),
            first = firstParts.subList(2, firstParts.count()).joinToString("\n"),
            firstIndex = firstParts[1].trim(),
            psalm = psalmParts.subList(2, psalmParts.count())
                .joinToString("\n")
                .split("SEGUNDA LECTURA")[0]
                .trim()
                .replace("R.", "\n"),
            psalmIndex = "Salmo " + psalmParts[0].trim(),
            psalmResponse = psalmParts[1].replace("R.", "").trim(),
            gospel = godspelParts.subList(2, godspelParts.count()).joinToString("\n"),
            gospelIndex = godspelParts[1].trim()
        );
    }

    override fun getUrl(date: Date): String {
        val dateString = SimpleDateFormat("yyyyMMdd").format(date)
        return "https://www.buigle.net/detalle_modulo.php?s=1&sec=7&fecha=$dateString"
    }

    override fun getProviderNameForDisplay(): String {
        return "Buigle";
    }
}