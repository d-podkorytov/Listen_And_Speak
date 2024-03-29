#OBJECTIVE:
# Learning for Listening, Reading and Repeating from file Input.txt. Actually it is a Book in TXT format.
#
#---------------------

Function New-TextToSpeechMessage {
<#
.SYNOPSIS
    This will use Powershell to have a file Input.txt read out loud through your computer speakers.
 
 
.NOTES
    Name: ListenAndSpeak
    Author: Dmitrii Podkorytov
    Version: 1.0
    DateCreated: 2021-Feb-28
    DateEdited:  2023-Dec-10
 
.LINK
    https://github.com/d-podkorytov/Listen_And_Speak/blob/main/
 
.EXAMPLE
    
#>
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
 
        [string]    $Message,
 
 
        [Parameter(
            Position = 1,
            Mandatory = $false
        )]
 
        [ValidateSet('David', 'Zira','Irina','Hazel','Mark')]
        [string]    $Voice = 'David'
    )
 
    BEGIN {
        if (-not ([appdomain]::currentdomain.GetAssemblies() | Where-Object {$_.Location -eq 'C:\Windows\Microsoft.Net\assembly\GAC_MSIL\System.Speech\v4.0_4.0.0.0__31bf3856ad364e35\System.Speech.dll'})) {
            Add-Type -AssemblyName System.Speech
        }
    }
 
    PROCESS {
        try {
            $NewMessage = New-Object System.Speech.Synthesis.SpeechSynthesizer
 
            if ($Voice -eq 'Zira') {
                $NewMessage.SelectVoice("Microsoft Zira Desktop")
            } else {
                $NewMessage.SelectVoice("Microsoft " + $Voice + " Desktop")
            }
     
            $NewMessage.Speak($Message)
     
        } catch {
            Write-Error $_.Exception.Message
        }        
    }
 
    END {}
}

Add-Type -AssemblyName System.Speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
Write-Output $speak.GetInstalledVoices().VoiceInfo

New-TextToSpeechMessage -Message 'Engine Started' -Voice David

#2) Read File with dot delimiter for sentencies 
#
#   https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content?view=powershell-7.3
#
$i = 1
$startpage = 1

foreach($line in Get-Content .\Input.txt -Delimiter "." ) {
# Work here
 $starttime = Get-Date

if ($startpage -le $i) 
 {
   Write-Output $line 
   New-TextToSpeechMessage -Message $line -Voice David
  }

 $endtime = Get-Date

 $tdiff = $endtime-$starttime
 $delay = $tdiff.seconds/2 # + $tdiff.seconds

 Write-Host "[" $i "]==> You have " $delay " seconds for repeat it , please read this sentence"

 Start-Sleep -Seconds $delay
 $i = $i + 1  
}

# TODO
#5) Fetch some from RSS feed 
#
# https://devblogs.microsoft.com/scripting/use-windows-powershell-to-parse-rss-feeds/
#
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.3
#
#
#6) https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/start-sleep?view=powershell-7.3
#
#  Start-Sleep -Seconds 1.5
#  
