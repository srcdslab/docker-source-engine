#!/bin/bash
##
#
# Variables
# TZ - Setup local timezone
# STEAM_USER, STEAM_PASS, STEAM_AUTH - Steam user setup. If a user has 2fa enabled it will most likely fail due to timeout. Leave blank for anon install.
# SRCDS_APPID - https://developer.valvesoftware.com/wiki/Dedicated_Servers_List
#
##

if [ -z ${TZ} ];
then
    export TZ=Europe/Paris;
fi

# ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

## just in case someone removed the defaults.
if [ "${STEAM_USER}" == "" ]; then
    echo -e "steam user is not set.\n"
    echo -e "Using anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
else
    echo -e "user set to ${STEAM_USER}"
fi

cd /app/steamcmd

## install game using steamcmd
./steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} +force_install_dir /app +app_update ${SRCDS_APPID} validate +quit ## other flags may be needed depending on install. looking at you cs 1.6

## set up 32 bit libraries
mkdir -p /app/.steam/sdk32
cp -v linux32/steamclient.so ../.steam/sdk32/steamclient.so

## set up 64 bit libraries
mkdir -p /app/.steam/sdk64
cp -v linux64/steamclient.so ../.steam/sdk64/steamclient.so

## run the server
./srcds_run -game ${SRCDS_GAMETYPE} -console -port ${SRCDS_GAME_PORT} -maxplayers ${SRCDS_MAXPLAYERS} -tickrate ${SRCDS_TICKRATE} -strictportbind -norestart +ip ${SRCDS_IP} +clientport ${SRCDS_CLIENT_PORT} +tv_port ${SRCDS_SOURCE_TV_PORT} +map ${SRCDS_MAP} +sv_setsteamaccount ${SRCDS_GSLT} ${SRCDS_ADDITIONAL_ARGS}
