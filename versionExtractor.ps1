$inputFile  = ".\UsedPackagesAndVersions.csv"
$outputFile = ".\UsedPackagesAndVersionsOutput.csv"

$rows = Import-Csv $inputFile

foreach ($row in $rows) {
    $pkg = $row.Package
    $ver = $row.Version

    if (-not $pkg -or -not $ver) { continue }

    Write-Host "Processing $pkg@$ver ..."

    # Get the release time for that specific version
    $time = npm view "$pkg@$ver" time --json 2>$null
    $result=($time|ConvertFrom-Json)
    if ($time) {
        # For a specific version `npm view pkg@ver time` returns a JSON string with the date
        $row.ReleaseDate = $result.$ver
    } else {
        $row.ReleaseDate = "NOT FOUND"
    }
}

$rows | Export-Csv $outputFile -NoTypeInformation
Write-Host "Done. Output: $outputFile"
