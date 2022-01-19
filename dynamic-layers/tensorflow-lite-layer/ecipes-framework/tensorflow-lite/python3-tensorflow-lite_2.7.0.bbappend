TUNE_CCARGS:raspberrypi2 = "-mthumb -mfpu=neon-vfpv4 -mfloat-abi=hard -mcpu=cortex-a7"
HOST_ARCH:raspberrypi2 = "armv7"
EXTRA_OECMAKE:remove:raspberrypi2 = "-DTFLITE_ENABLE_XNNPACK=ON"
EXTRA_OECMAKE:raspberrypi2 += "-DTFLITE_ENABLE_XNNPACK=OFF"

TUNE_CCARGS:raspberrypi3 = "-mthumb -mfpu=neon-vfpv4 -mfloat-abi=hard -mcpu=cortex-a7"
HOST_ARCH:raspberrypi3 = "armv7"
EXTRA_OECMAKE:remove:raspberrypi3 = "-DTFLITE_ENABLE_XNNPACK=ON"
EXTRA_OECMAKE:raspberrypi3 += "-DTFLITE_ENABLE_XNNPACK=OFF"

EXTRA_OECMAKE:raspberrypi3-64 += "-DTFLITE_ENABLE_XNNPACK=ON"