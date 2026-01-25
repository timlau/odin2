NAME = Odin2
BUILD_OPTIONS = -D ODIN2_COPY_PLUGIN_AFTER_BUILD=OFF
BUILD_DIR = cmake-build-${NAME}
BUILD_TYPE = Release
CXX_FLAGS := "${CXX_FLAGS} -Wp,-D_GLIBCXX_ASSERTIONS"


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

setup-debug:
	cmake -B ${BUILD_DIR} -S . -D CMAKE_BUILD_TYPE=Debug ${BUILD_OPTIONS} -DCPM_USE_LOCAL_PACKAGES=ON

build: setup
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE}

build-local: setup-local
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE}

build-standalone: setup-local
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE} --target ${NAME}_Standalone --verbose

build-clap: setup-local
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE} --target ${NAME}_CLAP

inst-clap: build-clap
	@mkdir -p BUILDROOT
	cmake --install ${BUILD_DIR} --config ${BUILD_TYPE} --component ${NAME}_CLAP --prefix BUILDROOT -v

build-debug: setup-debug
	cmake --build ${BUILD_DIR} --config Debug --target ${NAME}_Standalone

run:
	./${BUILD_DIR}/Odin2_artefacts/${BUILD_TYPE}/Standalone/${NAME}

run-debug:
	./${BUILD_DIR}/Odin2_artefacts/Debug/Standalone/${NAME}

display:
	@echo "CXX_FLAGS: ${CXX_FLAGS}"

.PHONY: all init-submodules clean setup build setup-local-libs
