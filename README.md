# Fourdfp

This package implements a simple 4dfp-reading function `Fourdfp.load(filename)` for the Julia language.

4dfp is a format for storing volumetric fMRI images, developed at Washington University in St. Louis by Avi Snyder. For further information, see its [documentation](https://4dfp.readthedocs.io/en/latest/format.html).

## Installation
Within Julia:
```
using Pkg
Pkg.add(url = "http://github.com/myersm0/Fourdfp.jl")
```

## Usage
Just call `Fourdfp.load(filename)`, optionally with a `byte_order` keyword argument (LittleEndian or BigEndian). If the latter is omitted, the package will attempt to determine your file's byte order by parsing its .ifh (inter-file header) file.
```
my_data_array = Fourdfp.load(filename; byte_order = LittleEndian)
```
The return value will be an Array{Float32, 4}, where the fourth dimension is time.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://myersm0.github.io/Fourdfp.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://myersm0.github.io/Fourdfp.jl/dev/)
[![Build Status](https://github.com/myersm0/Cifti.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/myersm0/Fourdfp.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/myersm0/Cifti.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/myersm0/Fourdfp.jl)
