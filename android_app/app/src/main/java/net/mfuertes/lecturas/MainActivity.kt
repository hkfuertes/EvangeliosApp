package net.mfuertes.lecturas

import android.os.Bundle
import android.widget.ListView
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.lifecycle.ViewModelProvider
import kotlinx.coroutines.launch
import net.mfuertes.lecturas.parsers.BuigleParser
import net.mfuertes.lecturas.ui.theme.MyApplicationTheme
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MyApplicationTheme {
                // A surface container using the 'background' color from the theme
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colors.background) {
                    App()

                }
            }
        }
    }
}

@Composable
fun App(){
    val viewModel = remember {
        TextsViewModel()
    }
    val date = Date()
    viewModel.getTexts(BuigleParser(), date)
    val texts by viewModel.texts.observeAsState()

    Scaffold(
        bottomBar = {BottomAppBar(content = {Text(SimpleDateFormat("dd/MM/yyyy").format(date))})}
    ) {
        TextsWidget(texts = texts)
    }
}

@Composable
fun TextsWidget(texts: Texts?){
    val scrollstate = rememberScrollState()
    if(texts!= null){
        Column(
            modifier = Modifier.verticalScroll(scrollstate)
        ){
            Text(text= texts!!.firstIndex)
            Text(text= texts!!.first)
            Divider()
            texts!!.secondIndex?.let { Text(text= it) }
            texts!!.second?.let { Text(text= it) }
            texts!!.second?.let { Divider() }
            Text(text= texts!!.psalmIndex)
            Text(text= texts!!.psalmResponse)
            Text(text= texts!!.psalm)
            Divider()
            Text(text= texts!!.gospelIndex)
            Text(text= texts!!.gospel)
        }
    }
}
