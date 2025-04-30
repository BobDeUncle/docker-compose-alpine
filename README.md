# Alpine XFCE VNC Gaming Environment

A containerized Alpine Linux desktop environment with XFCE, VNC, and gaming emulators (RetroArch and Dolphin) pre-installed. This project provides a lightweight, portable gaming environment that can be run on any system with Docker support, including NVIDIA GPU passthrough.

## Features

- **Lightweight Alpine Linux** base with XFCE desktop
- **VNC and Web VNC** access (ports 5900 and 6080)
- **Gaming Emulators**:
  - RetroArch for multiple classic consoles
  - Dolphin Emulator for GameCube and Wii
- **Full GPU Acceleration** with NVIDIA support
- **Persistent Storage** for configurations and game files
- **Audio Support** through PulseAudio
- **Controller Support** via device passthrough

## Prerequisites

- Docker Engine (20.10+)
- Docker Compose
- NVIDIA GPU + NVIDIA Container Toolkit (for GPU acceleration)

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/BobDeUncle/docker-compose-alpine.git
   cd docker-compose-alpine
   ```

2. Build the Docker image:
   ```bash
   docker build -t my-alpine-desktop .
   ```

3. Start the container:
   ```bash
   docker-compose up -d
   ```

4. Connect to the desktop environment:
   - VNC Client: Connect to `localhost:5900` with password: `YOUR_PASSWORD`
   - Web Browser: Navigate to `http://localhost:6080`

## Configuration

### VNC Password

The default VNC password is set to `YOUR_PASSWORD`. Change this in the `docker-compose.yml` file:

```yaml
environment:
  - VNC_PASSWORD=YOUR_NEW_PASSWORD
```

### Persistent Storage

The container uses several volume mounts to persist data:

- `/config`: Application configuration
- `/root`: Root user home directory
- `/shared`: Shared files accessible from host
- `/opt`: Optional software
- `/usr/local`: Custom installed software
- `/roms`: ROM files for emulators

### GPU Acceleration

This container is configured to use NVIDIA GPUs. Ensure you have the NVIDIA Container Toolkit installed:

```bash
# Install NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

## Usage

### RetroArch

1. Launch RetroArch from the applications menu
2. Configure controllers via Settings → Input
3. Add ROMs by placing them in the `/roms` directory
4. Load cores and content through the RetroArch interface

### Dolphin Emulator

1. Launch Dolphin from the applications menu
2. Configure controllers via Controllers menu
3. Add GameCube/Wii games by placing ISO/ROM files in the `/roms` directory
4. Load games through the Dolphin interface

## System Customization

### Installing Additional Software

You can install additional software by modifying the Dockerfile:

```dockerfile
RUN apk add --no-cache your-package-name
```

Or from within the container:

```bash
apk add --no-cache your-package-name
```

### Enabling Audio

Audio is supported through PulseAudio socket mapping. If you encounter audio issues:

1. Ensure your host system is running PulseAudio
2. Verify the socket path in docker-compose.yml matches your system
3. Test audio from within the container:
   ```bash
   speaker-test -c2
   ```

## Troubleshooting

### No Display Connection

If you can't connect to the VNC server:

1. Check that ports 5900 and 6080 are not in use
2. Verify container is running: `docker ps`
3. Check container logs: `docker logs alpinexfcevnc`

### GPU Acceleration Issues

If GPU acceleration isn't working:

1. Verify NVIDIA drivers are installed on host
2. Check NVIDIA Container Toolkit configuration
3. Run `nvidia-smi` on host to verify GPU status
4. Inspect container logs for GPU-related errors

### Controller Not Detected

If your game controller isn't detected:

1. Ensure the controller is connected before starting the container
2. Check permissions on /dev/input devices
3. Try connecting the controller directly to the container:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

## License

This Alpine setup is provided under the MIT License.

## Acknowledgements

- Based on [edgelevel/alpine-xfce-vnc](https://github.com/edgelevel/alpine-xfce-vnc)
- RetroArch: [https://www.retroarch.com](https://www.retroarch.com)
- Dolphin Emulator: [https://dolphin-emu.org](https://dolphin-emu.org)
