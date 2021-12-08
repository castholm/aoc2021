function Solve-Day8Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $count = 0
    }
    process {
        $count += (-split ($Current -split "\|")[-1] | Where-Object { $_.Length -in (2, 3, 4, 7) }).Count
    }
    end {
        $count
    }
}

function Solve-Day8Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $sum = 0
    }
    process {
        $segments = $Current -split "\|"
        $a = -split $segments[0] | ForEach-Object { -join ($_.ToCharArray() | Sort-Object) }
        $b = -split $segments[1] | ForEach-Object { -join ($_.ToCharArray() | Sort-Object) }

        $one = $a | Where-Object { $_.Length -eq 2 }
        $four = $a | Where-Object { $_.Length -eq 4 }
        $seven = $a | Where-Object { $_.Length -eq 3 }
        $eight = $a | Where-Object { $_.Length -eq 7 }
        $two = $a | Where-Object { $_.Length -eq 5 -and ($_.ToCharArray() | Where-Object { $_ -notin $four.ToCharArray() }).Count -eq 3 }
        $three = $a | Where-Object { $_.Length -eq 5 -and ($_.ToCharArray() | Where-Object { $_ -notin $one.ToCharArray() }).Count -eq 3 }
        $five = $a | Where-Object { $_.Length -eq 5 -and $_ -notin ($two, $three) }
        $zero = $a | Where-Object { $_.Length -eq 6 -and ($_.ToCharArray() | Where-Object { $_ -notin $five.ToCharArray() }).Count -eq 2 }
        $six = $a | Where-Object { $_.Length -eq 6 -and ($_.ToCharArray() | Where-Object { $_ -notin $one.ToCharArray() }).Count -eq 5 }
        $nine = $a | Where-Object { $_.Length -eq 6 -and $_ -notin ($zero, $six) }

        $lookup = @{
            $zero = "0"
            $one = "1"
            $two = "2"
            $three = "3"
            $four = "4"
            $five = "5"
            $six = "6"
            $seven = "7"
            $eight = "8"
            $nine = "9"
        }

        $sum += -join ($b | ForEach-Object { $lookup[$_] })
    }
    end {
        $sum
    }
}
