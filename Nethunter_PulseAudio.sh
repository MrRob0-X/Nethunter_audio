#!/usr/bin/env bash
# Credits to :
# t.me/@Pero_Sar1111 for Paraphrasing the base script.
# t.me/@MrRobin_Ho_Od for the idea of the project(ALT script https://github.com/MrRob0-X/Nethunter_audio/blob/main/audio).

# Define color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Configuration
PULSE_AUDIO_IP="127.0.0.1"  # IP address for the TCP stream
PULSE_AUDIO_PORT="8000"     # Port for the TCP stream
PULSE_AUDIO_RATE="48000"    # Sample rate
PULSE_AUDIO_FORMAT="s16le"  # Audio format
PULSE_AUDIO_CHANNELS="2"    # Number of audio channels
MODULE_NAME="module-simple-protocol-tcp"

# Check PulseAudio status and configure it accordingly 
function start_pulseaudio() {
    pulseaudio --check 2>/dev/null || pulseaudio --start > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Failed to start PulseAudio.${NC}"
        if ! command -v pulseaudio &>/dev/null; then
            echo -e "${YELLOW}PulseAudio is not installed.${NC}"
            echo -e "${BLUE}Would you like to install it now? (yes/no):${NC}"
            read -r response
            if [[ "$response" =~ ^([Yy][Ee][Ss]|[Yy])$ ]]; then
                echo -e "${GREEN}Installing PulseAudio...${NC}"
                sudo apt-get update && sudo apt-get install -y pulseaudio
                echo -e "${GREEN}PulseAudio installed successfully.${NC}"
            else
                echo -e "${RED}PulseAudio is required for audio services to function properly. Exiting setup.${NC}"
            fi
        else
            echo -e "${RED}Please check your PulseAudio installation and try again.${NC}"
        fi
        exit 1
    fi
}

# Load the TCP module for audio streaming and enhance audio quality
function start_stream() {
    # Check if the TCP module is already loaded
    if pactl list modules | grep -q "$MODULE_NAME"; then
        echo -e "${YELLOW}Audio stream is already active on $PULSE_AUDIO_IP:$PULSE_AUDIO_PORT.${NC}"
        return
    fi

    # Start the TCP module
    pactl load-module "$MODULE_NAME" rate="$PULSE_AUDIO_RATE" format="$PULSE_AUDIO_FORMAT" \
        channels="$PULSE_AUDIO_CHANNELS" source=auto_null.monitor record=true \
        port="$PULSE_AUDIO_PORT" listen="$PULSE_AUDIO_IP" > /dev/null 2>&1

    if [[ $? -eq 0 ]]; then
        echo -e "${YELLOW}Starting the TCP module.${NC}"
        echo -e "${GREEN}Audio stream started on $PULSE_AUDIO_IP:$PULSE_AUDIO_PORT.${NC}"
        
        # Set audio quality
        pactl set-sink-volume @DEFAULT_SINK@ 100%  # Sets volume to 100%
        pactl set-sink-mute @DEFAULT_SINK@ 0       # Ensures sound is unmuted
        echo -e "${GREEN}Audio quality enhanced: Volume set to 100% and unmuted.${NC}"
    else
        echo -e "${RED}Failed to start audio stream. Please check PulseAudio configuration.${NC}"
    fi
}

# Unload the TCP module and stop PulseAudio if no other modules are in use
function stop_stream() {
    module_id=$(pactl list short modules | grep "$MODULE_NAME" | awk '{print $1}')
    if [[ -n "$module_id" ]]; then
        pactl unload-module "$module_id"
        echo -e "${YELLOW}Audio stream stopped.${NC}"

        # Check if PulseAudio should be stopped
        remaining_modules=$(pactl list short modules)
        if [[ -z "$remaining_modules" ]]; then
            pulseaudio --kill
            echo "PulseAudio stopped."
        fi
    else
        echo -e "${YELLOW}No audio stream found or confiured at this time.${NC}"
    fi
}

# Check the status of the audio stream
function stream_status() {
    module_id=$(pactl list short modules | grep "$MODULE_NAME" | awk '{print $1}')
    if [[ -n "$module_id" ]]; then
        echo -e "${GREEN}Audio stream is running on $PULSE_AUDIO_IP:$PULSE_AUDIO_PORT.${NC}"
    else
        echo -e "${YELLOW}Audio stream is not running.${NC}"
    fi
}

# Main logic for handling start, stop, and status commands
case "$1" in
    start)
        start_pulseaudio
        start_stream
        ;;
    stop)
        stop_stream
        ;;
    status)
        stream_status
        ;;
    *)
        echo -e "${BLUE}Usage: $0 {start|stop|status}${NC}" >&2
        exit 1
        ;;
esac
