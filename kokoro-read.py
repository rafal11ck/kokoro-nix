"""
Note: on Linux you need to run this as well: apt-get install portaudio19-dev

pip install kokoro-onnx sounddevice

wget https://github.com/thewh1teagle/kokoro-onnx/releases/download/model-files-v1.0/kokoro-v1.0.onnx
wget https://github.com/thewh1teagle/kokoro-onnx/releases/download/model-files-v1.0/voices-v1.0.bin

PHONEMIZER_ESPEAK_LIBRARY="/usr/local/Cellar/espeak-ng/1.52.0/lib/libespeak-ng.1.dylib" python examples/with_espeak_lib.py
"""

import os
import sys
import sounddevice as sd
from kokoro_onnx import Kokoro, EspeakConfig


if len(sys.argv) == 2:
    print(sys.argv[1])

text=sys.argv[1]

kokoro = Kokoro(
    "kokoro-v1.0.onnx",
    "voices-v1.0.bin",
    espeak_config=EspeakConfig(lib_path=os.getenv("PHONEMIZER_ESPEAK_LIBRARY")),
)
samples, sample_rate = kokoro.create(
    text, voice="af_sarah", speed=1.0, lang="en-us"
)
print("Playing audio...")
sd.play(samples, sample_rate)
sd.wait()
