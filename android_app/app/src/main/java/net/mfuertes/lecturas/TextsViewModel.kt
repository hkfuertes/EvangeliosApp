package net.mfuertes.lecturas

import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import net.mfuertes.lecturas.parsers.Parser

class TextsViewModel(var provider: Parser): ViewModel() {
    val hasData = mutableStateOf(false);
    private var _getTexts: MutableLiveData<Texts> = MutableLiveData<Texts>()
    var getTexts: LiveData<Texts> = _getTexts

    fun getTexts(){
        viewModelScope.launch {
            hasData.value = true
            _getTexts.value = provider.get()
        }
    }
}