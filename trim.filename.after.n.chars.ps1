<#
.SYNOPSIS
	Renames files to keep only the first 7 characters of the filename while preserving the extension.
.DESCRIPTION
	Recursively processes all files in the specified directory, renaming each file to keep only
	the first 7 characters of the original filename while preserving the file extension.
	Logs all changes to the console.
.PARAMETER Path
	The directory path to process. Defaults to the current directory.
.EXAMPLE
	.\Rename-FilesTo7Chars.ps1 -Path "C:\MyFiles"
#>

param (
	[string]$Path = "."
)

# Get all files recursively
$files = Get-ChildItem -Path $Path -File -Recurse

foreach ($file in $files) {
	$originalName = $file.Name
	$extension = $file.Extension
	$newName = $originalName.Substring(0, [Math]::Min(7, $originalName.Length - $extension.Length)) + $extension
	
	if ($originalName -ne $newName) {
		try {
			Rename-Item -Path $file.FullName -NewName $newName -ErrorAction Stop
			Write-Host "Renamed: '$originalName' to '$newName'"
		}
		catch {
			Write-Host "Error renaming '$originalName': $_" -ForegroundColor Red
		}
	}
	else {
		Write-Host "No change needed for: '$originalName'"
	}
}

Write-Host "Processing complete."
