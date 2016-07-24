using Conda
using Base.Test

pkg = "jupyter"
already_installed = pkg in Conda._installed_packages()

println( Conda.exists(pkg) )
Conda.add(pkg)

#@unix_only curl_path = joinpath(Conda.PREFIX, "bin", "curl-config")
@windows_only begin
    using BinDeps
    manager = Conda.Manager([pkg])
    curl_libpath = BinDeps.libdir(manager, "")
    #curl_path = joinpath(curl_libpath, "curl.exe")
end

#@test isfile(curl_path)
#
#@test isfile(joinpath(Conda.BINDIR, basename(curl_path)))

Conda.rm(pkg)
#Conda.rm("curl")
#@unix_only @test !isfile(curl_path)

if already_installed
    Conda.add(pkg)
end

@test isfile(joinpath(Conda.SCRIPTDIR, "conda" * @windows ? ".exe": ""))

@test isfile(joinpath(Conda.PYTHONDIR, "python" * @windows ? ".exe": ""))

channels = Conda.channels()
@test (isempty(channels) || channels == ["defaults"])

Conda.add_channel("foo")
@test Conda.channels() == ["foo", "defaults"]

Conda.rm_channel("foo")
channels = Conda.channels()
@test (isempty(channels) || channels == ["defaults"])
