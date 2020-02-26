# load responses variables / functions
. ".\responses.ps1"
# gives us SimulateYoutube / WebSearch / StartProc
. ".\utilities.ps1"

# add speech system
add-type -assemblyname system.speech;
# instantiate jarvis object
$jarvis = New-Object System.Speech.Synthesis.SpeechSynthesizer;

# select voice
$jarvis.SelectVoice('Microsoft David Desktop');
# log voice selection data
$jarvis.Voice;
# set volume
$jarvis.Volume = 100;
# set rate of speech
$jarvis.Rate = 0;

function say {
    param ([string]$phrase)
    $jarvis.speak($phrase);
}

# set run loop to true
$run = $TRUE;
$greet = $TRUE;

# while loop is set to tru
while ($run) {
    # greet user once
    if ($greet) {
        say($hi);
        $greet = $FALSE;
    }
    # prompt for command (interfaced into tts later)
    $prompt = Read-Host 'say something';
    $prompt = $prompt.trim();
    # switch case for command regex
    switch -regex ($prompt) {
        # explain name
        { $prompt -Match ".*(who|what|does).*(jarvis|is).*(mean|stand for|jarvis).*" } { say($whoAmI); }
        # inspirational quote
        "inspire" { say($inspire); }
        # list top 5 processes that are taking most memory
        { $prompt -Match "Diagnostics" } {
            # get top 5 processes
            $a = Get-Process | where-object {$_.mainwindowhandle -ne 0} | Sort-Object -Descending WS | Select-Object -first 5;
            say("Your heaviest processes currently running are");
            # loop through processes and record the name and size
            foreach ($proc in $a) {
                # round to second decimal place
                $temp = [Math]::Round($proc.WS*0.000001, 2)
                say("$($proc.ProcessName) at $($temp) megabytes");
            }
        }
        # date / time
        { $prompt -Match ".*(what).*(time|date).*" } { say($date); }
        # play music on youtube
        { $prompt -Match ".*(jarvis).*(play|search|look).*(music|song).*" } { 
            say("What song do you want me to look up");
            $songResp = Read-Host 'song / music';
            try {
                say("Let me see what I can find");
                SimulateYoutube $songResp;
            }
            catch {
                say("It seems like something went wrong");
            }
        }
        # search internet
        { $prompt -Match ".*(jarvis).*(search|google|internet).*" } { 
            say("what shall I search");
            $query = Read-Host 'search internet';
            say("finding results");
            PsuedoWebSearch $query
        }
        # for starting apps
        { $prompt -Match ".*(jarvis).*(start|open).*(process|program).*" } {
            say("What do you want to open?");
            $procResp = Read-Host 'app / folder / program';
            try {
                say("opening now");
                StartProc $procResp
            }
            catch {
                say("It seems like something went wrong");
            }
        }
        # lock desktop
        { $prompt -Match ".*(lock|close).*(screen|monitor|computer|desktop)" } {
            # lock window
            rundll32.exe user32.dll,LockWorkStation;
        }
        # turn off jarvis / break loop
        { $prompt -Match ".*(end|exit|stop|bye|goodnight|sleep).*(jarvis).*" } {
            say($bye);
            # end voice lifecycle
            $jarvis.Dispose();
            # break loop
            $run = $FALSE;
        }
        # default answer for not knowing command
        Default {
            say($default);
            $webSer = Read-Host 'search internet for this?';
            # search if positive response
            if ($webSer -Match ".*(yes|yeah|yup|sure|ok|alright).*") {
                say("right away");
                # open new internet tab
                WebSearch $prompt;
            }
            else {
                say("very well");
            }
        }
    }
}