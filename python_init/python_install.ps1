Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process

# Fetch the latest Python version JSON
$latestVersionJson = Invoke-RestMethod -Uri "https://www.python.org/api/v2/downloads/release/?is_published=true" -UseBasicParsing

# Filter and output the packages where show_on_download_page is True
$filteredVersions = $latestVersionJson | Where-Object { $_.show_on_download_page -eq $true }

# Sort by name in descending order
$sortedVersions = $filteredVersions | Sort-Object { [Version]($_.name -replace '^Python (\d+\.\d+\.\d+).*', '$1') } -Descending

# Select the first element (highest version) and extract only the version number
$latestVersion = ($sortedVersions[0].name -replace '^Python ', '')

# Output the latest version number
Write-Output "Latest Python version found: $latestVersion"

# Construct URL for the installer
$url = "https://www.python.org/ftp/python/$latestVersion/python-$latestVersion-amd64.exe"
Write-Output "Installer URL: $url"

# Define path to save the installer
$installerPath = "$env:USERPROFILE\Downloads\python-$latestVersion-amd64.exe"
Write-Output "Installer Path: $installerPath"

# Download the installer
Invoke-WebRequest -Uri $url -OutFile $installerPath

# Notify user that download is complete
Write-Output "Download complete. Installer saved to: $installerPath"
