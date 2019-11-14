function New-YapgPassword {
    param (
        [Parameter()]
        [int]$WordCount = 4,

        [Parameter()]
        [switch]$AddChars,

        [Parameter()]
        [switch]$Capitalize,

        [Parameter()]
        [switch]$Leet,

        [Parameter()]
        [string]$Dictionary = "$PSScriptRoot\en-GB.dic"
    )

    $AllWords = ([System.IO.StreamReader]::new($Dictionary).ReadToEnd()).Split("`n").Where({$_ -match '^[a-zA-Z]'})

    [array]$Words = 1..$WordCount | foreach {
        $CurrWord = ($AllWords | Get-Random).split('/')[0]
        If ($Capitalize) {
            $CurrWord = $CurrWord.ToCharArray()
            $i = Get-Random -Minimum 0 -Maximum $CurrWord.Count
            $CurrWord[$i] = $CurrWord[$i].ToString().ToUpper()
            $CurrWord = -join $CurrWord
        }
        $CurrWord
    }

    if ($AddChars) {
        function GenerateChar {
            [char][int](Get-Random -Minimum 33 -Maximum 48)
        }
        0..($Words.Count - 2) | foreach {
            $Words[$_] = "$($Words[$_])$(GenerateChar)" 
        }
    }
    
    if ($Leet) {
        -join ($Words -creplace 'l','1' -creplace 'e','3' -creplace 't','7' -creplace 'o','0')
    }
    else { 
        -join $Words
    }
}