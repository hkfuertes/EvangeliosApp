package net.mfuertes.lecturas.parsers

import android.app.Activity
import net.mfuertes.lecturas.Texts
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import org.jsoup.select.Elements
import java.io.ByteArrayInputStream
import java.io.IOException
import java.net.URL
import java.nio.charset.Charset
import java.time.LocalDateTime
import java.util.*
import java.util.zip.GZIPInputStream

abstract class Parser {
    fun getOnUI(context: Activity, callback: (text: Texts) -> Unit) {
        Thread(Runnable {
            val stringBuilder = StringBuilder()
            try {
                val texts = parse(getHtml(getUrl(Date())))
                context.runOnUiThread { callback(texts) }
            } catch (e: IOException) {
                stringBuilder.append("Error : ").append(e.message).append("\n")
            }

        }).start()
    }

    fun get(date: Date): Texts = parse(getHtml(getUrl(date)));

    abstract fun parse(body: String): Texts
    abstract fun getUrl(date: Date): String
    abstract fun getProviderNameForDisplay(): String

    private fun getHtml(url: String): String {
        return URL(url)
            .readText(charset = Charset.forName("ISO-8859-1"));
    }
}