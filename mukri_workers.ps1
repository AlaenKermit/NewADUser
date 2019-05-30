Import-Module ActiveDirectory

function add-user {
    Param ([string]$eesnimi,[string]$perenimi,[string]$roll)

    $OU1 = "IT"
    $OU2 = "Inimesed"
    $OU3 = "Massu"

    if ($roll -eq "IT") {
        $OU1 = "IT"
        $OU3 = "Massu"
    }

    if ($roll -eq "Giidid") {
        $OU1 = "Giidid"
        $OU3 = "Vaki"
    }

    if ($roll -eq "Turundusosakond") {
        $OU1 = "Turundusosakond"
        $OU3 = "Massu"
    }

    if ($roll -eq "Raamatupidamine") {
        $OU1 = "Raamatupidamine"
        $OU3 = "Vaki"
    }

    $account = $("$eesnimi.$perenimi").ToLower()
    $principal = $("$account@mukri.sise")

    if (Get-ADUser -Filter {SamAccountName -eq $account}) {
        Write-Host "Kasutaja $account olemas!"
    }
    else {
        new-ADUser -Name "$eesnimi $perenimi" -Enabled:$true -GivenName $eesnimi -Surname $perenimi -SamAccountName $account -UserPrincipalName $principal  -AccountPassword (ConvertTo-SecureString "Passw0rd!" -AsPlainText -Force) -ChangePasswordAtLogon:$true -path "OU=$OU1, OU=$OU2, OU=$OU3, DC=mukri, DC=sise"
        Add-ADGroupMember "$roll" $account
    }
}

Import-Csv .\Desktop\andmed.csv -Encoding UTF8 | ForEach-Object {
    add-user -eesnimi $_.eesnimi -perenimi $_.perenimi -roll $_.roll
}



