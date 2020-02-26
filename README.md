# PowerShellJarvis
dotnet speech synthesis / recognition script for executing simple commands

# Running

```powershell
.\runJarvis
```

# Common Commands / Requests

These are regex commands, so these are just the basic keywords that need to be hit to fire a specific request. Fore example saying: `"jarvis please tell me what time it is"` will work the same way as saying `"whats the time right now?"` If Jarvis cant find an answer, it will ask if you want to search the internet for the request.

Basic Regex keywords: 
```
what time/date is it 
whats the date/time
```

```
whats jarvis?
what does jarvis mean/stand for
```

```
jarvis open program/process
jarvis start process/program
```

```
jarvis play music/song
```

```
jarvis search/google/internet
```

```
end/goodbye/stop/exit jarvis
```