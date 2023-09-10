
module Fourdfp

using Chain

"trim off .4dfp.* file extension, if any, from a filename"
get_imgroot(filename::String) = replace(filename, r".4dfp.(ifh|hdr|img(.rec)?)$" => "")

"the 'matrix size' lines in the ifh file gives the size of each dimension"
function get_dims(filename::String)::Vector{Int}
	@chain begin
		"$(get_imgroot(filename)).4dfp.ifh"
		readlines
		filter(x -> !isnothing(match(r"^matrix size", x)), _)
		replace.(_, r".* ([0-9]+)" => s"\1")
		parse.(Int, _)
	end
end

"a very basic 4dfp-reading function; doesn't yet take endianness into account!"
function read_4dfp(filename::String; dtype = Float32)::Array{dtype, 4}
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
	@chain reinterpret(dtype, temp) reshape(_, dims...)
end
export read_4dfp

end

