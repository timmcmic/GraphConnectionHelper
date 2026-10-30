function start-GraphConnectionHelper
{
    <#
    .SYNOPSIS

    This module serves as a wrapper to implement connections to Microsoft Graph through supported authentication methods.

    .DESCRIPTION

    Trigger function to start connection / authentication to Microsoft Graph.

    .PARAMETER LOGFOLDERPATH
    *Required*
    This is the location of the log file.

    .PARAMETER ALLOWTELEMETRYCOLLECTION
    *Optional*
    Allows the submission of telemetry collection data.

    .OUTPUTS

    Logs all activity to the log folder / file created by the module

    .NOTES

    The following blog posts maintain documentation regarding this module.

    https://timmcmic.wordpress.com.  
    
    .EXAMPLE

    Start-DistributionListMigration -groupSMTPAddress $groupSMTPAddress -globalCatalogServer server.domain.com -activeDirectoryCredential $cred -logfolderpath c:\temp -dnNoSyncOU "OU" -exchangeOnlineCredential $cred -azureADCredential $cred

    #>

    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        [string]$logFolderPath,
        [Parameter(Mandatory = $false)]
        [boolean]$allowTelemetryCollection=$TRUE,
        [Parameter(Mandatory = $true)]
        [array]$msGraphScopesRequired,
        [Parameter(Mandatory = $true, ParameterSetName = "Interactive")]
        [Parameter(Mandatory = $true, ParameterSetName = "InteractiveCustomApp")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificateThumbprint")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificateSubject")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificate")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyClientSecret")]
        [Parameter(Mandatory = $true, ParameterSetName = "InteractiveNoWAM")]
        [string]$msGraphEnvironmentName="",
        [Parameter(Mandatory = $true, ParameterSetName = "Interactive")]
        [Parameter(Mandatory = $true, ParameterSetName = "InteractiveCustomApp")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificateThumbprint")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificateSubject")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificate")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyClientSecret")]
        [Parameter(Mandatory = $true, ParameterSetName = "InteractiveNoWAM")]
        [string]$msGraphTenantID="",
        [Parameter(Mandatory = $true, ParameterSetName = "DeviceCodeFlow")]
        [boolean]$msGraphDeviceCodeFlow,
        [Parameter(Mandatory = $true, ParameterSetName = "AccessToken")]
        $msGraphAccessToken,
        [Parameter(Mandatory = $true, ParameterSetName = "InteractiveNoWAM")]
        [boolean]$msGraphNoWAM,
        [Parameter(Mandatory = $true, ParameterSetName = "InteractiveCustomApp")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificateThumbprint")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificateSubject")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificate")]
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyClientSecret")]
        [Parameter(Mandatory = $true, ParameterSetName = "InteractiveNoWAM")]
        [string]$msGraphClientID="",
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificateThumbprint")]
        [string]$msGraphCertificateThumbprint="",
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificateSubject")]
        [string]$msGraphCertificateSubject="",
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyCertificate")]
        $msGraphCertificate,
        [Parameter(Mandatory = $true, ParameterSetName = "AppOnlyClientSecret")]
        $msGraphClientSecret,
        [Parameter(Mandatory = $false, ParameterSetName = "Interactive")]
        [Parameter(Mandatory = $false, ParameterSetName = "InteractiveCustomApp")]
        [Parameter(Mandatory = $false, ParameterSetName = "InteractiveNoWAM")]
        $msGraphLoginHint=""
    )

    #Initialize telemetry collection.

    $appInsightAPIKey = "63d673af-33f4-401c-931e-f0b64a218d89"
    $traceModuleName = "GraphConnectionHelper"

    $parameterSetName = $PSCmdlet.ParameterSetName

    if ($allowTelemetryCollection -eq $TRUE)
    {
        start-telemetryConfiguration -allowTelemetryCollection $allowTelemetryCollection -appInsightAPIKey $appInsightAPIKey -traceModuleName $traceModuleName -errorAction STOP
    }

    $telemetryStartTime = get-universalDateTime #Start time for telemetry evaluation
    $telemetryEventName = "Start-GraphConnectionHelper"

    #Create the log file.
    new-logFile -logFolderPath $logFolderPath

    out-logfile -string "************************************************************"
    out-logfile -string 'Starting GraphConnectionHelper'
    out-logfile -string "************************************************************"

    out-logfile -string "Testing for msGraphScopesRequired"

    if ($msGraphScopesRequired.count -eq 1)
    {
       out-logfile -string "Splitting msGraphScopesRequired into array"
       $msGraphScopesRequired=@($msGraphScopesRequired.split(","))
    }
    else
    {
        out-logfile -string "Array already specified > 1 member."
    }

    out-logfile -string "Testing that all graph versions are up to date."

    test-soverignClouds -msGraphEnvironmentName $msGraphEnvironmentName -msGraphClientID $msGraphClientID

    test-msGraphVersions

    switch ($parameterSetName)
    {
        "Interactive" {
            out-logfile -string "Parameter set used: Interactive"

            out-logfile -string "Testing to ensure that environment provided is valid graph environment."

            test-graphEnvironment -msGraphEnvironmentName $msGraphEnvironmentName

            out-logfile -string "Testing to ensure that tenant ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphTenantID

            out-logfile -string "Testing login hint for valid UPN format" 

            if ($msGraphLoginHint -ne "")
            {
                out-logfile -string "Using login hint: $msGraphLoginHint"

                test-loginHint -msGraphLoginHint $msGraphLoginHint
            }
        }
        "DeviceCodeFlow" {
            out-logfile -string "Parameter set used: DeviceCodeFlow"

            out-logfile -string "Testing to ensure that tenant ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphTenantID
        }
        "AccessToken" {
            out-logfile -string "Parameter set used: AccessToken"

            out-logfile -string "Parameter set used: AccessToken"
        }
        "InteractiveCustomApp" {
            out-logfile -string "Parameter set used: InteractiveCustomApp"

            out-logfile -string "Testing to ensure that environment provided is valid graph environment."

            test-graphEnvironment -msGraphEnvironmentName $msGraphEnvironmentName

            out-logfile -string "Testing to ensure that tenant ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphTenantID

            out-logfile -string "Testing to ensure that client ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphClientID

            out-logfile -string "Testing login hint for valid UPN format" 

            if ($msGraphLoginHint -ne "")
            {
                out-logfile -string "Using login hint: $msGraphLoginHint"

                test-loginHint -msGraphLoginHint $msGraphLoginHint
            }
        }
        "AppOnlyCertificateThumbprint" {
            out-logfile -string "Parameter set used: AppOnlyCertificateThumbprint"

            out-logfile -string "Testing to ensure that tenant ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphTenantID

            out-logfile -string "Testing to ensure that client ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphClientID

            out-logfile -string "Testing to ensure that certificate thumbprint provided is valid."

            test-CertificateThumbprint -msGraphCertificateThumbprint $msGraphCertificateThumbprint
        }
        "AppOnlyCertificateSubject" {
            out-logfile -string "Parameter set used: AppOnlyCertificateSubject"

            out-logfile -string "Testing to ensure that tenant ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphTenantID

            out-logfile -string "Testing to ensure that client ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphClientID

            out-logfile -string "Testing to ensure that certificate subject provided is valid."

            test-CertificateSubject -msGraphCertificateSubject $msGraphCertificateSubject
        }
        "AppOnlyCertificate" {
            out-logfile -string "Parameter set used: AppOnlyCertificate"

            out-logfile -string "Testing to ensure that tenant ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphTenantID

            out-logfile -string "Testing to ensure that client ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphClientID

            out-logfile -string "Testing to ensure that certificate provided is valid."

            test-CertificateProvided -msGraphCertificate $msGraphCertificate
        }
        "AppOnlyClientSecret" {
            out-logfile -string "Parameter set used: AppOnlyClientSecret"

            out-logfile -string "Testing to ensure that tenant ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphTenantID

            out-logfile -string "Testing to ensure that client ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphClientID

            out-logfile -string "Preparing the client secret for use."

            $msGraphClientSecret = convert-ClientSecret -msGraphClientSecret $msGraphClientSecret -msGraphClientID $msGraphClientID
        }
        "InteractiveNoWAM" {
            out-logfile -string "Parameter set used: InteractiveNoWAM"

            out-logfile -string "Testing to ensure that tenant ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphTenantID

            out-logfile -string "Testing to ensure that client ID provided is valid GUID format."

            test-GUIDFormat -GUID $msGraphClientID

            set-GraphWAMOption -disable:$TRUE   

            out-logfile -string "Testing login hint for valid UPN format" 

            if ($msGraphLoginHint -ne "")
            {
                out-logfile -string "Using login hint: $msGraphLoginHint"

                test-loginHint -msGraphLoginHint $msGraphLoginHint
            }
        }
    }

    switch ($parameterSetName)
    {
        "Interactive" {
            out-logfile -string "Starting interactive connection to Microsoft Graph."
            start-graphConnectionInteractive -msGraphEnvironmentName $msGraphEnvironmentName -msGraphTenantID $msGraphTenantID -msGraphScopesRequired $msGraphScopesRequired -msGraphLoginHint $msGraphLoginHint
        }
        "DeviceCodeFlow" {
            out-logfile -string "Starting device code flow connection to Microsoft Graph."
            start-graphConnectionDeviceCodeFlow -msGraphScopesRequired $msGraphScopesRequired
        }
        "AccessToken" {
            out-logfile -string "Starting access token connection to Microsoft Graph."
            start-graphConnectionAccessToken -msGraphAccessToken $msGraphAccessToken
        }
        {($_ -eq "InteractiveCustomApp") -or ($_ -eq "InteractiveNoWAM")} {
            out-logfile -string "Test"
            out-logfile -string "Starting interactive custom app connection to Microsoft Graph."
            start-graphConnectionInteractiveCustomApp -msGraphEnvironmentName $msGraphEnvironmentName -msGraphTenantID $msGraphTenantID -msGraphClientID $msGraphClientID -msGraphScopesRequired $msGraphScopesRequired -msGraphLoginHint $msGraphLoginHint

            if ($parameterSetName -eq "InteractiveNoWAM")
            {
                set-GraphWAMOption -disable:$FALSE
            }
        }
        "AppOnlyCertificateThumbprint" {
            out-logfile -string "Starting app-only certificate thumbprint connection to Microsoft Graph."
            start-graphConnectionAppOnlyCertificateThumbprint -msGraphEnvironmentName $msGraphEnvironmentName -msGraphTenantID $msGraphTenantID -msGraphClientID $msGraphClientID -msGraphCertificateThumbprint $msGraphCertificateThumbprint
        }
        "AppOnlyCertificateSubject" {
            out-logfile -string "Starting app-only certificate subject connection to Microsoft Graph."
            start-graphConnectionAppOnlyCertificateSubject -msGraphEnvironmentName $msGraphEnvironmentName -msGraphTenantID $msGraphTenantID -msGraphClientID $msGraphClientID -msGraphCertificateSubject $msGraphCertificateSubject
        }
        "AppOnlyCertificate" {
            out-logfile -string "Starting app-only certificate connection to Microsoft Graph."
            start-graphConnectionAppOnlyCertificate -msGraphEnvironmentName $msGraphEnvironmentName -msGraphTenantID $msGraphTenantID -msGraphClientID $msGraphClientID -msGraphCertificate $msGraphCertificate
        }
        "AppOnlyClientSecret" {
            out-logfile -string "Starting app-only client secret connection to Microsoft Graph."
            start-graphConnectionAppOnlyClientSecret -msGraphEnvironmentName $msGraphEnvironmentName -msGraphTenantID $msGraphTenantID -msGraphClientSecret $msGraphClientSecret
        }
    }

    out-logfile -string "Validating that connection provides the required graph scopes."

    test-requiredGraphScopes -msGraphScopesRequired $msGraphScopesRequired

    $telemetryEndTime = get-universalDateTime #Start time for telemetry evaluation

    [double]$telemetryElapsedSeconds = get-elapsedTime -startTime $telemetryStartTime -endTime $telemetryEndTime

    $telemetryEventProperties = @{
        GraphConnectionHelper = $telemetryEventName
    }

    $telemetryEventMetrics = @{
         TotalTime = $telemetryElapsedSeconds  
    }

    send-TelemetryEvent -traceModuleName $traceModuleName -eventName $telemetryValues.telemetryEventName -eventMetrics $telemetryEventMetrics -eventProperties $telemetryEventProperties

    send-TelemetryEvent -traceModuleName $traceModuleName -eventName $telemetryValues.telemetryEventName -eventMetrics $telemetryEventMetrics -eventProperties $telemetryEventProperties

    out-logfile -string "Graph connection established and validated successfully."
}