# Add 'tools' to PATH
$env:Path += ";$PSScriptRoot\tools"

# Define new functions
function idf_s3 {
    idf.py -B build_s3 -DSDKCONFIG="build_s3/sdkconfig.s3" $args
}

function idf_c3 {
    idf.py -B build_c3 -DSDKCONFIG="build_c3/sdkconfig.c3" $args
}

function idf_c6 {
    idf.py -B build_c6 -DSDKCONFIG="build_c6/sdkconfig.c6" $args
}

function idf_clean {
    param (
        [Parameter(Mandatory=$false)]
        [ValidateSet("s3", "c3", "c6", "all")]
        [string]$Target = "all"
    )

    $TargetsToClean = @()
    if ($Target -eq "all") { $TargetsToClean = "build_s3", "build_c3", "build_c6" }
    else { $TargetsToClean = "build_$Target" }

    foreach ($folder in $TargetsToClean) {
        if (Test-Path $folder) {
            Write-Host "Nuking directory: $folder..." -ForegroundColor Yellow
            Remove-Item -Path $folder -Recurse -Force
            Write-Host "Successfully cleaned $folder." -ForegroundColor Green
        } else {
            Write-Host "Folder $folder does not exist, skipping." -ForegroundColor Gray
        }
    }
}
