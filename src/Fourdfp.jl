
module Fourdfp

using Chain

@enum ByteOrder LittleEndian BigEndian
export LittleEndian, BigEndian

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

function get_endianness(filename::String)::ByteOrder
	endianness =
		@chain begin
			"$(Fourdfp.get_imgroot(filename)).4dfp.ifh"
			readlines
			filter(x -> !isnothing(match(r"^imagedata byte order", x)), _)
			replace.(_, r".*:= (\w+)" => s"\1")
		end
	if length(endianness) == 1 && endianness[1] in ("littleendian", "bigendian")
		return endianness[1] == "littleendian" ? LittleEndian : BigEndian
	else
		error("Byte order (endianness) could not be parsed from ifh file for $filename")
	end
end

"""
	 load(filename; byte_order)

A simple 4dfp-reading function.

Filename sould be the path of a 4dfp file, optionally omitting the file extension.

Byte order should be one of LittleEndian or BigEndian; or omit this argument
and the function will attempt to parse the byte order from the .4dfp.ifh file.
"""
function load(filename::String; byte_order::Union{Nothing, ByteOrder} = nothing)
	imgroot = get_imgroot(filename)
	dims = get_dims(imgroot)
	dtype = Float32
	dsize = sizeof(dtype)
	nvoxels = prod(dims[1:3])
	nframes = length(dims) < 4 ? 1 : dims[4]
	bytes_per_frame = dsize * nvoxels
	bytes_to_read = nframes * bytes_per_frame
	temp = zeros(UInt8, bytes_to_read)
	open("$imgroot.4dfp.img", "r") do fid
		readbytes!(fid, temp, bytes_to_read)
	end
	if isnothing(byte_order) 
		byte_order = get_endianness(filename)
	end
	byte_order_fn = byte_order == LittleEndian ? ltoh : ntoh
	@chain reinterpret(dtype, temp) byte_order_fn.(_) reshape(_, dims...)
end

end

