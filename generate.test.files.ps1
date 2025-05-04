<#
.SYNOPSIS
	Generates test PDF files with specific naming pattern.
.DESCRIPTION
	Creates 5 test PDF files with names in the format:
	"QTS-[RANDOM 4 DIGIT NUMBER PADDED WITH ZEROES] - [RANDOM HEX STRING OF LENGTH 32-128].pdf"
.EXAMPLE
	.\Generate-TestFiles.ps1
#>

# Create 5 test files
1..5 | ForEach-Object {
	# Generate random 4-digit number padded with zeros
	$randomNumber = Get-Random -Minimum 0 -Maximum 9999
	$paddedNumber = "{0:D4}" -f $randomNumber
	
	# Generate random hex string of length between 32 and 128
	$hexLength = Get-Random -Minimum 32 -Maximum 129
	$hexString = -join ((48..57) + (65..70) | Get-Random -Count $hexLength | % { [char]$_ })
	
	# Create filename
	$fileName = "QTS-$paddedNumber - $hexString.pdf"
	
	# Create empty file
	$null = New-Item -Path $fileName -ItemType File -Force
	Write-Host "Created test file: $fileName"
}

Write-Host "Test file generation complete."
