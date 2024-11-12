@echo off

for %%f in (assets\icons\*.svg) do (
    echo Converting assets\icons\%%~nf.svg to assets\icons\%%~nf.svg.vec
    dart run vector_graphics_compiler -i assets\icons\%%~nf.svg -o assets\icons\%%~nf.svg.vec
)

echo All SVG files have been processed.