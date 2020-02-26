function WebSearch {
    param (
        [string]$term
    )

    $ie = New-Object -com InternetExplorer.Application -ErrorAction Stop;
    # set visible true
    $ie.Visible = $true;
    # dont search until browser is ready
    while ($ie.Busy) { Start-Sleep -Milliseconds 1; }
    # naviagte to google, appending query
    $ie.Navigate("http://www.google.com/search?q=$($term)");   
}

# not in use currrently
function _startProc {
    param (
        [string]$param
    )
    $param = $param.ToLower();
    switch -regex ($param) {
        { $param -Match ".*(visual studio| visual).*" } {
            Start-Process -FilePath "devenv.exe";
        }
        { $param -Match ".*(code).*" } {
            Start-Process -FilePath "code";
        }
        { $param -Match ".*(notes|note|notepad|t x t|text).*" } {
            Start-Process -FilePath "notepad";
        }
        { $param -Match ".*(chrome|google).*" } {
            Start-Process -FilePath "chrome";
        }
        { $param -Match ".*(file|files).*" } {
            Start-Process -FilePath "explorer";
        }
        { $param -Match ".*(internet).*" } {
            Start-Process -FilePath "iexplore.exe";
        }
        Default {
            $temp = $matches[0].replace("process", "");
            $temp = $temp.trim();
            Start-Process -FilePath "$($temp)";
        }
    }
}

function StartProc {
    param (
        [string]$Command
    )
    add-type -AssemblyName System.Windows.Forms
    Set-Clipboard -Value $Command
    [System.Windows.Forms.SendKeys]::SendWait("^{ESC}")
    start-sleep -Milliseconds 300
    [System.Windows.Forms.SendKeys]::SendWait("^{v}")
    start-sleep -Milliseconds 300
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}

function PsuedoWebSearch {
    param (
        [string]$query
    )
    # format search term
    $term = $query.Replace(" ", "+")
    # add forms type
    add-type -AssemblyName System.Windows.Forms
    # start chrome
    Start-Process -FilePath "chrome";
    # wait for chrome to load
    start-sleep 2
    # set url
    $url = "https://www.google.com/search?q=${term}&rlz=1C1GCEA_enUS872US872&oq=${term}&aqs=chrome.0.69i59j0l6j69i60.1727j0j7&sourceid=chrome&ie=UTF-8";
    # set the value of the query to the clipboard
    Set-Clipboard -Value $url
    # paste into search bar
    [System.Windows.Forms.SendKeys]::SendWait("^{v}")
    # hit enter (search)
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}

function SimulateYoutube {
    param (
        [string]$term
    )
    # format search term
    $term = $term.Replace(" ", "+")
    # add forms type
    add-type -AssemblyName System.Windows.Forms
    # start chrome
    Start-Process -FilePath "chrome";
    # wait for chrome to load
    start-sleep 2
    # set the value of the query to the clipboard
    Set-Clipboard -Value "https://www.youtube.com/results?search_query=${term}"
    # paste into search bar
    [System.Windows.Forms.SendKeys]::SendWait("^{v}")
    # hit enter (search)
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    # wait for page to load
    start-sleep 2
    # tab to first result
    [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
    # click first result
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}