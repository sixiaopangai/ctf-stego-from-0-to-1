param(
    [Parameter(Mandatory = $true)]
    [string]$InputFile,

    [string]$OutputFile = "hidden.zip"
)

$bytes = [System.IO.File]::ReadAllBytes($InputFile)

$zipStart = -1
for ($i = 0; $i -lt $bytes.Length - 3; $i++) {
    if ($bytes[$i] -eq 0x50 -and $bytes[$i + 1] -eq 0x4B -and $bytes[$i + 2] -eq 0x03 -and $bytes[$i + 3] -eq 0x04) {
        $zipStart = $i
        break
    }
}

if ($zipStart -lt 0) {
    throw "未找到 ZIP 文件头 PK 03 04。"
}

$tail = $bytes[$zipStart..($bytes.Length - 1)]
[System.IO.File]::WriteAllBytes($OutputFile, $tail)

Write-Output "ZIP 起始偏移: $zipStart"
Write-Output "已输出到: $OutputFile"
