CXX := kos32-g++
CC := kos32-gcc
LD := kos32-ld
SDK_DIR := /c/kolibri/contrib/sdk

CXXFLAGS := -c -fno-ident -O2 -std=c++11 -fomit-frame-pointer \
            -U__WIN32__ -U_Win32 -U_WIN32 -U__MINGW32__ -UWIN32 \
            -Wno-pointer-arith -Wall -DNO_OPENGL

INCLUDE := -I $(SDK_DIR)/sources/newlib/libc/include \
           -I $(SDK_DIR)/sources/libstdc++-v3/include \
           -I $(SDK_DIR)/sources/sdl2/includesmy \
           -I SpaceCadetPinball

LDFLAGS := -static -S -Tapp-dynamic.lds --image-base 0
LIBPATH := -L $(SDK_DIR)/lib

# Все объектные файлы (без imgui пока, добавим если нужно)
OBJS := SpaceCadetPinball/control.o \
        SpaceCadetPinball/EmbeddedData.o \
        SpaceCadetPinball/font_selection.o \
        SpaceCadetPinball/fullscrn.o \
        SpaceCadetPinball/gdrv.o \
        SpaceCadetPinball/GroupData.o \
        SpaceCadetPinball/high_score.o \
        SpaceCadetPinball/loader.o \
        SpaceCadetPinball/maths.o \
        SpaceCadetPinball/midi.o \
        SpaceCadetPinball/nudge.o \
        SpaceCadetPinball/options.o \
        SpaceCadetPinball/partman.o \
        SpaceCadetPinball/pb.o \
        SpaceCadetPinball/proj.o \
        SpaceCadetPinball/render.o \
        SpaceCadetPinball/score.o \
        SpaceCadetPinball/Sound.o \
        SpaceCadetPinball/SpaceCadetPinball.o \
        SpaceCadetPinball/TBall.o \
        SpaceCadetPinball/TBlocker.o \
        SpaceCadetPinball/TBumper.o \
        SpaceCadetPinball/TCircle.o \
        SpaceCadetPinball/TCollisionComponent.o \
        SpaceCadetPinball/TComponentGroup.o \
        SpaceCadetPinball/TDemo.o \
        SpaceCadetPinball/TDrain.o \
        SpaceCadetPinball/TEdgeManager.o \
        SpaceCadetPinball/TEdgeSegment.o \
        SpaceCadetPinball/TFlagSpinner.o \
        SpaceCadetPinball/TFlipper.o \
        SpaceCadetPinball/TFlipperEdge.o \
        SpaceCadetPinball/TGate.o \
        SpaceCadetPinball/THole.o \
        SpaceCadetPinball/timer.o \
        SpaceCadetPinball/TKickback.o \
        SpaceCadetPinball/TKickout.o \
        SpaceCadetPinball/TLight.o \
        SpaceCadetPinball/TLightBargraph.o \
        SpaceCadetPinball/TLightGroup.o \
        SpaceCadetPinball/TLightRollover.o \
        SpaceCadetPinball/TLine.o \
        SpaceCadetPinball/TOneway.o \
        SpaceCadetPinball/TPinballComponent.o \
        SpaceCadetPinball/TPinballTable.o \
        SpaceCadetPinball/TPlunger.o \
        SpaceCadetPinball/TPopupTarget.o \
        SpaceCadetPinball/TRamp.o \
        SpaceCadetPinball/translations.o \
        SpaceCadetPinball/TRollover.o \
        SpaceCadetPinball/TSink.o \
        SpaceCadetPinball/TSoloTarget.o \
        SpaceCadetPinball/TSound.o \
        SpaceCadetPinball/TTableLayer.o \
        SpaceCadetPinball/TTextBox.o \
        SpaceCadetPinball/TTextBoxMessage.o \
        SpaceCadetPinball/TTimer.o \
        SpaceCadetPinball/TTripwire.o \
        SpaceCadetPinball/TWall.o \
        SpaceCadetPinball/winmain.o \
        SpaceCadetPinball/zdrv.o \
        SpaceCadetPinball/imgui.o \
        SpaceCadetPinball/imgui_sdl.o \
        SpaceCadetPinball/imgui_draw.o \
        SpaceCadetPinball/imgui_widgets.o \
        SpaceCadetPinball/imgui_tables.o \
        SpaceCadetPinball/imgui_demo.o \
        SpaceCadetPinball/imgui_impl_sdl.o \
        SpaceCadetPinball/imgui_impl_sdlrenderer.o \
        SpaceCadetPinball/DebugOverlay.o

all: compile link finalize

compile: $(OBJS)

link: compile
	$(LD) $(LDFLAGS) $(LIBPATH) $(OBJS) -o pinball.elf \
		-lSDL2_mixer -lSDL2 -ltimidity -lvorbis -logg \
		-lstdc++ -lsupc++ -lgcc -lc.dll -lsound -ldll

finalize: link
	kos32-strip -s pinball.elf -o pinball
	kos32-objcopy pinball -O binary

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDE) -o $@ $<

clean:
	rm -vf $(OBJS) pinball.elf pinball

.PHONY: all compile link finalize clean