add-type -assemblyname system.speech 
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Speech");

$jarvis = New-Object System.Speech.Synthesis.SpeechSynthesizer 
##Setup the speaker, this allows the computer to talk
$speaker = [System.Speech.Synthesis.SpeechSynthesizer]::new();
$speaker.SelectVoice("Microsoft Zira Desktop");
##Setup the Speech Recognition Engine, this allows the computer to listen
$speechRecogEng = [System.Speech.Recognition.SpeechRecognitionEngine]::new();

$jarvis.speak("today's date is $(Get-Date)")
$jarvis.Dispose()

##Setup the verbal commands hello and exit
$grammar = [System.Speech.Recognition.GrammarBuilder]::new();
$grammar2 = [System.Speech.Recognition.GrammarBuilder]::new();
$grammar.Append("hello");
$grammar2.Append("exit");
$speechRecogEng.LoadGrammar($grammar);
$speechRecogEng.LoadGrammar($grammar2);

$speechRecogEng.InitialSilenceTimeout = 15
$speechRecogEng.SetInputToDefaultAudioDevice();
$cmdBoolean = $false;

while (!$cmdBoolean) {
    $speechRecognize = $speechRecogEng.Recognize();
    $conf = $speechRecognize.Confidence;
    $myWords = $speechRecognize.text;
    if ($myWords -match "hello" -and [double]$conf -gt 0.85) {
        $speaker.Speak("Hello");
    }
    if ($myWords -match "exit" -and [double]$conf -gt 0.85) {
        $speaker.Speak("Goodbye");
        $cmdBoolean = $true;
    }
}