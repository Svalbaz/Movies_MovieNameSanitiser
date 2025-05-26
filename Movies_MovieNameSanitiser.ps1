<#
SvalbazNet: Movies_MovieNameSanitiser.ps1

Target:		Movies
Use: 		Script looks in $rootStaging for movie files with messy names and renames them into the format: "<Movie Name> (Year).ext",
            moving them into a folder of the same name (e.g. "Battle Royale (2000)\Battle Royale (2000).mkv").

Reason:     To keep the staging area clean and JellyFin-friendly while retaining original files in case of manual fix-up.

# SAFE MODE: This Script is saved in "SAFE MODE", so by default it will only Write-Host and use -WhatIf.
Remove -WhatIf to actually apply changes.
#>

# ----- VARIABLES ----- #
$rootStaging = "\\192.168.1.184\movies\Staging"
$unmatchedFiles = @()  # Array to store unmatched filenames

# ----- SCRIPT ----- #
Get-ChildItem -Path $rootStaging -File | Where-Object { $_.Extension -match '\.(mkv|mp4|avi)$' } | ForEach-Object {
    $file = $_
    $nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

    # Try to extract title and year from the filename
    if ($nameWithoutExt -match '^(?<title>.+?)[\.\s_-]*(?<year>19\d{2}|20\d{2})') {
        $rawTitle = $Matches['title']
        $year = $Matches['year']

        # Clean up the title
        $cleanTitle = ($rawTitle -replace '[\.\-_]', ' ').Trim()
        $cleanTitle = [System.Globalization.CultureInfo]::InvariantCulture.TextInfo.ToTitleCase($cleanTitle.ToLower())

        $folderName = "$cleanTitle ($year)"
        $newFileName = "$folderName$($file.Extension)"
        $destinationFolder = Join-Path -Path $rootStaging -ChildPath $folderName
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $newFileName

        # Show what would happen
        Write-Host "`nMoving:`n $($file.Name)`n   => $destinationPath" -ForegroundColor Yellow

        # SAFE MODE: Create destination folder (simulated)
        if (-not (Test-Path $destinationFolder)) {
            Write-Host "Creating folder: $destinationFolder" -ForegroundColor Cyan
            New-Item -Path $destinationFolder -ItemType Directory -WhatIf
        }

        # SAFE MODE: Move/rename the file (simulated)
        Move-Item -Path $file.FullName -Destination $destinationPath -WhatIf
    } else {
        $unmatchedFiles += $file.Name
    }
}

# ----- SUMMARY OUTPUT ----- #
if ($unmatchedFiles.Count -gt 0) {
    Write-Host "`nUnmatched Files:" -ForegroundColor Cyan
    $unmatchedFiles | Sort-Object | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
} else {
    Write-Host "`n✅ All files matched and processed successfully!" -ForegroundColor Green
}
