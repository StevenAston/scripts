Get-ChildItem -Directory -Recurse | ForEach-Object {
    $size = (Get-ChildItem -Path $_.FullName -File -Recurse | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{
        FolderPath = $_.FullName
        SizeInBytes = if ($size) { $size } else { 0 }
        SizeInKB = if ($size) { [math]::Round($size / 1KB, 2) } else { 0 }
        SizeInMB = if ($size) { [math]::Round($size / 1MB, 2) } else { 0 }
        SizeInGB = if ($size) { [math]::Round($size / 1GB, 2) } else { 0 }
    }
} | Sort-Object -Property SizeInBytes -Descending | Format-Table -AutoSize
