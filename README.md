# YAPG

Yet Another Password Generator

Based on the idea of [correct horse battery staple xkcd](https://xkcd.com/936/)

It generates passwords, but instead of totally random it uses a wordlist which makes your passwords kind of human readable, such as

> - Meta&undeviatiNg&SenegaL+ToTo
> - 5c4mp57on'trilby(non-4dmi55i0n"v3rifia81y
> - cyclewayspecioustutelaraffluence

included in the repo is the wordlist from Mozilla brittish english dict by
[Marco A.G.Pinto](https://github.com/marcoagpinto/aoo-mozilla-en-dict/tree/master/en_GB%20(Marco%20Pinto)), licensed under LGPL.

This command will output your passwords in clear text! If you are going to use them in scripts and needs them encrypted you need to manage it yourself.

```PowerShell
$MyEncryptedPass = ConvertTo-SecureString -String (New-YapgPassword -Leet -WordCount 2 -AddChars -Capitalize) -AsPlainText -Force
```
