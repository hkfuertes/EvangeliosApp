package net.mfuertes.lecturas.parsers

import android.app.Activity
import net.mfuertes.lecturas.Texts
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import org.jsoup.select.Elements
import java.io.IOException
import java.net.URL
import java.time.LocalDateTime
import java.util.*

abstract class Parser {
    fun getOnUI(context: Activity, callback: (text: Texts)->Unit) {
        Thread(Runnable {
            val stringBuilder = StringBuilder()
            try {
                val texts = parse(getHtml(getUrl(Date())))
                context.runOnUiThread{callback(texts)}
            } catch (e: IOException) {
                stringBuilder.append("Error : ").append(e.message).append("\n")
            }

        }).start()
    }

    fun get(): Texts = parse(getHtml(getUrl(Date())));

    abstract fun parse(body: String): Texts
    abstract fun getUrl(date: Date): String
    abstract fun getProviderNameForDisplay(): String

    private fun getHtml(url: String): String {
        return URL(url).readText();
    }
}