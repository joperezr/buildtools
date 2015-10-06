download_msbuild()
{
   if [ ! -e $__MSBUILD_PATH ]; then
      echo "Restoring msbuild..."
      mono "$__NUGET_PATH" install $__MSBUILD_PACKAGE_ID -Version $__MSBUILD_PACKAGE_VERSION -source "https://www.myget.org/F/dotnet-buildtools/" -ExcludeVersion -OutputDirectory $__PACKAGES_DIR
      if [ $? -ne 0 ]; then
         echo "Failed to restore MSBuild."
         exit 1
      fi
   fi
}

__PROJECT_DIR=$1
__PACKAGES_DIR=$2
__NUGET_PATH=$3
__MSBUILD_PACKAGE_ID="Microsoft.Build.Mono.Debug"
__MSBUILD_PACKAGE_VERSION="14.1.0.0-prerelease"
__MSBUILD_PATH=$__PACKAGES_DIR/$__MSBUILD_PACKAGE_ID/lib/MSBuild.exe

__BUILDERRORLEVEL=0

if [ ! -d "$__PROJECT_DIR" ]; then
   echo "ERROR: Cannot find project root path at '$__PROJECT_DIR'. Please pass in the source directory as the 1st parameter."
   exit 1
fi

if [ ! -d "$__PACKAGES_DIR" ]; then
   echo "ERROR: Cannot find packages path at '$__PACKAGES_DIR'. Please pass in the package directory as the 2nd parameter."
   exit 1
fi

if [ ! -e "$__NUGET_PATH" ]; then
   echo "ERROR: Cannot find nuget.exe at path '$__NUGET_PATH'. Please pass in the path to nuget.exe as the 3rd parameter."
   exit 1
fi

# Temporary hack to make dnu restore more reliable.
export MONO_THREADS_PER_CPU=2000

download_msbuild

mono $__MSBUILD_PATH "$__PACKAGES_DIR/Microsoft.DotNet.BuildTools/InitializeTools.proj" /t:RestoreBuildTools /v:diag /p:NuGetToolPath="$__NUGET_PATH" /p:PackagesDir="$__PACKAGES_DIR/" /p:ProjectDir="$__PROJECT_DIR/" /flp:v=diag;LogFile="$__PACKAGES_DIR/Microsoft.DotNet.BuildTools/InitializeTools.log"

exit $__BUILDERRORLEVEL

