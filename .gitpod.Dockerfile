# escape=`

ARG FROM_IMAGE=microsoft/dotnet-framework:3.5-sdk-windowsservercore-1709
FROM ${FROM_IMAGE}

###############################################################################################################
# Install VS 2017 Build tools
###############################################################################################################
# Based on  https://github.com/microsoft/vs-dockerfiles
# Download channel for fixed install.
SHELL ["cmd", "/S", "/C"]

COPY Install.cmd C:\TEMP\
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe

ARG CHANNEL_URL=https://aka.ms/vs/15/release/channel
ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman

# Download and install Build Tools for Visual Studio 2017.
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

###############################################################################################################
# Install NET core 2.1 
###############################################################################################################
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Workload.MSBuildTools `
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools `
    --add Microsoft.Net.Component.4.8.SDK `
    --add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools `
    --add Microsoft.Net.ComponentGroup.4.6.1.DeveloperTools `
    --add Microsoft.Net.ComponentGroup.TargetingPacks.Common 
    
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe modify --quiet --wait --norestart --nocache `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Workload.NetCoreTools `
    --add Microsoft.Net.Core.Component.SDK.2.1 
    
SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]
RUN $ErrorActionPreference = 'Stop'; `
    $ProgressPreference = 'SilentlyContinue'; `
    $VerbosePreference = 'Continue'; `
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
