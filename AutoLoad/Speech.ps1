function Say([string] $toSay)
{
    [Reflection.Assembly]::LoadWithPartialName("System.Speech") | Out-Null

    $speechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    try {
        $speechSynth.Speak($toSay)
    }
    finally {
        if($speechSynth -ne $null) {
            $speechSynth.Dispose()
        }
    }
}
