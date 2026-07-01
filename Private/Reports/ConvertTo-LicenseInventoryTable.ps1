function ConvertTo-LicenseInventoryTable {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [object[]]$LicenseSummary

    )

    $Html = @"

<table class='inventory-table'>

<thead>

<tr>

<th>Category</th>

<th>License</th>

<th>Purchased</th>

<th>Assigned</th>

<th>Available</th>

<th>Utilization</th>

</tr>

</thead>

<tbody>

"@

    foreach ($License in $LicenseSummary) {

        #
        # Row Highlighting
        #

        $RowClass = ""

        if ($License.Available -eq 0) {

            $RowClass = "critical"

        }
        elseif ($License.Available -lt 10) {

            $RowClass = "warning"

        }

        #
        # Utilization
        #

        if ($License.Total -gt 0) {

            $Utilization = [math]::Round(
                ($License.Assigned / $License.Total) * 100,
                1
            )

        }
        else {

            $Utilization = 0

        }

        #
        # Category Badge
        #

        $Badge = switch ($License.Category) {

            'Core' {

                "<span class='badge core'>Core</span>"

            }

            'Communication' {

                "<span class='badge communication'>Teams Add-on</span>"

            }

            'AddOn' {

                "<span class='badge addon'>Add-On</span>"

            }

            'Trial' {

                "<span class='badge trial'>Trial</span>"

            }

            'Free' {

                "<span class='badge free'>Free</span>"

            }

            'Capacity' {

                "<span class='badge capacity'>Capacity</span>"

            }

            default {

                "<span class='badge unknown'>Unknown</span>"

            }

        }

        #
        # Progress Bar Color
        #

        $ProgressClass = switch ($Utilization) {

            { $_ -ge 90 } { "high"; break }

            { $_ -ge 70 } { "medium"; break }

            default { "low" }

        }

        $Html += @"

<tr class='$RowClass'>

<td>$Badge</td>

<td>$($License.License)</td>

<td>$("{0:N0}" -f $License.Total)</td>

<td>$("{0:N0}" -f $License.Assigned)</td>

<td>$("{0:N0}" -f $License.Available)</td>

<td>

<div class='progress'>

<div class='progress-bar $ProgressClass'
style='width:$Utilization%;'>

$Utilization%

</div>

</div>

</td>

</tr>

"@

    }

    $Html += @"

</tbody>

</table>

"@

    return $Html

}