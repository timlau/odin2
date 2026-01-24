NAME = Odin2
BUILD_OPTIONS = -D ODIN2_COPY_PLUGIN_AFTER_BUILD=OFF 
BUILD_DIR = cmake-build-${NAME}
BUILD_TYPE = Release

all: build

init-submodules:
	@git submodule update --init --recursive

clean:
	@echo "Cleaning build directory : ${BUILD_DIR}"
	@rm -rf ${BUILD_DIR}

setup:
	cmake -B ${BUILD_DIR} -S . -D CMAKE_BUILD_TYPE=${BUILD_TYPE} ${BUILD_OPTIONS}

# Used locally install libs, if they exist
setup-local:
	cmake -B ${BUILD_DIR} -S . -D CMAKE_BUILD_TYPE=${BUILD_TYPE} ${BUILD_OPTIONS} -DCPM_USE_LOCAL_PACKAGES=ON

build: setup
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE}

build-local: setup-local
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE} 

build-standalone: setup-local
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE} --target ${NAME}_Standalone

build-clap: setup-local
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE} --target ${NAME}_CLAP

run:
	./${BUILD_DIR}/Odin2_artefacts/${BUILD_TYPE}/Standalone/${NAME}

PHONY: all init-submodules clean setup build setup-local-libs
