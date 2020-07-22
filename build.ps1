param (
    [string]
    $BuildPath = ".\build",

    [string[]]
    $Architectures = @("amd64","386"),

    [switch]
    $Release = $false,

    [string]
    $ReleasePath = "winssh-pageant"
)

# Cleanup
Remove-Item -LiteralPath $BuildPath -Force -Recurse -ErrorAction SilentlyContinue

# Build output directory
$outDir = New-Item -ItemType Directory -Path $BuildPath
$releaseDir = New-Item -ItemType Directory -Path ".\release"

$oldGOOS = $env:GOOS
$oldGOARCH = $env:GOARCH

$env:GOOS="windows"
$env:GOARCH=$null

$returnValue = 0

# Build release package
if ($Release)
{
    Copy-Item Readme.md $outDir
    Copy-Item LICENSE $outDir
    
    Remove-Item -LiteralPath $ReleasePath -ErrorAction SilentlyContinue
}
# Build for each architecture
Foreach ($arch in $Architectures)
{
    $env:GOARCH=$arch
    
    if ($Release)
    {        
        go build -ldflags -H=windowsgui -o $outDir\winssh-pageant.exe
        if ($LastExitCode -ne 0) { $returnValue = $LastExitCode }
        # Remove-Item -LiteralPath $ReleasePath -ErrorAction SilentlyContinue
        Compress-Archive -Path $outDir\* -DestinationPath $releaseDir\$ReleasePath-$arch.zip -Force
        
        Remove-Item -LiteralPath $outDir\winssh-pageant.exe
    } else {
        go build -ldflags -H=windowsgui -o $outDir\winssh-pageant-$arch.exe
    }
}


# Restore env vars
$env:GOOS = $oldGOOS
$env:GOARCH = $oldGOARCH

exit $returnValue