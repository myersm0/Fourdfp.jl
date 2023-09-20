using Fourdfp
using Test

data_dir = joinpath(dirname(@__FILE__), "data")
mask_path = joinpath(data_dir, "glm_atlas_mask_333.4dfp.img")
func_path = joinpath(data_dir, "functional_image_333.4dfp.img")

@testset "Fourdfp.jl" begin
	@test Fourdfp.load(mask_path) isa Array{Float32, 4}
	@test Fourdfp.load(func_path) isa Array{Float32, 4}

	mask = Fourdfp.load(mask_path)
	func = Fourdfp.load(func_path)

	@test Fourdfp.get_dims(mask_path) == [48, 64, 48, 1]
	@test Fourdfp.get_dims(func_path) == [48, 64, 48, 5]

	mask_inds = findall(mask .!= 0)
	@test length(mask_inds) == 65549
	@test all([all(func[:, :, :, f][mask_inds] .!= 0) for f in 1:5])
	@test sum(func .!= 0) == 5 * length(mask_inds)
end

