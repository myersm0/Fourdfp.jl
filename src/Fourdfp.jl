
module Fourdfp

using Chain

"Trim off .4dfp.* file extension, if any, from a filename"
get_imgroot(filename::String) = replace(filename, r".4dfp.(ifh|hdr|img(.rec)?)$" => "")

"The 'matrix size' lines in a .4dfp.ifh file gives the size of each data dimension"
function get_dims(filename::String)::Vector{Int}
	@chain begin
		"$(get_imgroot(filename)).4dfp.ifh"
		readlines
		filter(x -> !isnothing(match(r"^matrix size", x)), _)
		replace.(_, r".* ([0-9]+)" => s"\1")
		parse.(Int, _)
	end
end

function get_endianness(filename::String)::String
	endianness =
		@chain begin
			"$(Fourdfp.get_imgroot(filename)).4dfp.ifh"
			readlines
			filter(x -> !isnothing(match(r"^imagedata byte order", x)), _)
			replace.(_, r".*:= (\w+)" => s"\1")
		end
	if length(endianness) == 1
		@assert endianness[1] in ("littleendian", "bigendian")
		return endianness[1]
	else
		@assert length(endianness) == 0
		return "littleendian"
	end
end

"""
    load(filename; dtype = Float32)

A very basic 4dfp-reading function; doesn't yet take endianness into account!

Filename sould be the path of a 4dfp file, optionally omitting the file extension.
"""
function load(filename::String; dtype::Type = Float32)::Array{dtype, 4}
	imgroot = get_imgroot(filename)
	dims = get_dims(imgroot)
	dsize = sizeof(dtype)
	nvoxels = prod(dims[1:3])
	nframes = length(dims) < 4 ? 1 : dims[4]
	bytes_per_frame = dsize * nvoxels
	bytes_to_read = nframes * bytes_per_frame
	temp = zeros(UInt8, bytes_to_read)
	open("$imgroot.4dfp.img", "r") do fid
		readbytes!(fid, temp, bytes_to_read)
	end
	endianness = get_endianness(filename)
	byte_order_fn = endianness == "littleendian" ? ltoh : ntoh
	@chain reinterpret(dtype, temp) byte_order_fn.(_) reshape(_, dims...)
end

end

