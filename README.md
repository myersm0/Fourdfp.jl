# Fourdfp

This package implements a basic 4dfp-reading function (`read_4dfp(filename; dtype = Float32`) for the Julia language. Currently it assumes the image data is stored in little-endian byte order.

4dfp is a format for storing volumetric fMRI images, developed at Washington University in St. Louis by Avi Snyder. For further information, see its [documentation](https://4dfp.readthedocs.io/en/latest/format.html).

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://myersm0.github.io/Fourdfp.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://myersm0.github.io/Fourdfp.jl/dev/)
[![Build Status](https://github.com/myersm0/Cifti.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/myersm0/Fourdfp.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/myersm0/Cifti.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/myersm0/Fourdfp.jl)
