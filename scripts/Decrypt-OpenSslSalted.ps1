param(
    [Parameter(Mandatory = $true)]
    [string]$CipherBase64,

    [Parameter(Mandatory = $true)]
    [string]$Password
)

function Join-Bytes {
    param(
        [byte[]]$A,
        [byte[]]$B,
        [byte[]]$C
    )

    $out = New-Object byte[] ($A.Length + $B.Length + $C.Length)
    [Array]::Copy($A, 0, $out, 0, $A.Length)
    [Array]::Copy($B, 0, $out, $A.Length, $B.Length)
    [Array]::Copy($C, 0, $out, $A.Length + $B.Length, $C.Length)
    return $out
}

function Get-EvpBytesToKey {
    param(
        [string]$Pass,
        [byte[]]$Salt,
        [int]$KeyLength,
        [int]$IvLength
    )

    $md5 = [System.Security.Cryptography.MD5]::Create()
    $passBytes = [System.Text.Encoding]::UTF8.GetBytes($Pass)
    $result = New-Object System.Collections.Generic.List[byte]
    [byte[]]$prev = @()

    while ($result.Count -lt ($KeyLength + $IvLength)) {
        $input = Join-Bytes -A $prev -B $passBytes -C $Salt
        $prev = $md5.ComputeHash($input)
        $result.AddRange($prev)
    }

    $all = $result.ToArray()
    return @{
        Key = $all[0..($KeyLength - 1)]
        IV  = $all[$KeyLength..($KeyLength + $IvLength - 1)]
    }
}

$data = [Convert]::FromBase64String($CipherBase64)

if ($data.Length -lt 16) {
    throw "密文长度异常。"
}

$prefix = [System.Text.Encoding]::ASCII.GetString($data[0..7])
if ($prefix -ne 'Salted__') {
    throw "不是 OpenSSL Salted__ 格式。"
}

$salt = $data[8..15]
$cipher = $data[16..($data.Length - 1)]
$material = Get-EvpBytesToKey -Pass $Password -Salt $salt -KeyLength 32 -IvLength 16

$aes = [System.Security.Cryptography.Aes]::Create()
$aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
$aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
$aes.KeySize = 256
$aes.BlockSize = 128
$aes.Key = $material.Key
$aes.IV = $material.IV

$plaintext = $aes.CreateDecryptor().TransformFinalBlock($cipher, 0, $cipher.Length)
[System.Text.Encoding]::UTF8.GetString($plaintext)
