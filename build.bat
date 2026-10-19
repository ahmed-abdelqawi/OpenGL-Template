@echo off
setlocal enabledelayedexpansion

:: ---- project settings ------------------------------------------------
set NAME=LearnOpenGl-App
set STD=c++17
set GLAD=external\glad
set GLFW=external\glfw
set LIBS=-L%GLFW%\lib -lglfw3 -lopengl32 -lgdi32 -luser32 -lshell32

:: ---- arguments: build [debug|release|clean] [run] ---------------------
set MODE=%1
if "%MODE%"=="" set MODE=debug

if /I "%MODE%"=="clean" (
    if exist build rmdir /s /q build
    echo Cleaned.
    exit /b 0
)

if not exist build mkdir build

:: collect every .cpp file in src\
set SOURCES=
for %%f in (src\*.cpp) do set SOURCES=!SOURCES! "%%f"

:: ---- flags -------------------------------------------------------------
set INCLUDES=-I%GLAD%\include -I%GLFW%\include

if /I "%MODE%"=="release" (
    set OPT=-O2 -DNDEBUG
) else (
    set OPT=-g -O0
)

set CXXFLAGS=-std=%STD% -Wall -Wextra %INCLUDES% %OPT%
set CFLAGS=%INCLUDES% %OPT%

:: ---- glad (C code, built once per mode) --------------------------------
set GLAD_OBJ=build\glad_%MODE%.o
if not exist %GLAD_OBJ% (
    clang -c -x c %CFLAGS% %GLAD%\src\glad.c -o %GLAD_OBJ%
    if errorlevel 1 exit /b 1
)

:: ---- main build ----------------------------------------------------------
clang++ %CXXFLAGS% %SOURCES% %GLAD_OBJ% %LIBS% -o build\%NAME%.exe
if errorlevel 1 exit /b 1

if /I "%2"=="run" build\%NAME%.exe
