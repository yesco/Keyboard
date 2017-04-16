# Keyboard

Aspiration is to lasercut a functional keyboard with functional electrical switches.

The current experimential ideas:
- lasercut keys with hinges that bounces and make keys movable
- have foamy stuff below
- make electrical connection of wire/paths by a kind of xy-grid
- decode by simple circuit, output serial ascii? esp8266 coprocessor

## Cutting

- wood: 2.7mm playwood speed:30 power:55
- plexiglas: according to wiki

## Problems

Sometimes some shapes makes problem.

- Inkscape: Path-ObjectToPath, Extensions-ModifyPath-FlattenBezier 0.1
- Cutter: Select All, make one color, some colors make problem
- The characters seems to make it take forever to "prepare", delete them?

# Box

## Problems

- OpenSCAD doesn't choose unit, edit SVG file exported add "mm" at top tag
- Use svg, don't export to dxf as it's not good (?)
- Make sure bottom board doesn't cut off peg
  (object union, change to no fill)
- Then export to DXF

## lizzie

that's a thing

- when you import the image into inkscape, you need to go to document properties in inkscape and change the units to mm, and "1 user unit per mm" (edited)
- then when you save it as a dxf, you need to select "px" as the unit to export it as
- i have no clue why but it gets me things the size I expect.


