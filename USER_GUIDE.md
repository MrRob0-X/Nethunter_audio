# User Guide for Nethunter Audio Script

This guide provides instructions on how to use the Nethunter Audio script for audio streaming using PulseAudio.

## Table of Contents
- [Introduction](#introduction)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Start Audio Streaming](#start-audio-streaming)
  - [Stop Audio Streaming](#stop-audio-streaming)
  - [Check Audio Stream Status](#check-audio-stream-status)
- [Troubleshooting](#troubleshooting)
- [Screenshots](#screenshots)

## Introduction
The Nethunter Audio script allows users to stream audio over TCP using PulseAudio. This is particularly useful for remote audio applications.

## Requirements
- [Kali NetHunter](https://www.kali.org/docs/nethunter/) installed on your device.
- PulseAudio installed and configured.
- Basic knowledge of using terminal commands.

## Installation
To install PulseAudio, run the following command in your terminal:
```bash
sudo apt-get update && sudo apt-get install -y pulseaudio
```

## Usage

### Start Audio Streaming
To start the audio streaming, use the following command:
```bash
./Nethunter_PulseAudio.sh start
```
- This command will check if PulseAudio is running, start it if necessary, and load the TCP module for audio streaming.

### Stop Audio Streaming
To stop the audio streaming, run:
```bash
./Nethunter_PulseAudio.sh stop
```
- This will unload the TCP module and stop PulseAudio if no other modules are in use.

### Check Audio Stream Status
To check if the audio stream is running, use:
```bash
./Nethunter_PulseAudio.sh status
```
- This will display whether the audio stream is active along with any relevant error codes.

## Troubleshooting
- If you encounter issues starting PulseAudio, ensure it is installed and configured correctly.
- Common errors may include connection failures. Refer to the error messages for guidance.

## Screenshots

![In App Connection](assets/NetHunterAudio_1.jpg) 

![In App Disconnection](assets/NetHunterAudio_2.jpg)

![Checking Stream Status](assets/NetHunterTerm_1.jpg)

![Running script without installing pulseaudio](assets/NetHunterTerm_2.jpg)


