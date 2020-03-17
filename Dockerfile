FROM mcr.microsoft.com/dotnet/core/sdk:3.1.100

ENV MONO_VERSION 6.6.0.161

#
# https://github.com/mono/docker/blob/master/6.6.0.161/slim/Dockerfile
#

RUN apt-get update \
  && apt-get install -y --no-install-recommends gnupg dirmngr \
  && rm -rf /var/lib/apt/lists/* \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && gpg --batch --export --armor 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /etc/apt/trusted.gpg.d/mono.gpg.asc \
  && gpgconf --kill all \
  && rm -rf "$GNUPGHOME" \
  && apt-key list | grep Xamarin \
  && apt-get purge -y --auto-remove gnupg dirmngr

RUN echo "deb http://download.mono-project.com/repo/debian stable-stretch/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official-stable.list \
  && apt-get update \
  && apt-get install -y mono-runtime \
  && rm -rf /var/lib/apt/lists/* /tmp/*

#
# https://github.com/mono/docker/blob/master/6.6.0.161/Dockerfile
#

RUN apt-get update \
  && apt-get install -y binutils curl mono-devel ca-certificates-mono fsharp mono-vbnc nuget referenceassemblies-pcl \
  && rm -rf /var/lib/apt/lists/* /tmp/*

#
# Installing nuget.exe
#

RUN apt-get update \
  && apt-get install -y wget \
  && wget -O nuget.exe https://dist.nuget.org/win-x86-commandline/v5.4.0/nuget.exe
RUN mono nuget.exe source Add -Name louiechannel -Source "https://nuget.pkg.github.com/louiechannel/index.json" -UserName "antonmirko.ukr@gmail.com" -Password "556d56dd739eec98c893b256f299485ff62c1b75"
