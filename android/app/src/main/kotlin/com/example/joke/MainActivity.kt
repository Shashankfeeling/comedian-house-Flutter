package com.example.joke

import io.flutter.embedding.android.FlutterActivity
implementation 'app.alan:sdk:4.11.0'


class MainActivity: FlutterActivity() {
    private var alanButton: AlanButton? = null

...

/// Define the project key
val config = AlanConfig.builder().setProjectId("3d49e2991d3db6e4add2bf1487552dd42e956eca572e1d8b807a3e2338fdd0dc/stage").build()
alanButton = findViewById(R.id.alan_button)
alanButton?.initWithConfig(config)

val alanCallback: AlanCallback = object : AlanCallback() {
  /// Handle commands from Alan Studio
  override fun onCommand(eventCommand: EventCommand) {
    try {
      val command = eventCommand.data
      val commandName = command.getJSONObject("data").getString("command")
      Log.d("AlanButton", "onCommand: commandName: $commandName")
    } catch (e: JSONException) {
      Log.e("AlanButton", e.message)
    }
  }
};
alanButton.registerCallback(alanCallback);
}
