library flutter_speak;

import 'package:flutter/material.dart';
import 'package:flutter_tts_plugin/flutter_tts_plugin.dart';

class FlutterSpeak {

  String language;
  Function(bool status, String text) onPlay;
  Function(bool status) onComplete;
  Function(bool status, String message) onError;
  double speechRate;
  double speechVolume;
  double speechPitch;

  FlutterSpeak({@required this.language,
    this.onPlay,
    this.onComplete,
    this.onError,
    this.speechRate,
    this.speechVolume,
    this.speechPitch
  });

  FlutterTts flutterTts;

  String textSpeech;
  bool isSpeech = false;
  double volume;
  double pitch;
  double rate;

  // setup parameter
  _setupParam(){
    volume = this.speechVolume == null ? 0.5 : this.speechVolume;
    pitch = this.speechPitch == null ? 1.0 : this.speechPitch;
    rate = this.speechRate == null ? 0.5 : this.speechRate;
  }

  initTts() async {
    // init parameter
    _setupParam();
    // init tts
    flutterTts = FlutterTts();

    await flutterTts.setLanguage(this.language);

    await flutterTts.setSpeechRate(rate);

    await flutterTts.setVolume(volume);

    await flutterTts.setPitch(pitch);

    flutterTts.setStartHandler(() {
      print("playing");
      isSpeech = true;
      if(this.onPlay != null && this.textSpeech != null)
        this.onPlay(isSpeech, textSpeech);
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      isSpeech = false;

      if(this.onComplete != null)
        this.onComplete(isSpeech);

    });

    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      isSpeech = false;
      if(this.onError != null)
        this.onError(isSpeech,msg);
    });
  }

  Future speak({String text}) async {
    if (text != null) {
      if (text.isNotEmpty) {
        // set global text
        textSpeech = text;
        var result = await flutterTts.speak(text);
        if (result == 1){
          // isSpeech = true;
          print("play");
        }
      }
    }
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1){
      // isSpeech = false;
      print("stop");
    }
  }
}