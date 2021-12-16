function Solve-Day16Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $CurrentLine
    )
    begin {
    }
    process {
        $bytes = [byte[]](-split ($CurrentLine -creplace '.{1,2}', '0x$& ')).PadRight(4, "0")
    }
    end {
        $readBitOffset = [ref]0
        $rootPacket = ReadPacket $bytes $readBitOffset

        $stack = [System.Collections.Stack]::new()
        $stack.Push($rootPacket)

        $versionSum = 0
        while ($stack.Count -gt 0) {
            $packet = $stack.Pop()
            $versionSum += $packet.Version
            foreach ($subPacket in $packet.SubPackets) {
                $stack.Push($subPacket)
            }
        }

        $versionSum
    }
}

function Solve-Day16Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $CurrentLine
    )
    begin {
        function Evaluate($packet) {
            switch ($packet.TypeId) {
            0 {
                ($packet.SubPackets | ForEach-Object { Evaluate $_ } | Measure-Object -Sum).Sum
            }
            1 {
                $product = 1
                foreach ($subPacket in $packet.SubPackets) {
                    $product *= Evaluate $subPacket
                }

                $product
            }
            2 {
                ($packet.SubPackets | ForEach-Object { Evaluate $_ } | Measure-Object -Minimum).Minimum
            }
            3 {
                ($packet.SubPackets | ForEach-Object { Evaluate $_ } | Measure-Object -Maximum).Maximum
            }
            4 {
                $packet.LiteralValue
            }
            5 {
                [int]((Evaluate $packet.SubPackets[0]) -gt (Evaluate $packet.SubPackets[1]))
            }
            6 {
                [int]((Evaluate $packet.SubPackets[0]) -lt (Evaluate $packet.SubPackets[1]))
            }
            7 {
                [int]((Evaluate $packet.SubPackets[0]) -eq (Evaluate $packet.SubPackets[1]))
            }
            }
        }
    }
    process {
        $bytes = [byte[]](-split ($CurrentLine -creplace '.{1,2}', '0x$& ')).PadRight(4, "0")
    }
    end {
        $readBitOffset = [ref]0
        $rootPacket = ReadPacket $bytes $readBitOffset

        Evaluate $rootPacket
    }
}

function ReadPacket($data, [ref] $readBitOffset) {
    $version = ReadValue $data $readBitOffset 3
    $typeId = ReadValue $data $readBitOffset 3
    if ($typeId -eq 4) {
        $literalValue = 0L
        do {
            $segment = ReadValue $data $readBitOffset 5
            $literalValue = $literalValue -shl 4
            $literalValue = $literalValue -bor ($segment -band 0x0F)
        } while ($segment -band 0x10)

        @{
            Version = $version
            TypeId = $typeId
            LiteralValue = $literalValue
        }
    } else {
        $subPackets = [System.Collections.ArrayList]::new()
        $lengthTypeId = ReadValue $data $readBitOffset 1
        if (-not $lengthTypeId) {
            $subPacketTotalSizeBits = ReadValue $data $readBitOffset 15
            $readBitEnd = $readBitOffset.Value + $subPacketTotalSizeBits
            while ($readBitOffset.Value -lt $readBitEnd) {
                $subPacket = ReadPacket $data $readBitOffset
                $subPackets.Add($subPacket)
            }
        } else {
            $subPacketCount = ReadValue $data $readBitOffset 11
            for ($i = 0; $i -lt $subPacketCount; $i++) {
                $subPacket = ReadPacket $data $readBitOffset
                $subPackets.Add($subPacket)
            }
        }

        @{
            Version = $version
            TypeId = $typeId
            SubPackets = $subPackets
        }
    }
}

function ReadValue($data, [ref] $readBitOffset, $bitSize) {
    $bitAlignment = $readBitOffset.Value % 8
    $readByteOffset = [System.Math]::Truncate($readBitOffset.Value / 8)
    $readByteEnd = $readByteOffset + [System.Math]::Ceiling(($bitAlignment + $bitSize) / 8)
    $value = [uint64]0
    while ($readByteOffset -lt $readByteEnd) {
        $value = $value -shl 8
        $value = $value -bor $data[$readByteOffset]
        $readByteOffset++
    }
    $value = $value -shr (-($bitAlignment + $bitSize) % 8 + 8) % 8
    $value = $value -band (1 -shl $bitSize) - 1
    $readBitOffset.Value += $bitSize

    [long]$value
}
