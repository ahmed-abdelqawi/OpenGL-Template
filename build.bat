@echo off
setlocal enabledelayedexpansion

:: ---- project settings ------------------------------------------------
set NAME=LearnOpenGl-App
set STD=c++17
set GLAD=external\glad
set GLFW=external\glfw

:: ---- arguments: build [clang|gcc] [debug|release] [run] | build clean ---
set CC_NAME=clang
set MODE=debug
set RUN=
set CLEAN=
for %%a in (%*) do (
    if /I "%%a"=="clang"   set CC_NAME=clang
    if /I "%%a"=="gcc"     set CC_NAME=gcc
    if /I "%%a"=="debug"   set MODE=debug
    if /I "%%a"=="release" set MODE=release
    if /I "%%a"=="run"     set RUN=1
    if /I "%%a"=="clean"   set CLEAN=1
)

if defined CLEAN (
    if exist build rmdir /s /q build
    echo Cleaned.
    exit /b 0
)

:: ---- toolchain -----------------------------------------------------------
if /I "%CC_NAME%"=="gcc" (
    set CC=gcc
    set CXX=g++
    set GLFW_LIB=%GLFW%\lib-mingw-w64
    set LDFLAGS=-static
) else (
    set CC=clang
    set CXX=clang++
    set GLFW_LIB=%GLFW%\lib-vc2022
    set LDFLAGS=
)

where %CXX% >nul 2>&1
if errorlevel 1 (
    echo Error: %CXX% not found in PATH.
    exit /b 1
)

set LIBS=-L%GLFW_LIB% -lglfw3 -lopengl32 -lgdi32 -luser32 -lshell32

:: each compiler gets its own output folder so objects and exes never mix
set OUT=build\%CC_NAME%
if not exist %OUT% mkdir %OUT%

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

echo [%CC_NAME% / %MODE%]

:: ---- glad (C code, built once per compiler and mode) ---------------------
set GLAD_OBJ=%OUT%\glad_%MODE%.o
if not exist %GLAD_OBJ% (
    %CC% -c -x c %CFLAGS% %GLAD%\src\glad.c -o %GLAD_OBJ%
    if errorlevel 1 exit /b 1
)

:: ---- main build ----------------------------------------------------------
%CXX% %CXXFLAGS% %SOURCES% %GLAD_OBJ% %LIBS% %LDFLAGS% -o %OUT%\%NAME%.exe
if errorlevel 1 exit /b 1

if defined RUN "%OUT%\%NAME%.exe"
