# ManageEngine ServiceDesk Plus licensing research
# EDUCATIONAL / DEFENSIVE / READ-ONLY OBSERVATION SCRIPT
#
# This script inventories selected files, hashes them, and searches runtime logs.
# It does not modify, replace, patch, rename, or delete product/license files.

$SDP = "C:\Program Files\ManageEngine\ServiceDesk"

Write-Host "=== Selected file inventory ==="
Get-ChildItem $SDP -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
        $_.Name -in @(
            "petinfo.dat",
            "product.dat",
            "AdventNetLicense.xml",
            "ExpiredLicense.xml"
        )
    } |
    Select-Object FullName, Length, CreationTime, LastWriteTime

Write-Host "`n=== SHA-256 ==="
Get-ChildItem $SDP -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
        $_.Name -in @(
            "petinfo.dat",
            "product.dat",
            "AdventNetLicense.xml",
            "ExpiredLicense.xml"
        )
    } |
    ForEach-Object {
        Get-FileHash $_.FullName -Algorithm SHA256 |
            Select-Object Path, Hash
    }

Write-Host "`n=== Licensing-related runtime log lines ==="
Get-ChildItem "$SDP\logs" -Filter "serverout*.txt" -File -ErrorAction SilentlyContinue |
    Select-String -Pattern @(
        "Evaluation User",
        "LicenseExpireTask",
        "license expire",
        "ExpiredLicense",
        "AdventNetLicense"
    ) |
    ForEach-Object {
        [PSCustomObject]@{
            File       = $_.Path
            LineNumber = $_.LineNumber
            Line       = $_.Line
        }
    }

Write-Host "`nObservation complete. No files were changed."
