using Fourdfp
using Test

data_dir = joinpath(dirname(@__FILE__), "data")
mask_path = joinpath(data_dir, "glm_atlas_mask_333.4dfp.img")
func_path = joinpath(data_dir, "functional_image_333.4dfp.img")

@testset "Fourdfp.jl" begin
	mask = Fourdfp.load(mask_path; byte_order = BigEndian)
	@test mask isa Array{Float32, 4}
	func = Fourdfp.load(func_path; byte_order = LittleEndian)
	@test func isa Array{Float32, 4}

	# should be able to load the func file correctly without specifying endianness
	# because endianness is specified in its .ifh file
	func_duplicate = Fourdfp.load(func_path)
	@test func == func_duplicate

	# the mask file however does not specify endianness in the ifh so this should error:
	@test_throws ErrorException Fourdfp.load(mask_path)

	@test Fourdfp.get_dims(mask_path) == [48, 64, 48, 1]
	@test Fourdfp.get_dims(func_path) == [48, 64, 48, 5]

	mask_inds = findall(mask .!= 0)
	@test length(mask_inds) == 65549
	@test all([all(func[:, :, :, f][mask_inds] .!= 0) for f in 1:5])
	@test maximum(abs.(func)) < 5
	@test all(mask[mask_inds] .== 1)
	@test sum(func .!= 0) == 5 * length(mask_inds)
end

