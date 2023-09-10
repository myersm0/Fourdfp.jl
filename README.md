# Fourdfp

[![Build Status](https://github.com/myersm0/Fourdfp.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/myersm0/Fourdfp.jl/actions/workflows/CI.yml?query=branch%3Amain)

This package implements a basic 4dfp-reading function (`read_4dfp(filename; dtype = Float32`) for the Julia language. Currently it assumes the image data is stored in little-endian byte order.

4dfp is a format for storing volumetric fMRI images, developed at Washington University in St. Louis by Avi Snyder. For further information, see its [documentation](https://4dfp.readthedocs.io/en/latest/format.html).
