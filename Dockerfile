FROM edgelevel/alpine-xfce-vnc:latest

# ========================================================
# System Dependencies
# ========================================================

# Install core applications
RUN apk add --no-cache \
    xfce4-terminal \
    firefox \
    retroarch \
    dolphin-emu \
    dolphin-emu-doc

# ========================================================
# Graphics Libraries
# ========================================================

# Install graphics and rendering dependencies
RUN apk add --no-cache \
    # Mesa libraries
    mesa-dri-gallium \
    mesa-egl \
    mesa-gl \
    mesa-gles \
    # X11 libraries
    libx11 \
    libxcb \
    libxext \
    libxfixes \
    libxshmfence \
    libxxf86vm \
    libxrandr \
    libxinerama \
    libxi

# ========================================================
# Vulkan Support
# ========================================================

# Add Vulkan support (required for modern Dolphin)
RUN apk add --no-cache \
    vulkan-headers \
    vulkan-loader \
    vulkan-tools \
    glslang

# ========================================================
# Audio Configuration
# ========================================================

# Install audio libraries and utilities
RUN apk add --no-cache \
    alsa-lib \
    alsa-plugins \
    alsa-utils \
    alsa-plugins-pulse \
    pulseaudio \
    pulseaudio-alsa

# Create default ALSA configuration
RUN mkdir -p /etc/alsa && \
    echo 'pcm.!default { type plug slave.pcm "null" } ctl.!default { type hw card 0 }' > /etc/asound.conf

# Create a PulseAudio config that works in containers
RUN mkdir -p /etc/pulse && \
    echo 'default-server = unix:/tmp/pulse-socket autospawn = no daemon-binary = /bin/true enable-memfd = yes' > /etc/pulse/client.conf

# ========================================================
# Game Dependencies
# ========================================================

# Install SDL and other game dependencies
RUN apk add --no-cache \
    libstdc++ \
    sdl2 \
    sdl2_image \
    sdl2_mixer \
    sdl2_ttf \
    openal-soft

# ========================================================
# Input Devices Support
# ========================================================

# For controllers and input devices
RUN apk add --no-cache \
    libevdev \
    eudev \
    udev \
    bluez \
    bluez-deprecated \
    dbus

# Fix permissions issues
RUN mkdir -p /dev/input && chmod 777 /dev/input

# ========================================================
# NVIDIA Support
# ========================================================

# Add NVIDIA support
RUN mkdir -p /usr/local/nvidia/lib && \
    ln -s /usr/lib/libGLX_nvidia.so.0 /usr/local/nvidia/lib/ || true && \
    ln -s /usr/lib/libEGL_nvidia.so.0 /usr/local/nvidia/lib/ || true

# Set environment variables for NVIDIA
ENV LD_LIBRARY_PATH="/usr/local/nvidia/lib:/usr/lib"
