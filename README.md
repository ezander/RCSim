# RCSim - Rollercoaster Simulator

A 3D physics-based rollercoaster simulator with multiple visualization frontends, demonstrating ODE integration, spline-based track modeling, and software architecture patterns.

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Building](#building)
- [Running the Simulator](#running-the-simulator)
- [Available Visualizations](#available-visualizations)
- [Keyboard Controls](#keyboard-controls)
- [Track Files](#track-files)
- [Project Structure](#project-structure)
- [Technical Details](#technical-details)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Features

- **Realistic Physics Simulation**: ODE-based simulation with gravity, friction, and air drag
- **Mathematical Track Modeling**: Hermite splines and parametric curves
- **Multiple Visualization Options**:
  - Java3D - Full 3D rendering with advanced graphics
  - JavaFX - Modern 3D scene graph visualization
  - Swing - GUI with file chooser and dual-view support
  - Terminal - Text-based output for debugging
- **Custom Track Support**: Load tracks from XML files (.rct format)
- **Multiple Camera Views**: Inside coach, behind, left/right, tracking cameras
- **Interactive Controls**: Pause, resume, and control camera views

## Architecture

RCSim follows a modular, layered architecture with Observer/MVC pattern:

```
┌─────────────────────────────────────────────────────┐
│              Visualization Layer                    │
│  ┌──────────┐ ┌──────────┐ ┌───────┐ ┌──────────┐   │
│  │ Java3D   │ │ JavaFX   │ │ Swing │ │ Terminal │   │
│  └──────────┘ └──────────┘ └───────┘ └──────────┘   │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│            GraphicsSupport Layer                    │
│  (Camera System, Terrain, Abstractions)             │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│              Simulation Core                        │
│  (Physics, ODE Integration, Track Model)            │
└─────────────────────────────────────────────────────┘
```

**Modules:**
- **Simulator**: Core simulation engine with physics and track modeling
- **GraphicsSupport**: Platform-independent graphics abstractions
- **RCDemoJ3D**: Java3D-based 3D visualization
- **RCDemoJFX**: JavaFX-based 3D visualization
- **RCDemoSwing**: Swing GUI with file chooser
- **RCDemoTerminal**: Text-based terminal output

## Prerequisites

### Required Software

1. **Java Development Kit (JDK) 8 or later**
   - Must include JDK, not just JRE (needs `javac` compiler)
   - Java 8 recommended for full compatibility
   - Download: [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://openjdk.org/)

2. **Apache Maven**
   - Build and dependency management tool
   - Version 3.6+ recommended

### Installation by Platform

#### Ubuntu/Debian Linux

```bash
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk maven
```

#### Fedora/RHEL/CentOS

```bash
sudo dnf install java-11-openjdk-devel maven
# or on older systems:
sudo yum install java-11-openjdk-devel maven
```

#### macOS

Using Homebrew:

```bash
brew install openjdk@11 maven
```

#### Windows

1. **Install JDK 11+:**
   - Download from [Oracle](https://www.oracle.com/java/technologies/downloads/) or [Adoptium](https://adoptium.net/)
   - Add to PATH: `C:\Program Files\Java\jdk-11\bin`

2. **Install Apache Maven:**
   - Download from [Apache Maven](https://maven.apache.org/download.cgi)
   - Extract and add to PATH: `C:\apache-maven-x.x.x\bin`

3. **For Git Bash or WSL:**
   - Use the build script as on Linux

### Verify Installation

```bash
# Check Java version (should be 11 or higher)
java -version
javac -version

# Check Maven version
mvn -version
```

Expected output:
```
openjdk version "11.0.x"
Apache Maven 3.x.x
```

## Installation

### Clone or Download

```bash
# If using git
cd /path/to/your/projects
git clone <repository-url> rcsim
cd rcsim

# Or download and extract the ZIP file
```

## Building

### Using the Build Script (Recommended)

The `build.sh` script provides a convenient way to build and run the project.

#### Build All Modules

```bash
./build.sh build
```

#### Build Individual Module

```bash
./build.sh build Simulator
./build.sh build RCDemoJ3D
# etc.
```

#### Clean Build Artifacts

```bash
./build.sh clean
```

### Using Maven Directly

Maven handles the full multi-module build automatically:

```bash
# Build and install all modules
mvn install

# Clean build (recommended after switching branches)
mvn clean install

# Skip tests for faster builds
mvn install -DskipTests

# Build only a specific module and its dependencies
mvn install -DskipTests -pl RCDemoJ3D --also-make
```

All dependencies (Apache Commons Math, Java3D, OpenJFX) are downloaded automatically from Maven Central on the first build.

## Running the Simulator

### Quick Start

```bash
# Build everything (first time only)
./build.sh build

# Run Java3D demo (recommended for best graphics)
./build.sh run-java3d

# Run JavaFX demo (modern, lightweight)
./build.sh run-javafx

# Run Swing demo (GUI with file chooser)
./build.sh run-swing

# Run Terminal demo (text output)
./build.sh run-terminal
```

### Running with Maven Directly

```bash
# Build first (required once)
mvn install -DskipTests

# Run each demo
mvn exec:java -pl RCDemoTerminal
mvn exec:java -pl RCDemoJFX
mvn exec:java -pl RCDemoJ3D
mvn exec:java -pl RCDemoSwing
```

### Running with Custom Tracks

```bash
# Run with a specific track file
./build.sh run-java3d Simulator/src/main/resources/tracks/colossos.rct
./build.sh run-javafx Simulator/src/main/resources/tracks/bigloop.rct
```

### Get Help

```bash
./build.sh help
```

## Available Visualizations

### 1. Java3D Demo (RCDemoJ3D)

**Best for:** Full 3D graphics with advanced rendering features

**Features:**
- Full 3D rendering using Java3D
- Fractal terrain generation
- Multiple camera views
- Smooth animation

**Run:**
```bash
./build.sh run-java3d [track-file]
```

**Requirements:**
- Java3D libraries (downloaded automatically by Maven)
- OpenGL support

### 2. JavaFX Demo (RCDemoJFX)

**Best for:** Modern 3D visualization with JavaFX scene graph

**Features:**
- JavaFX 3D scene graph
- Modern UI framework
- Cross-platform 3D support
- Built into Java 8+

**Run:**
```bash
./build.sh run-javafx [track-file]
```

**Requirements:**
- OpenJFX (managed automatically by Maven)

### 3. Swing Demo (RCDemoSwing)

**Best for:** GUI application with track file selection

**Features:**
- Traditional Swing GUI
- File chooser for track selection
- Dual-view split-pane interface
- Uses Java3D for rendering

**Run:**
```bash
./build.sh run-swing
```

**Usage:**
1. Launch the application
2. Use the file chooser to select a track file (.rct)
3. The simulation will start automatically

### 4. Terminal Demo (RCDemoTerminal)

**Best for:** Debugging, headless systems, or understanding physics

**Features:**
- Text-based output
- Shows position, velocity, acceleration
- No GUI required
- Lightweight

**Run:**
```bash
./build.sh run-terminal [track-file]
```

**Example Output:**
```
t=0.00  pos=(0.0, 5.0, 0.0)  vel=(10.0, 0.0, 0.0)  acc=(0.0, -9.81, 0.0)
t=0.01  pos=(0.1, 5.0, 0.0)  vel=(10.0, -0.1, 0.0)  acc=(0.0, -9.81, 0.0)
...
```

## Keyboard Controls

### 3D Visualization Demos (Java3D, JavaFX, Swing)

| Key             | Action                                  |
|-----------------|-----------------------------------------|
| **Space**       | Pause/Resume simulation                 |
| **ESC**         | Exit application                        |
| **Arrow Keys**  | Camera control (depends on camera mode) |
| **1-5**         | Switch camera views                     |
| **R**           | Reset simulation                        |
| **+/-**         | Adjust simulation speed                 |

**Camera Views:**
1. **Inside Coach** - First-person view from inside the rollercoaster
2. **Behind Coach** - Third-person view following the coach
3. **Left/Right** - Side views
4. **Static** - Fixed camera position
5. **Tracking** - Camera tracks the coach motion

*(Exact key mappings may vary by demo - see source code for details)*

## Track Files

Track files are stored in `Simulator/src/main/resources/tracks/` and use XML format with `.rct` extension.

### Built-in Tracks

| Track           | Description                                      |
|-----------------|--------------------------------------------------|
| `colossos.rct`  | Complex track with 38+ pillars, loops and turns  |
| `bigloop.rct`   | Simple track with a large vertical loop          |

### Track File Format

Tracks are defined using XML with the following structure:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<RollerCoaster xmlns="http://rollercoaster-schema.tv">
  <Track>
    <General>
      <Name>Track Name</Name>
      <Author>Your Name</Author>
      <CreationDate>2024-01-01</CreationDate>
    </General>
    <SimulationParameters>
      <Speed>1.0</Speed>
      <Scale>1.0</Scale>
      <Direction>1</Direction>
    </SimulationParameters>
    <PillarList>
      <Pillar>
        <PosX>0.0</PosX>
        <PosY>5.0</PosY>
        <PosZ>0.0</PosZ>
        <YawX>10.0</YawX>
        <YawY>0.0</YawY>
        <YawZ>0.0</YawZ>
        <YawAngle>0.0</YawAngle>
      </Pillar>
      <!-- More pillars... -->
    </PillarList>
  </Track>
</RollerCoaster>
```

### Creating Custom Tracks

1. Copy an existing track file from `Simulator/src/main/resources/tracks/`
2. Modify the pillar positions and orientations
3. Save with a new name (e.g., `mytrack.rct`)
4. Run with: `./build.sh run-java3d Simulator/src/main/resources/tracks/mytrack.rct`

**Track Design Tips:**
- Each pillar defines a control point for the Hermite spline
- `PosX/Y/Z`: Position in 3D space (meters)
- `YawX/Y/Z`: Direction vector for the spline tangent
- `YawAngle`: Rotation angle around the track axis
- Ensure smooth transitions between pillars for realistic physics

## Project Structure

```
rcsim/
├── build.sh                    # Convenience build/run script
├── pom.xml                     # Parent Maven POM
├── README.md                   # This file
│
├── Simulator/                  # Core simulation engine
│   ├── src/
│   │   ├── main/java/de/tubs/wire/simulator/         # Simulation framework
│   │   ├── main/java/de/tubs/wire/simulator/math/    # Mathematical utilities
│   │   ├── main/java/de/tubs/wire/simulator/physics/ # Physics models
│   │   ├── main/java/de/tubs/wire/simulator/track/   # Track representations
│   │   ├── main/java/de/tubs/wire/simulator/io/      # File I/O
│   │   └── main/resources/tracks/                    # Track files (.rct)
│   ├── target/                                        # Build output
│   └── pom.xml
│
├── GraphicsSupport/            # Graphics abstractions
│   ├── src/
│   │   ├── main/java/de/tubs/wire/graphics/          # Graphics toolkit
│   │   ├── main/java/de/tubs/wire/graphics/camera/   # Camera system
│   │   └── main/java/de/tubs/wire/graphics/terrain/  # Terrain generation
│   ├── target/
│   └── pom.xml
│
├── RCDemoJ3D/                  # Java3D visualization
│   ├── src/main/java/de/tubs/wire/rcdemoj3d/         # Java3D implementation
│   ├── target/
│   └── pom.xml
│
├── RCDemoJFX/                  # JavaFX visualization
│   ├── src/main/java/de/tubs/wire/rcdemo/            # JavaFX implementation
│   ├── target/
│   └── pom.xml
│
├── RCDemoSwing/                # Swing GUI
│   ├── src/main/java/RCSwing.java                    # Swing implementation
│   ├── target/
│   └── pom.xml
│
└── RCDemoTerminal/             # Terminal output
    ├── src/main/java/de/tubs/wire/rcterm/            # Terminal implementation
    ├── target/
    └── pom.xml
```

## Technical Details

### Physics Simulation

- **ODE Integration**: Classical Runge-Kutta and Higham-Hall 5(4) methods
- **Force Models**:
  - Gravity: Constant downward force (9.81 m/s²)
  - Drag: Air resistance proportional to velocity squared
  - Friction: Track friction (configurable)
- **Track Constraints**: Coach is constrained to follow the spline path
- **Time Stepping**: Adaptive time stepping for accuracy

### Track Modeling

- **Hermite Splines**: Closed cubic Hermite splines for smooth curves
- **Parametric Representation**: Track defined by parameter t ∈ [0, 1]
- **Pillar-based**: Track defined by control points (pillars) with positions and tangents
- **Automatic Closure**: Spline automatically connects back to start

### Design Patterns

- **Observer Pattern**: Simulation notifies observers of state changes
- **Strategy Pattern**: Interchangeable force models and camera strategies
- **Template Method**: Abstract Simulator class with concrete implementations
- **Factory Pattern**: CameraFactory for creating different camera types
- **Adapter Pattern**: Platform-specific graphics implementations

### Libraries Used

| Library                              | Version         | Purpose                         |
|--------------------------------------|-----------------|---------------------------------|
| Apache Commons Math                  | 3.5             | ODE solvers, linear algebra     |
| org.scijava j3dcore/j3dutils/vecmath | 1.6.0-scijava-2 | Java3D 3D rendering (J3D demos) |
| OpenJFX                              | 11.0.2          | 3D scene graph (JFX demo)       |
| Swing                                | Built-in        | GUI framework                   |

## Troubleshooting

### Build Issues

**Problem**: `mvn: command not found`

**Solution**: Install Apache Maven
```bash
# Ubuntu/Debian
sudo apt-get install maven

# macOS
brew install maven
```

**Problem**: `javac: command not found`

**Solution**: Install JDK (not just JRE)
```bash
# Ubuntu/Debian
sudo apt-get install openjdk-11-jdk

# macOS
brew install openjdk@11
```

**Problem**: Build fails with dependency resolution errors

**Solution**: Check internet connectivity (Maven downloads dependencies on first build). If behind a proxy, configure `~/.m2/settings.xml`. Then retry:
```bash
mvn clean install -DskipTests
```

### Runtime Issues

**Problem**: Java3D demos don't start or crash

**Solution**: Ensure OpenGL support
- Linux: Install mesa drivers (`sudo apt-get install libgl1-mesa-glx`)
- macOS: Should work out of the box
- Windows: Update graphics drivers

**Problem**: JavaFX demo doesn't run

**Solution**: OpenJFX is managed by Maven and downloaded automatically. Ensure you built with `mvn install -DskipTests` before running. If the issue persists, try running directly:
```bash
mvn exec:java -pl RCDemoJFX
```

**Problem**: Window is blank or black screen

**Solution**:
- Check OpenGL support: `glxinfo | grep OpenGL` (Linux)
- Try a different demo: `./build.sh run-javafx`
- Reduce graphics settings in track file

**Problem**: Simulation runs very slowly

**Solution**:
- Reduce number of pillars in track file
- Close other applications
- Use Terminal demo for debugging without graphics

### Track File Issues

**Problem**: Track file doesn't load

**Solution**:
- Ensure XML is well-formed
- Check file path is correct
- Verify namespace: `xmlns="http://rollercoaster-schema.tv"`
- Check for missing closing tags

## Development

### Building Javadoc

```bash
mvn javadoc:javadoc
# Documentation will be in target/site/apidocs/
```

### Running Tests

```bash
mvn test -pl Simulator
```

### Code Style

The project follows standard Java conventions:
- Classes: `PascalCase`
- Methods/variables: `camelCase`
- Constants: `UPPER_SNAKE_CASE`
- Packages: lowercase

## License

This project is licensed under the **GNU General Public License v3.0** (GPL-3.0).

See LICENSE file for details.

## Credits

**Author**: Elmar Zander (ezander)
**Institution**: TU Braunschweig - Institute for Scientific Computing (WIRE)
**Purpose**: Educational software engineering project

## Contributing

This is an educational project. If you're a student:
- Experiment with the code
- Create custom tracks
- Try implementing new visualization frontends
- Explore different physics models

## Further Reading

- **ODE Integration**: [Apache Commons Math Documentation](https://commons.apache.org/proper/commons-math/userguide/ode.html)
- **Java3D**: [Java3D Tutorial](https://www.java3d.org/)
- **Hermite Splines**: [Cubic Hermite Spline on Wikipedia](https://en.wikipedia.org/wiki/Cubic_Hermite_spline)
- **Observer Pattern**: [Design Patterns by Gang of Four](https://refactoring.guru/design-patterns/observer)

## Contact

For questions, issues, or contributions, please use the project's issue tracker or contact the maintainer.

---

**Happy Simulating!** Enjoy exploring the physics of rollercoasters with RCSim.
