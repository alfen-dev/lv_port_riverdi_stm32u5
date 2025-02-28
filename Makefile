

DEBUG ?= 1
ifeq ($(DEBUG), 1)
$(info Debug build)
else
$(info Release build)
endif

VERBOSE ?= 0
ifeq ($(VERBOSE), 1)
$(info Verbose build)
endif

################################################################################

TARGET=riverdi-50-stm32u5-lvgl

################################################################################

# MCU type (From CubeIDE)
MCU         = cortex-m33
CHIP        = STM32U599xx
CHIP_DETAIL = STM32U5A5
TARGET_DIR  = targetASC10
TARGET_FILE = ASC10
TOOLCHAIN   = arm-none-eabi

TOOLCHAIN_PREFIX = C:/ST/STM32CubeIDE_1.17.0/STM32CubeIDE/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.12.3.rel1.win32_1.1.0.202410251130/tools

TOOLCHAIN_BIN_DIR = $(TOOLCHAIN_PREFIX)/bin
TOOLCHAIN_INC_DIR = $(TOOLCHAIN_PREFIX)/$(TOOLCHAIN)/include
TOOLCHAIN_LIB_DIR = $(TOOLCHAIN_PREFIX)/$(TOOLCHAIN)/lib
TOOLCHAIN_TOOL_DIR = $(TOOLCHAIN_PREFIX)/$(TOOLCHAIN)/bin

# Toolchain prefix
AR          = $(TOOLCHAIN_BIN_DIR)/$(TOOLCHAIN)-ar
CC          = $(TOOLCHAIN_BIN_DIR)/$(TOOLCHAIN)-gcc
CXX         = $(TOOLCHAIN_BIN_DIR)/$(TOOLCHAIN)-g++
LD          = $(TOOLCHAIN_BIN_DIR)/$(TOOLCHAIN)-g++
#AS          = $(CC) -x assembler-with-cpp
AS          = $(TOOLCHAIN_BIN_DIR)/$(TOOLCHAIN)-as
NM          = $(TOOLCHAIN_BIN_DIR)/$(TOOLCHAIN)-nm
SIZE        = size -d
OBJCOPY     = $(TOOLCHAIN_TOOL_DIR)/objcopy
OBJDUMP     = $(TOOLCHAIN_TOOL_DIR)/objdump    
RM          = rm -f
MD          = mkdir -p



################################################################################

ifeq ($(DEBUG), 1)
	BUILD_FOLDER:=build/debug
else
	BUILD_FOLDER:=build/release
endif

BIN_LIB_FOLDER:=$(BUILD_FOLDER)/bin


################################################################################

ifeq ($(DEBUG), 1)
	CFLAGS +=-DDEBUG
	CFLAGS +=-g3 
	CFLAGS +=-Og

	ASFLAGS +=-DDEBUG
	ASFLAGS +=-g3 
else
	CFLAGS +=-DNDEBUG
	CFLAGS +=-O3

	ASFLAGS +=-DNDEBUG
endif

	CFLAGS +=-mcpu=$(MCU)
# Allow strptime:
	CFLAGS +=-D_GNU_SOURCE
	CFLAGS +=-DUSE_HAL_DRIVER 
	CFLAGS +=-D$(CHIP) 
	CFLAGS +=-c
	CFLAGS +=-ffunction-sections 
	CFLAGS +=-fdata-sections 
	CFLAGS +=-Wall 
	CFLAGS +=-fstack-usage 
	CFLAGS +=-fcyclomatic-complexity 
	CFLAGS +=--specs=nano.specs 
	CFLAGS +=-mfpu=fpv5-sp-d16 
	CFLAGS +=-mfloat-abi=hard 
	CFLAGS +=-mthumb 

	CPPFLAGS := $(CFLAGS)

	CFLAGS +=-std=gnu17

	CPPFLAGS +=-std=gnu++17

################################################################################

	ASFLAGS +=-mfloat-abi=hard
	ASFLAGS +=-mthumb
	ASFLAGS +=-mcpu=cortex-m33
	ASFLAGS +=-c
	ASFLAGS +=-x assembler-with-cpp
	ASFLAGS +=--specs=nano.specs
	ASFLAGS +=-mfpu=fpv5-sp-d16
	ASFLAGS +=-mfloat-abi=hard
	ASFLAGS +=-mthumb


################################################################################

NEMA:=nemagfx-float-abi-hard
NEMA_LIB_FOLDER:=./Middlewares/Third_Party/LVGL/lvgl/libs/nema_gfx/lib/core/cortex_m33/gcc
LVGL:=lvgl
BIN_LIB_FOLDER=$(BUILD_FOLDER)/bin

LVGL_LIB=$(BIN_LIB_FOLDER)/lib$(LVGL).a


	LD_SCRIPT   = STM32CubeIDE/STM32U599NJHXQ_FLASH.ld

	LD_FLAGS    += -L$(NEMA_LIB_FOLDER)
	LD_FLAGS    += -L$(BIN_LIB_FOLDER)

	LD_FLAGS    += -T$(LD_SCRIPT)
	LD_FLAGS    +=-mcpu=$(MCU)
	LD_FLAGS    += -Wl,-Map="$(MAP)"
	LD_FLAGS    += --specs=nosys.specs 
	LD_FLAGS    += -Wl,-gc-sections 
	LD_FLAGS    += -static 
	LD_FLAGS    += --specs=nano.specs 
	LD_FLAGS    += -mfpu=fpv5-sp-d16 
	LD_FLAGS    += -mfloat-abi=hard 
	LD_FLAGS    += -mthumb 
	LD_FLAGS    += -Wl,--start-group 
	LD_FLAGS    += -lc 
	LD_FLAGS    += -lm 
	LD_FLAGS    += -lstdc++ 
	LD_FLAGS    += -lsupc++ 
	LD_FLAGS    += -l$(NEMA)
	LD_FLAGS    += -l$(LVGL)
	LD_FLAGS    += -Wl,--end-group

################################################################################

SOURCES=
SOURCES+=$(wildcard ./Core/Src/*.c)
SOURCES+=$(wildcard ./Shared/*.c)
SOURCES+=$(wildcard ./Middlewares/Third_Party/FreeRTOS/Source/*.c)
SOURCES+=$(wildcard ./Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM33_NTZ/non_secure/*.c)
SOURCES+=$(wildcard ./Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS_V2/*.c)
SOURCES+=$(wildcard ./Middlewares/Third_Party/RTT/RTT/*.c)
SOURCES+=$(wildcard ./STM32CubeIDE/Application/User/Startup/*.s)
SOURCES+=$(wildcard ./Middlewares/Third_Party/FreeRTOS/Source/portable/MemMang/*.c)
SOURCES+=$(wildcard ./Drivers/STM32U5xx_HAL_Driver/Src/*.c)
SOURCES+=$(wildcard ./STM32CubeIDE/Application/User/Core/*.c)
SOURCES+=$(wildcard ./STM32CubeIDE/Application/User/Core/*.cpp)
SOURCES+=$(wildcard ./STM32CubeIDE/Application/User/Resources/*.c)

ifeq ($(VERBOSE), 1)
$(info SOURCES $(SOURCES))
endif

################################################################################

INC_DIRS+=./Shared
INC_DIRS+=./Core/Inc
INC_DIRS+=./Middlewares/Third_Party/LVGL/lvgl/libs/nema_gfx/include
INC_DIRS+=./Drivers/STM32U5xx_HAL_Driver/Inc
INC_DIRS+=./Drivers/CMSIS/Device/ST/STM32U5xx/Include
INC_DIRS+=./Drivers/CMSIS/Include
INC_DIRS+=./Middlewares/Third_Party/FreeRTOS/Source/include
INC_DIRS+=./Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM33_NTZ/non_secure
INC_DIRS+=./Middlewares/Third_Party/CMSIS/RTOS2/Include
INC_DIRS+=./Middlewares/Third_Party/LVGL
INC_DIRS+=./Middlewares/Third_Party/RTT/Config
INC_DIRS+=./Middlewares/Third_Party/RTT/RTT


INC_DIRS+=$(dir $(SOURCES))
INC_DIRS:=$(patsubst %/,%,$(INC_DIRS))
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))
INC_DIRS:=$(call uniq,$(INC_DIRS))

INC_FLAGS := $(addprefix -I,$(INC_DIRS))

ifeq ($(VERBOSE), 1)
$(info INC_DIRS $(INC_DIRS))
endif

################################################################################

ELF=$(BUILD_FOLDER)/bin/$(TARGET).elf
HEX=$(BUILD_FOLDER)/bin/$(TARGET).hex
MAP=$(BUILD_FOLDER)/bin/$(TARGET).map

################################################################################

# object files to create
OBJECTS=$(patsubst %,%.o,$(SOURCES))
OBJECTS:=$(addprefix $(BUILD_FOLDER)/,$(OBJECTS))

ifeq ($(VERBOSE), 1)
$(info OBJECTS $(OBJECTS))
endif

################################################################################

# Mention each dependency file as a target (with an empty rule),
# so that make won’t fail if the file doesn’t exist.
# $(DEPFILES):
# 	@echo out...... $@

DEPS:=$(patsubst %.o,%.d,$(OBJECTS))
include $(wildcard $(DEPS))

ifeq ($(VERBOSE), 1)
$(info DEPS $(DEPS))
endif

.PRECIOUS: %.d

################################################################################

# This rule checks for the folder using a 'folder' file
%.f:
	@echo Make folder $(@D)
	$(MD) $(@D)
	@echo touch $@
	echo "" > $@

.PRECIOUS: %.f

$(BUILD_FOLDER)/%.c.o: %.c $(BUILD_FOLDER)/%.c.d | $(BUILD_FOLDER)/%.f
	@echo Building C $@ and $(@D)/$(*F).c.d in $(@D) using $<
	@$(CC) $(DEFINE_FLAGS) $(INC_FLAGS) $(CFLAGS) -MMD -MP -MF"$(@D)/$(*F).c.d" -o $@ $<

$(BUILD_FOLDER)/%.cpp.o: %.cpp $(BUILD_FOLDER)/%.cpp.d | $(BUILD_FOLDER)/%.f
	@echo Building CPP $@ and $(@D)/$(*F).cpp.d in $(@D) using $<
	$(CXX) $(DEFINE_FLAGS) $(INC_FLAGS) $(CPPFLAGS) -MMD -MP -MF"$(@D)/$(*F).cpp.d" -o $@ $<

$(BUILD_FOLDER)/%.s.o: %.s | $(BUILD_FOLDER)/%.f
	@echo Building ASM $@ and $(@D)/$(*F).c.d in $(@D) using $<
	$(LD) $(ASFLAGS) -MMD -MP -MF"$(@D)/$(*F).s.d" -o "$@" "$<"

#	CFLAGS +=-MMD 
#	CFLAGS +=-MP 

# arm-none-eabi-gcc 
#     "../Application/User/Core/asc11_ui.c" 
#     -mcpu=cortex-m33 
#     -std=gnu11 
#     -g3 
#     -DDEBUG -DUSE_HAL_DRIVER 
#     -DSTM32U599xx 
#     -c 
#     -I../../Core/Inc 
#     -I../../Drivers/STM32U5xx_HAL_Driver/Inc 
#     -I../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy 
#     -I../../Drivers/CMSIS/Device/ST/STM32U5xx/Include 
#     -I../../Drivers/CMSIS/Include 
#     -I../../Middlewares/Third_Party/FreeRTOS/Source/include/ 
#     -I../../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM33_NTZ/non_secure/ 
#     -I../../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS_V2/ 
#     -I../../Middlewares/Third_Party/CMSIS/RTOS2/Include/ 
#     -I../../Middlewares/Third_Party/LVGL/ 
#     -I../../Middlewares/Third_Party/RTT/RTT 
#     -I../../Middlewares/Third_Party/RTT/Config 
#     -I"C:/Work/asc11_riverdi/riverdi-50-stm32u5-lvgl/STM32CubeIDE/Debug/Middlewares" 
#     -I"C:/Work/asc11_riverdi/riverdi-50-stm32u5-lvgl/Middlewares/Third_Party/LVGL/lvgl/src/extra/libs/qrcode" 
#     -Og
#     -ffunction-sections 
#     -fdata-sections 
#     -Wall 
#     -fstack-usage 
#     -fcyclomatic-complexity 
#     -MMD 
#     -MP 
#     -MF"Application/User/Core/asc11_ui.d" 
#     -MT"Application/User/Core/asc11_ui.o" 
#     --specs=nano.specs 
#     -mfpu=fpv5-sp-d16 
#     -mfloat-abi=hard 
#     -mthumb 
#     -o "Application/User/Core/asc11_ui.o"	

.PHONY: all clean

all: $(ELF) $(HEX)
	@echo --- Builded $(ELF) ...
	$(CXX) --version

$(info "$(BUILD_FOLDER)/%.elf")

libraries:
	@echo --- Building libraries $@...
	$(MAKE) -f Makefile.lvgl -j 1 DEBUG=1 all

#build/debug/bin/riverdi-50-stm32u5-lvgl.elf: libraries $(LVGL_LIB) $(OBJECTS) $(LD_SCRIPT) | build/debug/bin/riverdi-50-stm32u5-lvgl.f
#$(BUILD_FOLDER)/bin/%.elf: libraries $(LVGL_LIB) $(OBJECTS) $(LD_SCRIPT) | $(BUILD_FOLDER)/bin/%.f
#$(BUILD_FOLDER)/%.elf: libraries $(LVGL_LIB) $(OBJECTS) $(LD_SCRIPT) | $(BUILD_FOLDER)/%.f

build/debug/bin/riverdi-50-stm32u5-lvgl.elf: libraries $(LVGL_LIB) $(OBJECTS) $(LD_SCRIPT) | build/debug/bin/riverdi-50-stm32u5-lvgl.f
	@echo --- Link $@...
	$(LD) -o $@ $(OBJECTS) $(LD_FLAGS)

# show contents of library:
#$(BUILD_FOLDER)/%.a: $(OBJECTS) | $(BUILD_FOLDER)/%.f
#	@echo --- Link $@...
#	@$(AR) rcu $@ $(OBJECTS)

$(BUILD_FOLDER)/%.a:
	@echo --- using build $@...


# arm-none-eabi-g++ 
#     -o "riverdi-50-stm32u5-lvgl.elf" @"objects.list"   
#     -mcpu=cortex-m33 
#     -T"C:/Work/asc11_riverdi/riverdi-50-stm32u5-lvgl/STM32CubeIDE/STM32U599NJHXQ_FLASH.ld" 
#     --specs=nosys.specs 
#     -Wl,-Map="riverdi-50-stm32u5-lvgl.map" 
#     -Wl,-gc-sections 
#     -static 
#     --specs=nano.specs 
#     -mfpu=fpv5-sp-d16 
#     -mfloat-abi=hard 
#     -mthumb 
#     -Wl,--start-group 
#     -lc 
#     -lm 
#     -lstdc++ 
#     -lsupc++ 
#     -Wl,--end-group



$(HEX): $(ELF)
	@echo --- Make hex $(HEX)...
	@$(OBJCOPY) -O ihex $(ELF) $(HEX)


.PHONY: all clean

clean:
	@echo --- Clean $(BUILD_FOLDER)...
	@$(RM) $(BUILD_FOLDER)

%.d: ;
include $(wildcard $(DEPS))