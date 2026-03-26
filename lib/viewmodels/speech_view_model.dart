import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechViewModel extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _currentLocale = 'en_US'; // Default to English
  String _lastWords = '';

  bool get isListening => _isListening;
  String get currentLocale => _currentLocale;
  String get lastWords => _lastWords;
  bool get speechEnabled => _speechEnabled;
  String get localeName => _currentLocale == 'en_US' ? 'English' : 'Urdu';

  SpeechViewModel() {
    _initSpeech();
  }

  /// Initialize speech recognition
  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        debugPrint('Speech status: $status');
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
          notifyListeners();
        }
      },
      onError: (error) {
        debugPrint('Speech error: $error');
        _isListening = false;
        notifyListeners();
      },
    );
    notifyListeners();
  }

  Future<void> toggleListening(Function(String) onResult) async {
    if (_isListening) {
      await stopListening();
    } else {
      await startListening(onResult);
    }
  }

  Future<void> startListening(Function(String) onResult) async {
    if (!_speechEnabled) {
      await _initSpeech();
    }

    if (_speechEnabled) {
      _isListening = true;
      _lastWords = '';
      notifyListeners();

      await _speechToText.listen(
        onResult: (result) => _onSpeechResult(result, onResult),
        localeId: _currentLocale,
        listenOptions: SpeechListenOptions(
          cancelOnError: true,
          listenMode: ListenMode.deviceDefault,
        ),
      );
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    _isListening = false;
    notifyListeners();
  }

  void toggleLocale() {
    _currentLocale = (_currentLocale == 'en_US') ? 'ur_PK' : 'en_US';
    notifyListeners();
  }

  void _onSpeechResult(
    SpeechRecognitionResult result,
    Function(String) onResult,
  ) {
    _lastWords = result.recognizedWords;
    if (result.finalResult) {
      onResult(_lastWords);
      _isListening = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }
}
