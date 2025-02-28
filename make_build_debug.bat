@echo off

set PATH=%PATH%;C:\Program Files\CMake\bin;C:\ST\STM32CubeIDE_1.17.0\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.make.win32_2.2.0.202409170845\tools\bin


make -j 1 DEBUG=1 all

