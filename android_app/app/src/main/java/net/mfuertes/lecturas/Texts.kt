package net.mfuertes.lecturas

import java.util.Date

data class Texts(
    val date: Date?,
    val first: String,
    val firstIndex: String,
    val second: String?,
    val secondIndex: String?,
    val psalm: String,
    val psalmIndex: String,
    val psalmResponse: String,
    val gospel: String,
    val gospelIndex: String,
    val from: String
    )