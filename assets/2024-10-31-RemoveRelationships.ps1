# Content manager DLL Location

$sdkAssemblyPath = "C:\Program Files\Micro Focus\Content Manager\TRIM.SDK.dll"

# Default Content Manager Dataset Details

$datasetId = "45"
$datasetWorkgroup = "local"

# Set the path to the CSV file

$csvPath = "RemoveRelationships.csv"

#Col1 RecordNumber (as string)
#Col2 RelatedType (as string)
#Col3 RelatedTo (as string)

# ---------------------- #
# ---CUSTOM FUNCTIONS--- #
# ---------------------- #

function Write-Debug {
    param(
        [Parameter(Mandatory=$true)]
        [String]
        $output
    )
    
    Write-Host $output
    Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")`t$($output)" >> "$($csvPath)-$(Get-Date -Format "yyyy-MM").log"
}

# --------------------- #
# ---START OF SCRIPT--- #
# --------------------- #

# Load Assembly

Write-Debug "Loading TRIMSDK Assembly"

Add-Type -Path $sdkAssemblyPath

# Connect to the Database

Write-Debug "Connecting to DB"

$database = New-Object TRIM.SDK.Database
$database.Id = $datasetId
$database.WorkgroupServerName = $datasetWorkgroup

$database.Connect()

if (-not $database.IsConnected) {
    exit
}

Write-Debug "Connected"

# Read the CSV file
$recList = Import-Csv -Path $csvPath

foreach($recItem in $recList) {

    # Check to see if Rec Exists Already

    $recSearch = New-Object TRIM.SDK.TrimMainObjectSearch($database, [TRIM.SDK.BaseObjectTypes]::Record)
    $recSearch.SearchString = "number:$($recItem.RecordNumber)"

    # Get the first / only result in the search

    $recEnumerator = $recSearch.GetEnumerator()
    if (!$recEnumerator.MoveNext()){
        Write-Debug "Unable to find $($recItem.RecordNumber)"
        return;
    }

    # Got the record
    $record = [TRIM.SDK.Record] $recEnumerator.Current
        
    # Get the relationships
    $recRelations = $record.ChildRelationships

    $removedRelation = $false
    
    foreach($recRelation in $recRelations){

        if($recRelation.Description.ToUpper() -ne $recItem.RelatedType.ToUpper()){
            # If the record relationship type DOESN'T match then continue the loop
            continue
        }

        if ($recRelation.RelatedRecord.Number.ToUpper() -ne $recItem.RelatedTo.ToUpper()){
            # If the record number DOESN"T match then continue the loop
            continue
        }

        
        $recRelation.Delete()
        $removedRelation = $true
    }    

    if ($removedRelation){
        $record.Save()
        Write-Debug "$($recitem.RecordNumber) relation removed SUCCESSFULLY"
    }
    else{
        Write-Debug "$($recitem.RecordNumber) relationship NOT found"
    }

}


# Disconnect

$database.Disconnect()