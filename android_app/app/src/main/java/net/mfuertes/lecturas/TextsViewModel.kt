package net.mfuertes.lecturas

import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import net.mfuertes.lecturas.parsers.BuigleParser
import net.mfuertes.lecturas.parsers.Parser
import java.util.Date

class TextsViewModel: ViewModel() {
    private var _texts: MutableLiveData<Texts> = MutableLiveData<Texts>()
    var texts: LiveData<Texts> = _texts

    private var _date: MutableLiveData<Date>  = MutableLiveData<Date>()
    var date : LiveData<Date> = _date

    fun getTexts(provider: Parser = BuigleParser(), date: Date = Date()): LiveData<Texts>{
        viewModelScope.launch {
            withContext(Dispatchers.IO){
                _texts.postValue(provider.get(date))
            }
        }
        return texts;
    }
}