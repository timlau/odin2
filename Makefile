NAME = Odin2
BUILD_OPTIONS = -D ODIN2_COPY_PLUGIN_AFTER_BUILD=OFF
BUILD_DIR = build
BUILD_TYPE = Release
CXXFLAGS = $(shell rpm --eval '%{build_cxxflags}')
BUILDROOT = $(shell pwd)/BUILDROOT


all: build

clean:
	@echo "Cleaning build directory : ${BUILD_DIR}"
	@rm -rf ${BUILD_DIR}
.PHONY: clean	

setup:
	cmake -B ${BUILD_DIR} -S . -D CMAKE_BUILD_TYPE=${BUILD_TYPE} ${BUILD_OPTIONS}
.PHONY: setup

# Used locally install libs, if they exist
setup-local:
	cmake -B ${BUILD_DIR} -S . -D CMAKE_BUILD_TYPE=${BUILD_TYPE} ${BUILD_OPTIONS} -DCPM_USE_LOCAL_PACKAGES=ON
.PHONY: setup-local

setup-debug:
	cmake -B ${BUILD_DIR} -S . -D CMAKE_BUILD_TYPE=Debug ${BUILD_OPTIONS} 
.PHONY: setup-debug

setup-rpm-flags:
	CXXFLAGS="${CXXFLAGS}" cmake -B ${BUILD_DIR} -S . -D CMAKE_BUILD_TYPE=Release ${BUILD_OPTIONS} -DCPM_USE_LOCAL_PACKAGES=ON -DLIB_INSTALL_DIR:PATH=/usr/lib64 -DCMAKE_INSTALL_PREFIX:PATH=/usr
.PHONY: setup-rpm-flag

build: setup
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE}
.PHONY: build

build-local: setup-local
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE}
.PHONY: build-local

build-rpm-flags: setup-rpm-flags
	cmake --build ${BUILD_DIR} --config Release 
.PHONY: build-rpm-flags

build-standalone: setup-local
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE} --target ${NAME}_Standalone --verbose
.PHONY: build-standalone

build-clap: setup-local
	cmake --build ${BUILD_DIR} --config ${BUILD_TYPE} --target ${NAME}_CLAP
.PHONY: build-clap

inst-clap: build-clap
	@mkdir -p BUILDROOT
	cmake --install ${BUILD_DIR} --config ${BUILD_TYPE} --component ${NAME}_CLAP --prefix BUILDROOT
.PHONY: inst-clap

build-debug: setup-debug
	cmake --build ${BUILD_DIR} --config Debug --target ${NAME}_Standalone
.PHONY: build-debug

run:
	./${BUILD_DIR}/Odin2_artefacts/${BUILD_TYPE}/Standalone/${NAME}
.PHONY: run

run-debug:
	./${BUILD_DIR}/Odin2_artefacts/Debug/Standalone/${NAME}
.PHONY: run-debug

install-buildroot:
	@rm -rf ${BUILDROOT}
	@mkdir -p {BUILDROOT}
	DESTDIR=${BUILDROOT} cmake --install ${BUILD_DIR} --config Release 
