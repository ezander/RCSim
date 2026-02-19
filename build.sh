#!/bin/bash

# RCSim Build Script
# Builds and runs the Rollercoaster Simulator with different visualization frontends

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check Java version
check_java() {
    if ! command -v java &> /dev/null; then
        print_error "Java is not installed. Please install Java 11 or later."
        exit 1
    fi

    if ! command -v javac &> /dev/null; then
        print_error "Java compiler (javac) is not installed. Please install JDK 11 or later."
        exit 1
    fi

    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1-2)
    print_info "Java version: $JAVA_VERSION"
}

# Clean build artifacts
clean() {
    print_info "Cleaning build artifacts..."
    mvn clean
    print_success "Clean completed"
}

# Build a single module (and its dependencies) using Maven
build_module() {
    local module=$1
    local module_path="$SCRIPT_DIR/$module"

    if [ ! -d "$module_path" ]; then
        print_error "Module $module not found at $module_path"
        return 1
    fi

    print_info "Building $module..."
    mvn install -DskipTests -pl "$module" --also-make || {
        print_error "Failed to build $module"
        return 1
    }

    print_success "$module built successfully"
}

# Build all modules using Maven
build_all() {
    print_info "Building all modules..."
    mvn install -DskipTests || {
        print_error "Build failed"
        return 1
    }
    print_success "All modules built successfully"
}

# Run Java3D demo
run_java3d() {
    print_info "Starting Java3D demo..."

    # Check if built
    if [ ! -f "RCDemoJ3D/target/rcsim-demo-j3d-1.0-SNAPSHOT.jar" ]; then
        print_warning "RCDemoJ3D not built. Building now..."
        build_all
    fi

    if [ -n "$1" ]; then
        print_info "Running de.tubs.wire.rcdemoj3d.RCJava3d with track: $1"
        mvn exec:java -pl RCDemoJ3D -Dexec.args="$1"
    else
        print_info "Running de.tubs.wire.rcdemoj3d.RCJava3d"
        mvn exec:java -pl RCDemoJ3D
    fi
}

# Run JavaFX demo
run_javafx() {
    print_info "Starting JavaFX demo..."

    # Check if built
    if [ ! -f "RCDemoJFX/target/rcsim-demo-jfx-1.0-SNAPSHOT.jar" ]; then
        print_warning "RCDemoJFX not built. Building now..."
        build_all
    fi

    if [ -n "$1" ]; then
        print_info "Running de.tubs.wire.rcdemo.RCJavaFX with track: $1"
        mvn exec:java -pl RCDemoJFX -Dexec.args="$1"
    else
        print_info "Running de.tubs.wire.rcdemo.RCJavaFX"
        mvn exec:java -pl RCDemoJFX
    fi
}

# Run Swing demo
run_swing() {
    print_info "Starting Swing demo..."

    # Check if built
    if [ ! -f "RCDemoSwing/target/rcsim-demo-swing-1.0-SNAPSHOT.jar" ]; then
        print_warning "RCDemoSwing not built. Building now..."
        build_all
    fi

    if [ -n "$1" ]; then
        print_info "Running RCSwing with track: $1"
        mvn exec:java -pl RCDemoSwing -Dexec.args="$1"
    else
        print_info "Running RCSwing"
        mvn exec:java -pl RCDemoSwing
    fi
}

# Run Terminal demo
run_terminal() {
    print_info "Starting Terminal demo..."

    # Check if built
    if [ ! -f "RCDemoTerminal/target/rcsim-demo-terminal-1.0-SNAPSHOT.jar" ]; then
        print_warning "RCDemoTerminal not built. Building now..."
        build_all
    fi

    if [ -n "$1" ]; then
        print_info "Running de.tubs.wire.rcterm.RCTerminal with track: $1"
        mvn exec:java -pl RCDemoTerminal -Dexec.args="$1"
    else
        print_info "Running de.tubs.wire.rcterm.RCTerminal"
        mvn exec:java -pl RCDemoTerminal
    fi
}

# Show usage
show_usage() {
    cat << EOF
RCSim Build Script - Rollercoaster Simulator

Usage: $0 [COMMAND] [OPTIONS]

COMMANDS:
    build               Build all modules
    build <module>      Build a specific module (Simulator, GraphicsSupport, RCDemoJ3D, etc.)
    clean               Clean all build artifacts
    run-java3d          Run Java3D visualization demo
    run-javafx          Run JavaFX visualization demo
    run-swing           Run Swing GUI demo (with file chooser)
    run-terminal        Run terminal-based demo (text output)
    check-java          Check Java installation
    help                Show this help message

OPTIONS (for run commands):
    You can pass a track file as the first argument, e.g.:
    $0 run-java3d Simulator/src/main/resources/tracks/colossos.rct

EXAMPLES:
    $0 build                    # Build all modules
    $0 build Simulator          # Build only Simulator module (and its dependencies)
    $0 clean                    # Clean build artifacts
    $0 run-java3d               # Run Java3D demo with default track
    $0 run-javafx               # Run JavaFX demo
    $0 run-swing                # Run Swing GUI (opens file chooser)
    $0 run-terminal             # Run terminal demo

AVAILABLE TRACKS:
    Simulator/src/main/resources/tracks/colossos.rct
    Simulator/src/main/resources/tracks/bigloop.rct

KEYBOARD CONTROLS (for 3D demos):
    Space           - Pause/Resume simulation
    Arrow Keys      - Camera controls
    ESC             - Exit
    (See README.md for full controls)

EOF
}

# Main script logic
main() {
    # Check if Maven is installed
    if ! command -v mvn &> /dev/null; then
        print_error "Apache Maven is not installed. Please install Maven to build the project."
        print_info "On Ubuntu/Debian: sudo apt-get install maven"
        print_info "On macOS: brew install maven"
        exit 1
    fi

    # Parse command
    case "${1:-help}" in
        build)
            check_java
            if [ -z "$2" ]; then
                build_all
            else
                build_module "$2"
            fi
            ;;
        clean)
            clean
            ;;
        run-java3d|java3d)
            check_java
            shift
            run_java3d "$@"
            ;;
        run-javafx|javafx)
            check_java
            shift
            run_javafx "$@"
            ;;
        run-swing|swing)
            check_java
            shift
            run_swing "$@"
            ;;
        run-terminal|terminal)
            check_java
            shift
            run_terminal "$@"
            ;;
        check-java)
            check_java
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $1"
            echo
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
