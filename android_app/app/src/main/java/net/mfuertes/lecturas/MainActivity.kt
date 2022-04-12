package net.mfuertes.lecturas

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.lifecycle.ViewModelProvider
import kotlinx.coroutines.launch
import net.mfuertes.lecturas.parsers.BuigleParser
import net.mfuertes.lecturas.ui.theme.MyApplicationTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //val customerViewModel = ViewModelProvider(this).get(TextsViewModel::class.java)
        setContent {
            MyApplicationTheme {
                // A surface container using the 'background' color from the theme
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colors.background) {
                    Scaffold(
                        bottomBar = {BottomAppBar(content = {Text("Prueba")})}
                    ) {
                        Greeting("Android")
                    }

                }
            }
        }
    }
}

@Composable
fun Greeting(name: String, model: TextsViewModel = TextsViewModel(BuigleParser())) {
    LaunchedEffect(Unit, block = {
        model.getTexts()
    })
    if(model.hasData.value){
        model.getTexts.value?.first?.let { Text(text = it) }
    }

}

@Composable
fun F(model: TextsViewModel = TextsViewModel(BuigleParser())) {
    // Returns a scope that's cancelled when F is removed from composition
    val coroutineScope = rememberCoroutineScope()

    val (texts, setTexts) = remember { mutableStateOf<Texts?>(null) }

    val getLocationOnClick: () -> Unit = {
        coroutineScope.launch {
            val texts = model.getTexts()
        }
    }

    Button(onClick = getLocationOnClick) {
        Text("detectLocation")
    }
}