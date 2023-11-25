#!/usr/bin/env python

import argparse
import sys
sys.path.append("/usr/lib64/freecad/lib64/")
sys.path.append("/usr/lib64/freecad/Mod/OpenSCAD")

import FreeCAD
import importCSG
import importDXF


def csg_to_dxf(in_file, topo_name, out_file):
    """Convert a component from a scad file to a dxf file."""
    doc = importCSG.open(in_file)
    for d in doc.TopologicalSortedObjects:
        if d.FullName == topo_name:
            importDXF.export([d], out_file)
            FreeCAD.closeDocument(doc.Name)
            return True
    return False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        "OpenSCAD file to DXF converter using FreeCAD"
    )

    parser.add_argument("-i", "--in-file", type=str,
                        help="input scad file")
    parser.add_argument("-n", "--topo-name", type=str,
                        help="FullName of the part to convert")
    parser.add_argument("-o", "--out-file", type=str,
                        help="output dxf file")

    args = parser.parse_args()

    if csg_to_dxf(args.in_file, args.topo_name, args.out_file) is False:
        print(f"error: topological name '{args.topo_name}' "
              f"not found in '{args.in_file}'")
        sys.exit(1)
