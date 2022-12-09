<#
.SYNOPSIS
    Generates a password based on a known wordlist
.DESCRIPTION
    This function generates one or more passwords based on a known word list.
    Included is the wordlist from Firefox brittish english dict by Marco A.G.Pinto
    https://addons.mozilla.org/firefox/addon/british-english-dictionary-2/

.PARAMETER WordCount
    How many words will a password contain
.PARAMETER AddChars
    Add random characters between each word
.PARAMETER Capitalize
    Add random capitalization to the password
.PARAMETER Leet
    Convert words to l33t sp3ak
.PARAMETER Dictionary
    Use custom dictionary file (probably a bad idea as it has to be in the correct format...)
.PARAMETER Passwords
    How many passwords to generate

.NOTES
    I do not take any responsibility for cracked, leaked, or easily broken passwords...
.EXAMPLE
    PS> New-YapgPassword

    Will output four random words. Examples; 
    'LalehamWavertoninfructescenceSjogren'
    'enquirepseudo-scienceAlberniHolocene'
    'ChestermerewhiskerlightenFerryhill'
.EXAMPLE
    PS> New-YapgPassword -Leet

    Will output four random words and convert random characters to numbers (l33t sp3ak). Examples;
    'More1r460551p3nc3ph4l0graph1impenhoe'
    'H13r4p0115pro70n47eFr172f34r1355'
    '5and83rgge03con0m1c55ter3o3n116h73n'

.EXAMPLE
    PS> New-YapgPassword -Leet -WordCount 2 -AddChars -Capitalize -Passwords 5

    Will output five passwords consisting of 
        - two random words
        - convert random characters to numbers
        - Add random charactrers between each words
        - Random capitalization of characters
    Examples;
    'Ab1ngtOn!f4rm1Ng'
    'kR4ft%papi114'
    'Clerm0nt-F3rR4nd-3m1liaN0'
    'QRpedi4'l1n01eniC'
    '0r64nel1e"1nfomerC1a1'
#>


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
        [string]$Dictionary = "$PSScriptRoot\en-GB.dic",

        [Parameter()]
        [int]$Passwords = 1
    )

    begin {
        function RandomizeLeet {
            param(
                [string]$str
            )
            
            $LeetChars = @(
                @{
                    c = 'a'
                    r = '4'
                },
                @{
                    c = 'b'
                    r = '8'
                },
                @{
                    c = 'e'
                    r = '3'
                },
                @{
                    c = 'g'
                    r = '6'
                },
                @{
                    c = 'i'
                    r = '1'
                },
                @{
                    c = 'l'
                    r = '1'
                },
                @{
                    c = 'o'
                    r = '0'
                },
                @{
                    c = 's'
                    r = '5'
                },
                @{
                    c = 't'
                    r = '7'
                },
                @{
                    c = 'z'
                    r = '2'
                }
            )
        
            $r = $str.ToCharArray()
        
            0..($r.Count - 1) | ForEach-Object {
                if (($r[$_]-in $LeetChars.c) -and (((Get-Random -Minimum 1 -Maximum 3) % 2) -eq 1)) {
                    $c = $r[$_]
                    $r[$_] = $LeetChars.Where({$_.c -eq $c}).r
                }
            }
        
            -join $r
        }
     
        $AllWords = ([System.IO.StreamReader]::new($Dictionary).ReadToEnd()).Split("`n").Where({$_ -match '^[a-zA-Z]'})
    }

    process {
        1.. $Passwords | ForEach-Object { 
            [array]$Words = 1..$WordCount | ForEach-Object {
                $CurrWord = ($AllWords | Get-Random).split('/')[0].Trim()
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
                0..($Words.Count - 2) | ForEach-Object {
                    $Words[$_] = "$($Words[$_])$(GenerateChar)" 
                }
            }
            
            if ($Leet) {
                -join ($Words | ForEach-Object {RandomizeLeet -str $_})
            }
            else { 
                -join $Words
            }
        }
    }
}