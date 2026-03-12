#!/bin/bash

blender --background blender-4.1-splash.blend --python-expr "import bpy; scene = bpy.context.scene; print(f'Frames: {scene.frame_start} - {scene.frame_end}')" -- --quit 2>/dev/null | grep Frames
